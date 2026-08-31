import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';

import '../db/app_database.dart';

/// Offline-first sync queue (spec §3 architecture rules, criterion 12.2).
/// Write → local DB (`synced=false`) → `sync_queue` → background flush to
/// the cloud gateway. Conflicts: settings — last-write-wins; transactions —
/// merge by id + timestamp (duplicates impossible via UUID v4).
///
/// Retries with exponential backoff: 1m → 2m → 4m → 8m → 16m → 32m (cap),
/// matching the airplane-mode test: nothing is lost, flush resumes on
/// connectivity.
class SyncQueueEngine {
  SyncQueueEngine(this._db, this._flusher, {this.now});

  final AppDatabase _db;
  final Future<bool> Function(SyncTask task) _flusher;
  final DateTime Function()? now;

  static const List<int> backoffSeconds = [60, 120, 240, 480, 960, 1920];
  static const int maxAttempts = 8;

  DateTime _now() => now?.call() ?? DateTime.now();

  /// Enqueue an entity change for cloud sync.
  Future<void> enqueue({
    required String entityId,
    required String entityType,
    required Map<String, Object?> payload,
  }) async {
    await _db.into(_db.syncQueue).insert(SyncQueueCompanion.insert(
          entityId: entityId,
          entityType: entityType,
          payloadJson: jsonEncode(payload),
          attempts: const Value(0),
          nextAttemptAt: _now().millisecondsSinceEpoch,
          createdAt: _now().millisecondsSinceEpoch,
        ));
  }

  /// Flush all due tasks. Returns the number of successfully synced tasks.
  /// Failures stay in the queue with a backoff-scheduled next attempt.
  Future<int> flush({int batchSize = 32}) async {
    final nowMs = _now().millisecondsSinceEpoch;
    final due = await (_db.select(_db.syncQueue)
          ..where((t) => t.nextAttemptAt.isSmallerOrEqualValue(nowMs))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(batchSize))
        .get();

    var ok = 0;
    for (final row in due) {
      final task = SyncTask(
        entityId: row.entityId,
        entityType: row.entityType,
        payload: jsonDecode(row.payloadJson) as Map<String, Object?>,
      );
      try {
        final success = await _flusher(task);
        if (success) {
          await (_db.delete(_db.syncQueue)..where((t) => t.id.equals(row.id))).go();
          ok++;
          continue;
        }
        await _markFailure(row, 'gateway returned false');
      } catch (e) {
        await _markFailure(row, e.toString());
      }
    }
    return ok;
  }

  Future<void> _markFailure(SyncQueueData row, String error) async {
    final attempts = row.attempts + 1;
    if (attempts >= maxAttempts) {
      // Keep the payload but park it (data loss is a critical bug — never drop).
      await (_db.update(_db.syncQueue)..where((t) => t.id.equals(row.id))).write(
        SyncQueueCompanion(
          attempts: Value(attempts),
          lastError: Value('parked: $error'),
          nextAttemptAt: Value(_now().add(const Duration(days: 1)).millisecondsSinceEpoch),
        ),
      );
      return;
    }
    final delay = backoffSeconds[(attempts - 1).clamp(0, backoffSeconds.length - 1)];
    await (_db.update(_db.syncQueue)..where((t) => t.id.equals(row.id))).write(
      SyncQueueCompanion(
        attempts: Value(attempts),
        lastError: Value(error),
        nextAttemptAt: Value(_now().add(Duration(seconds: delay)).millisecondsSinceEpoch),
      ),
    );
  }

  Future<int> pendingCount() async {
    final count = await _db.syncQueue.count().getSingle();
    return count;
  }

  /// Merge rule for contributions: by id + timestamp — the newest version of
  /// the same UUID wins; ids never collide (UUID v4).
  static bool shouldReplaceRemote({
    required DateTime localUpdatedAt,
    required DateTime remoteUpdatedAt,
  }) =>
      localUpdatedAt.isAfter(remoteUpdatedAt);
}

class SyncTask {
  const SyncTask({
    required this.entityId,
    required this.entityType,
    required this.payload,
  });
  final String entityId;
  final String entityType;
  final Map<String, Object?> payload;
}
