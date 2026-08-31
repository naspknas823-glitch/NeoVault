import 'dart:convert';
import 'dart:io';
import 'dart:math' show Random;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart' as sqlite3_open;
import 'package:uuid/uuid.dart';

import '../../core/db/app_database.dart';
import '../../core/sync/sync_queue.dart';
import '../cloud/cloud_gateway.dart';
import '../seed/seed_data.dart';

/// ── Database binding ────────────────────────────────────────────────────
/// Android: SQLCipher-encrypted file (⛔ §8.3). Tests: in-memory.
/// DI contract: MUST be overridden in bootstrap (main.dart) or tests.
/// This is a Riverpod override point, not an unfinished feature.
final dbProvider = Provider<AppDatabase>((ref) {
  throw StateError(
      'dbProvider must be overridden in bootstrap (see main.dart) or tests');
});

/// ── SQLCipher native loader (⛔ §8.3) ──────────────────────────────────
/// sqlcipher_flutter_libs ships libsqlcipher.so but does NOT register it as
/// the sqlite3 provider. Without `open.overrideFor` the sqlite3 package
/// silently falls back to the SYSTEM SQLite: (a) encryption is a no-op —
/// `PRAGMA key` is silently ignored; (b) old system engines (< 3.24) throw
/// on UPSERT (`insertOnConflictUpdate`) — the first such statement kills the
/// app BEFORE the first frame → permanent white screen on launch.
/// Loading the bundled SQLCipher 4.x (≈ SQLite 3.44) fixes both.
/// MUST run on every isolate that opens the database (globals are
/// per-isolate in dart:ffi): main isolate + DB isolate via `isolateSetup`.
void ensureSqlCipherLoaded() {
  if (!Platform.isAndroid) return;
  sqlite3_open.open.overrideFor(
    sqlite3_open.OperatingSystem.android,
    openCipherOnAndroid, // package helper: handles old-Android dlopen quirk.
  );
}

/// Real (file-based, SQLCipher) database used by the app bootstrap.
Future<AppDatabase> openRealDatabase({bool encrypted = true}) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'neovault.sqlite'));
  ensureSqlCipherLoaded();
  if (encrypted) {
    // Throws [KeystoreUnavailableException] when the Keystore cannot hold the
    // passphrase — main.dart turns that into the BootstrapErrorApp screen
    // (fail-fast: ⛔ we never downgrade to an unencrypted / plaintext-keyed
    // vault just to make the launch succeed).
    final passphrase = await resolveDbPassphrase(dir: dir);
    // Builds before the SQLCipher fix wrote a PLAINTEXT file (system sqlite
    // ignored PRAGMA key). SQLCipher cannot read those (SQLITE_NOTADB) →
    // park the legacy file and start a fresh encrypted vault.
    await _parkLegacyPlaintextDb(file);
    final keyPragma = pragmaKeyStatement(passphrase);
    return AppDatabase(
      NativeDatabase.createInBackground(
        file,
        setup: (raw) {
          raw.execute(keyPragma);
          raw.execute('PRAGMA cipher_page_size = 4096;');
        },
        isolateSetup: () async {
          // Runs inside the DB isolate BEFORE the engine is opened.
          await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
          ensureSqlCipherLoaded();
        },
      ),
    );
  }
  return AppDatabase(NativeDatabase.createInBackground(file));
}

/// ── SQLCipher passphrase lifecycle (⛔ §8.3) ────────────────────────────
/// Secure-storage entry holding the vault passphrase (Android Keystore via
/// EncryptedSharedPreferences).
const String kDbPassphraseStorageKey = 'nv_db_key';

/// Plaintext key file written by builds ≤ v0.9.0+9 as a Keystore fallback.
/// ⛔ It is NEVER written any more; it is only adopted once (so an existing
/// vault stays readable) and then shredded — see [resolveDbPassphrase].
const String kLegacyPlaintextKeyFileName = '.nv_db_key';

/// Which step of the Keystore round-trip failed.
enum KeystoreFailureStage { read, write, verify }

/// The Keystore-backed secure storage cannot hold the SQLCipher passphrase.
///
/// ⛔ SECURITY: there is deliberately NO fallback. Older builds degraded to a
/// plaintext `.nv_db_key` file next to the encrypted database, which handed
/// anyone with filesystem access both the vault and its key. NeoVault now
/// refuses to open the vault instead, and `main.dart` renders the
/// `BootstrapErrorApp` screen with this (honest) message plus a Retry action.
class KeystoreUnavailableException implements Exception {
  const KeystoreUnavailableException(this.stage, [this.cause]);

  final KeystoreFailureStage stage;
  final Object? cause;

  String get _detail => switch (stage) {
        KeystoreFailureStage.read =>
          'reading the existing vault key from secure storage failed',
        KeystoreFailureStage.write =>
          'storing a newly generated vault key in secure storage failed',
        KeystoreFailureStage.verify =>
          'the vault key could not be read back after writing '
              '(secure storage silently dropped it)',
      };

  @override
  String toString() {
    final because = cause == null ? '' : '\nCause: $cause';
    return 'KeystoreUnavailableException: Android Keystore-backed secure '
        'storage is unavailable — $_detail.\n'
        'The SQLCipher passphrase is kept ONLY in the Keystore and is never '
        'written to disk, Drift or SharedPreferences in plaintext, so the '
        'encrypted vault cannot be opened on this device right now.'
        '$because';
  }
}

/// Injection seams so the passphrase policy is unit-testable without a
/// platform channel (see test/unit/db_security_test.dart).
typedef SecureRead = Future<String?> Function(String key);
typedef SecureWrite = Future<void> Function(String key, String value);

const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

Future<String?> _defaultSecureRead(String key) => _secureStorage.read(key: key);

Future<void> _defaultSecureWrite(String key, String value) =>
    _secureStorage.write(key: key, value: value);

/// 256-bit passphrase from a CSPRNG, hex-encoded.
///
/// Hex (not UUID v4) on purpose: 256 bits instead of 122, and the alphabet
/// `[0-9a-f]` cannot carry a quote/control character into the `PRAGMA key`
/// statement (defence in depth on top of [pragmaKeyStatement]).
@visibleForTesting
String generateDbPassphrase({Random? rng}) {
  final r = rng ?? Random.secure();
  final bytes = List<int>.generate(32, (_) => r.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

/// Builds the `PRAGMA key` statement safely.
///
/// SQLite does not accept bound parameters in PRAGMA statements, so the value
/// must be embedded — but as a properly escaped SQL string literal (single
/// quotes doubled) rather than raw interpolation. Control characters (incl.
/// NUL and newlines) are rejected outright: they cannot occur in a key we
/// generate, so their presence means a corrupted/hostile value.
@visibleForTesting
String pragmaKeyStatement(String passphrase) {
  if (passphrase.isEmpty) {
    throw ArgumentError.value(
        passphrase, 'passphrase', 'SQLCipher passphrase must not be empty');
  }
  for (final unit in passphrase.codeUnits) {
    if (unit < 0x20 || unit == 0x7F) {
      throw ArgumentError.value(passphrase, 'passphrase',
          'SQLCipher passphrase must not contain control characters');
    }
  }
  final escaped = passphrase.replaceAll("'", "''");
  return "PRAGMA key = '$escaped';";
}

/// Resolves the vault passphrase from Keystore-backed secure storage.
///
/// Policy (⛔ §8.3):
///  1. Keystore read fails → [KeystoreUnavailableException] (fail-fast).
///  2. Key present → use it (and shred any leftover legacy plaintext file).
///  3. No key, but a legacy plaintext `.nv_db_key` exists → adopt it ONCE so
///     the existing vault stays readable, move it into the Keystore, then
///     shred the plaintext copy.
///  4. Nothing stored → generate a fresh 256-bit key.
///  5. Every write is read back; a silent write failure must not produce a
///     vault that can never be reopened.
///
/// ⛔ No branch of this function ever writes the passphrase to disk, Drift or
/// SharedPreferences.
@visibleForTesting
Future<String> resolveDbPassphrase({
  required Directory dir,
  SecureRead? read,
  SecureWrite? write,
  String Function()? generate,
}) async {
  final secureRead = read ?? _defaultSecureRead;
  final secureWrite = write ?? _defaultSecureWrite;
  final legacyFile = File(p.join(dir.path, kLegacyPlaintextKeyFileName));

  String? stored;
  try {
    stored = await secureRead(kDbPassphraseStorageKey);
  } catch (e) {
    throw KeystoreUnavailableException(KeystoreFailureStage.read, e);
  }

  if (stored != null && stored.isNotEmpty) {
    await _shredLegacyKeyFile(legacyFile);
    return stored;
  }

  final adopted = _readLegacyKeyFile(legacyFile);
  final passphrase = adopted ?? (generate ?? generateDbPassphrase)();

  try {
    await secureWrite(kDbPassphraseStorageKey, passphrase);
  } catch (e) {
    throw KeystoreUnavailableException(KeystoreFailureStage.write, e);
  }

  String? confirmed;
  try {
    confirmed = await secureRead(kDbPassphraseStorageKey);
  } catch (e) {
    throw KeystoreUnavailableException(KeystoreFailureStage.verify, e);
  }
  if (confirmed != passphrase) {
    throw const KeystoreUnavailableException(KeystoreFailureStage.verify);
  }

  await _shredLegacyKeyFile(legacyFile);
  return passphrase;
}

/// One-time adoption of a pre-fix plaintext key (never written again).
String? _readLegacyKeyFile(File legacyFile) {
  try {
    if (!legacyFile.existsSync()) return null;
    final raw = legacyFile.readAsStringSync().trim();
    return raw.isEmpty ? null : raw;
  } on Exception {
    return null;
  }
}

/// Best-effort removal of the leaked plaintext key: overwrite the bytes
/// before unlinking so a simple undelete does not resurrect the secret.
Future<void> _shredLegacyKeyFile(File legacyFile) async {
  try {
    if (!legacyFile.existsSync()) return;
    final length = await legacyFile.length();
    if (length > 0) {
      await legacyFile.writeAsBytes(List<int>.filled(length, 0), flush: true);
    }
    await legacyFile.delete();
  } on Exception {
    // Best effort: the key is already superseded by the Keystore entry.
  }
}

/// SQLCipher headers are random (salted) — a plaintext database still starts
/// with the magic string "SQLite format 3\0". Such a file would fail the
/// encrypted open with SQLITE_NOTADB, so park it under a backup name.
const List<int> _sqliteMagicHeader = <int>[
  0x53, 0x51, 0x4C, 0x69, 0x74, 0x65, 0x20, 0x66, // "SQLite f"
  0x6F, 0x72, 0x6D, 0x61, 0x74, 0x20, 0x33, 0x00, // "ormat 3\0"
];

Future<void> _parkLegacyPlaintextDb(File file) async {
  try {
    if (!file.existsSync()) return;
    final raf = await file.open(mode: FileMode.read);
    final header = await raf.read(16);
    await raf.close();
    if (header.length != 16) return;
    for (var i = 0; i < 16; i++) {
      if (header[i] != _sqliteMagicHeader[i]) return; // salted → encrypted.
    }
    final parked = File('${file.path}.plaintext-bak');
    if (parked.existsSync()) await parked.delete();
    await file.rename(parked.path);
  } on Exception {
    // Best effort: if even the rename fails, let the open attempt surface
    // the real error on the bootstrap error screen instead of hiding it.
  }
}

/// In-memory database for tests (synchronous executor — deterministic
/// under flutter_test fake-async; background isolate would deadlock pumps).
AppDatabase openTestDatabase() => AppDatabase(NativeDatabase.memory());

/// ── Cloud gateway binding ───────────────────────────────────────────────
/// Offline-first default: [LocalOnlyGateway]. When Firebase is configured
/// (google-services.json present + initializeApp succeeds), swap to
/// [FirebaseGateway] in bootstrap. UI/repositories never care.
/// DI contract: MUST be overridden in bootstrap (main.dart) or tests.
final cloudGatewayProvider = Provider<CloudGateway>((ref) {
  throw StateError(
      'cloudGatewayProvider must be overridden in bootstrap (see main.dart)');
});

/// ── SharedPreferences (bootstrap flags only — source of truth is Drift) ──
final prefsProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

final onboardedProvider = StateProvider<bool>((ref) => false);

/// ── Sync queue ──────────────────────────────────────────────────────────
final syncEngineProvider = Provider<SyncQueueEngine>((ref) {
  final db = ref.watch(dbProvider);
  final gateway = ref.watch(cloudGatewayProvider);
  final engine = SyncQueueEngine(db, (task) => gateway.pushEntity(
        collection: _collectionFor(task.entityType),
        entityId: task.entityId,
        payload: task.payload,
      ));
  ref.onDispose(() {});
  return engine;
});

String _collectionFor(String entityType) => switch (entityType) {
      'contribution' => 'contributions',
      'goal' => 'goals',
      'settings' => 'app_config',
      'chips' => 'chips_wallet',
      'pet' => 'pets',
      'quest' => 'quests_state',
      'chest' => 'chests_state',
      'holo' => 'holo_cards',
      'progress_card' => 'progress_cards',
      _ => 'misc',
    };

/// Flush trigger counter (bump to request a sync pass).
final syncTickProvider = StateProvider<int>((ref) => 0);

final syncPendingProvider = FutureProvider<int>((ref) async {
  ref.watch(syncTickProvider);
  return ref.watch(syncEngineProvider).pendingCount();
});

/// ── Device identity (guest AI limit by device ID, §7.2) ────────────────
final deviceIdProvider = FutureProvider<String>((ref) async {
  final db = ref.watch(dbProvider);
  final stats = await (db.select(db.userStatsTable)
        ..where((t) => t.id.equals('main')))
      .getSingleOrNull();
  return stats?.userId ?? 'unknown-device';
});

/// ── First-run bootstrap: create singleton rows + static catalogs ────────
/// ONLINE-ONLY (v0.9.2): only state singletons, achievement/holo catalogs
/// and app_config defaults are created here — NO price/mock data seeds.
Future<void> bootstrapDatabase(AppDatabase db, {DateTime? now}) async {
  final at = now ?? DateTime.now();
  final nowMs = at.millisecondsSinceEpoch;

  await db.transaction(() async {
    // Singleton user stats row (local device id).
    final stats = await (db.select(db.userStatsTable)..where((t) => t.id.equals('main')))
        .getSingleOrNull();
    if (stats == null) {
      await db.into(db.userStatsTable).insert(UserStatsTableCompanion.insert(
            id: 'main',
            installDate: nowMs,
            userId: const Uuid().v4(),
            registeredAt: const Value(null),
          ));
    }

    // Chips wallet singleton.
    final wallet = await (db.select(db.chipsWalletTable)..where((t) => t.id.equals('main')))
        .getSingleOrNull();
    if (wallet == null) {
      await db.into(db.chipsWalletTable)
          .insert(ChipsWalletTableCompanion.insert(id: 'main'));
    }

    // Pet singleton (egg at start, §10.1).
    final pet = await (db.select(db.pets)..where((t) => t.id.equals('main')))
        .getSingleOrNull();
    if (pet == null) {
      await db.into(db.pets).insert(PetsCompanion.insert(id: 'main'));
      await db.into(db.petSkins).insert(PetSkinsCompanion.insert(
            id: 'neon_cyan',
            owned: const Value(true),
          ));
    }

    // Chest singleton.
    final chest = await (db.select(db.chests)..where((t) => t.id.equals('main')))
        .getSingleOrNull();
    if (chest == null) {
      await db.into(db.chests).insert(ChestsCompanion.insert(id: 'main'));
    }

    // Buddy singleton.
    final buddy = await (db.select(db.buddyCache)..where((t) => t.id.equals('main')))
        .getSingleOrNull();
    if (buddy == null) {
      await db.into(db.buddyCache).insert(BuddyCacheCompanion.insert(id: 'main'));
    }

    // Leaderboard opt-in singleton (opt-out default, §10.4).
    final optin =
        await (db.select(db.leaderboardOptIn)..where((t) => t.id.equals('main')))
            .getSingleOrNull();
    if (optin == null) {
      await db
          .into(db.leaderboardOptIn)
          .insert(LeaderboardOptInCompanion.insert(id: 'main'));
    }

    // Progress card singleton (disabled default, ⛔ amount hidden default).
    final card =
        await (db.select(db.progressCards)..where((t) => t.id.equals('main')))
            .getSingleOrNull();
    if (card == null) {
      await db
          .into(db.progressCards)
          .insert(ProgressCardsCompanion.insert(id: 'main'));
    }

    // PIN meta singleton.
    final pin = await (db.select(db.pinMeta)..where((t) => t.id.equals('main')))
        .getSingleOrNull();
    if (pin == null) {
      await db.into(db.pinMeta).insert(PinMetaCompanion.insert(id: 'main'));
    }

    // Rate-app state singleton.
    final rate = await (db.select(db.rateAppState)..where((t) => t.id.equals('main')))
        .getSingleOrNull();
    if (rate == null) {
      await db.into(db.rateAppState).insert(RateAppStateCompanion.insert(id: 'main'));
    }

    // Achievement definitions (40).
    final existingAch = await db.achievements.count().getSingle();
    if (existingAch == 0) {
      for (final a in achievementDefsForDb) {
        await db.into(db.achievements).insert(AchievementsCompanion.insert(
              id: a.$1,
              category: a.$2,
              bonusXp: a.$3,
              secret: Value(a.$4),
            ));
      }
    }

    // Holo sets + cards (20 cards, §10.6).
    final existingSets = await db.holoSets.count().getSingle();
    if (existingSets == 0) {
      for (final s in SeedData.holoSets) {
        await db.into(db.holoSets).insert(
            HoloSetsCompanion.insert(id: s.id, nameKey: s.nameKey));
      }
      for (final c in SeedData.holoCards) {
        await db.into(db.holoCards).insert(HoloCardsCompanion.insert(
              id: c.id,
              setId: c.setId,
              rarity: c.rarity,
              nameKey: c.name,
              condKey: c.condition,
              loreKey: c.id,
            ));
      }
    }

    // ONLINE-ONLY (v0.9.2): NO price/spec/scan-run seeds. Prices come
    // exclusively from the Tavily web search; without network the UI shows
    // honest error states — never local mock substitution (⛔ user decision).

    // app_config defaults (§6.18/6.19 triggers).
    final existingConfig = await db.appConfigTable.count().getSingle();
    if (existingConfig == 0) {
      for (final e in SeedData.appConfig.entries) {
        await db.into(db.appConfigTable).insert(AppConfigTableCompanion.insert(
              key: e.key,
              valueJson: e.value,
              updatedAt: nowMs,
            ));
      }
    }

    // Seasonal event seed (§10.7 «Новорічний спринт»).
    final existingEvents = await db.eventsCache.count().getSingle();
    if (existingEvents == 0) {
      final eventJson = SeedData.eventConfigJson(at);
      final decoded =
          const JsonDecoder().convert(eventJson) as Map<String, Object?>;
      await db.into(db.eventsCache).insert(EventsCacheCompanion.insert(
            id: decoded['id'] as String,
            titleKey: decoded['titleKey'] as String,
            bannerKey: 'new_year_sprint',
            startsAt: decoded['startsAt'] as int,
            endsAt: decoded['endsAt'] as int,
            questsJson: const JsonEncoder().convert(decoded['quests']),
            rewardsJson: const JsonEncoder().convert(decoded['rewards']),
          ));
      final quests = (decoded['quests'] as List).cast<Map<String, Object?>>();
      for (final q in quests) {
        await db.into(db.eventQuests).insert(EventQuestsCompanion.insert(
              id: '${decoded['id']}_${q['id']}',
              eventId: decoded['id'] as String,
              titleKey: q['titleKey'] as String,
              target: q['target'] as int,
            ));
      }
    }
  });
}

/// (id, category, bonusXp, secret) tuples mirrored from the engine for DB seed.
const List<(String, String, int, bool)> achievementDefsForDb = [
  ('F1', 'financial', 20, false), ('F2', 'financial', 15, false),
  ('F3', 'financial', 30, false), ('F4', 'financial', 50, false),
  ('F5', 'financial', 100, false), ('F6', 'financial', 200, false),
  ('F7', 'financial', 150, false), ('F8', 'financial', 25, false),
  ('F9', 'financial', 40, false), ('F10', 'financial', 75, false),
  ('S1', 'regularity', 10, false), ('S2', 'regularity', 40, false),
  ('S3', 'regularity', 60, false), ('S4', 'regularity', 100, false),
  ('S5', 'regularity', 250, false), ('S6', 'regularity', 500, false),
  ('S7', 'regularity', 15, false),
  ('P1', 'price', 15, false), ('P2', 'price', 50, false),
  ('P3', 'price', 120, false), ('P4', 'price', 30, false),
  ('P5', 'price', 25, false),
  ('G1', 'level', 10, false), ('G2', 'level', 20, false),
  ('G3', 'level', 50, false), ('G4', 'level', 150, false),
  ('G5', 'level', 500, false),
  ('O1', 'explore', 10, false), ('O2', 'explore', 25, false),
  ('O3', 'explore', 20, false), ('O4', 'explore', 10, false),
  ('O5', 'explore', 15, false),
  ('L1', 'season', 100, false), ('L2', 'season', 75, false),
  ('L3', 'season', 50, false),
  ('X1', 'secret', 30, true), ('X2', 'secret', 30, true),
  ('X3', 'secret', 75, true), ('X4', 'secret', 250, true),
];
