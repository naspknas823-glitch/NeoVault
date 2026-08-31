import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/db/app_database.dart';
import '../../core/utils/format.dart';
import '../../core/sync/sync_queue.dart';
import '../../domain/leaderboard/leaderboard_engine.dart';
import '../../domain/gamification/xp_engine.dart';
import 'goal_repository.dart';
import 'retention_repositories.dart';
import '../../domain/buddy/buddy_engine.dart';
import 'providers.dart';

/// ── Leaderboard with ghosts (§10.4) ─────────────────────────────────────
/// Opt-in required; weekly reset Monday 00:00 Kyiv; rows contain ONLY
/// nick/percent/XP/rank/streak — NEVER money amounts (⛔ §9.12).
class LeaderboardRepository {
  LeaderboardRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);
  GoalRepository get _goals => _ref.read(goalRepositoryProvider);

  Future<LeaderboardOptInData> optInState() async =>
      (_db.select(_db.leaderboardOptIn)..where((t) => t.id.equals('main'))).getSingle();

  Stream<LeaderboardOptInData> watchOptIn() =>
      (_db.select(_db.leaderboardOptIn)..where((t) => t.id.equals('main'))).watchSingle();

  Future<void> setOptIn(bool value) async {
    await (_db.update(_db.leaderboardOptIn)..where((t) => t.id.equals('main')))
        .write(LeaderboardOptInCompanion(optedIn: Value(value)));
  }

  /// Player's own weekly tempo: % growth of own goal this week (fair metric).
  Future<double> selfWeeklyPercent() async {
    final weekStart = kyivWeekStart().millisecondsSinceEpoch;
    final savedExpr = _db.contributions.amount.sum();
    final qWeek = _db.selectOnly(_db.contributions)
      ..addColumns([savedExpr])
      ..where(_db.contributions.occurredAt.isBiggerOrEqualValue(weekStart));
    final weekSum = (await qWeek.getSingle()).read(savedExpr) ?? 0;

    final goal = await _goals.getGoal();
    final target = goal?.target ?? 0;
    if (target <= 0) return 0;
    // Total saved before this week:
    final qAll = _db.selectOnly(_db.contributions)
      ..addColumns([savedExpr])
      ..where(_db.contributions.occurredAt.isSmallerThanValue(weekStart));
    final before = (await qAll.getSingle()).read(savedExpr) ?? 0;
    if (before <= 0) {
      // First week: progress relative to full target.
      return weekSum / target * 100;
    }
    return weekSum / before * 100;
  }

  Future<int> selfWeeklyXp() async {
    final weekStart = kyivWeekStart().millisecondsSinceEpoch;
    final xpExpr = _db.contributions.xpEarned.sum();
    final q = _db.selectOnly(_db.contributions)
      ..addColumns([xpExpr])
      ..where(_db.contributions.occurredAt.isBiggerOrEqualValue(weekStart));
    return (await q.getSingle()).read(xpExpr) ?? 0;
  }

  /// Ghost assignment: 2 rivals within ±15% of self tempo (§10.4).
  /// Seeds are created once per week in ghost_cache (repository-layer seed,
  /// replaced by `pickGhosts` Cloud Function when backend connects).
  Future<GhostPair> ghostPairNow() async {
    final week = kyivDateKey(kyivWeekStart());
    final stats = await _goals.rawStats();
    final selfTempo = await selfWeeklyPercent();
    final nick = stats.nickname.isEmpty ? 'Ти' : stats.nickname;
    final self = LeaderboardRow(
      userId: stats.userId,
      nick: nick,
      percent: selfTempo,
      weeklyXp: await selfWeeklyXp(),
      rankLabel: Gamification.rankForLevel(stats.level).name,
      streakDays: stats.streakDays,
      isSelf: true,
    );

    var ghosts = await (_db.select(_db.ghostCache)..where((t) => t.weekKey.equals(week)))
        .get();
    if (ghosts.length < 2) {
      // Seed 2 ghosts around self tempo (±10% and +18% clamped by ±15%+1).
      final rng = Random(week.hashCode);
      final candidates = <double>[
        max(0.5, selfTempo * 1.12),
        max(0.3, selfTempo * 0.88),
        max(0.2, selfTempo + 4),
      ];
      await (_db.delete(_db.ghostCache)..where((t) => t.weekKey.equals(week))).go();
      final seeds = <GhostCacheCompanion>[
        for (var i = 0; i < 2; i++)
          GhostCacheCompanion.insert(
            id: 'ghost_${week}_$i',
            nick: 'Ghost-${(rng.nextInt(899) + 100)}',
            percent: candidates[i % candidates.length],
            weeklyXp: max(10, (self.weeklyXp * (0.9 + rng.nextDouble() * 0.3)).round()),
            rankLabel: self.rankLabel,
            streakDays: max(1, stats.streakDays + i - 1),
            weekKey: week,
          ),
      ];
      await _db.batch((b) => b.insertAll(_db.ghostCache, seeds));
      ghosts = await (_db.select(_db.ghostCache)..where((t) => t.weekKey.equals(week))).get();
    }

    final rows = ghosts
        .map((g) => LeaderboardRow(
              userId: g.id,
              nick: g.nick,
              percent: g.percent,
              weeklyXp: g.weeklyXp,
              rankLabel: g.rankLabel,
              streakDays: g.streakDays,
              isGhost: true,
            ))
        .toList();

    return GhostPair(ghosts: rows, self: self);
  }

  /// Beat-a-ghost reward: +20 Chips once per week (§10.4).
  Future<bool> claimGhostReward() async {
    final optIn = await optInState();
    final week = kyivDateKey(kyivWeekStart());
    if (optIn.ghostRewardClaimedThisWeek && optIn.ghostRewardWeek == week) return false;
    final pair = await ghostPairNow();
    final won = LeaderboardEngine.beatAnyGhost(
      selfTempo: pair.self.percent,
      selfWeeklyXp: pair.self.weeklyXp,
      tab: LeaderboardTab.tempo,
      ghosts: pair.ghosts,
    );
    if (!won) return false;
    await (_db.update(_db.leaderboardOptIn)..where((t) => t.id.equals('main'))).write(
      LeaderboardOptInCompanion(
        ghostRewardClaimedThisWeek: const Value(true),
        ghostRewardWeek: Value(week),
      ),
    );
    await _ref.read(chipsRepositoryProvider).earn(20, 'ghost');
    return true;
  }
}

/// ── Buddy Mode (§10.8) ──────────────────────────────────────────────────
class BuddyRepository {
  BuddyRepository(this._ref);
  final Ref _ref;

    AppDatabase get _db => _ref.read(dbProvider);
  SyncQueueEngine get _sync => _ref.read(syncEngineProvider);

  Stream<BuddyCacheData> watch() => (_db.select(_db.buddyCache)
        ..where((t) => t.id.equals('main')))
      .watchSingle();

  Future<BuddyCacheData> _row() async => (_db.select(_db.buddyCache)
        ..where((t) => t.id.equals('main')))
      .getSingle();

  bool get linked => false;

  /// Create invite: 6-char code + deep link (§10.8). Server replaces this
  /// via `createBuddyInvite` when connected — same contract shape.
  Future<(String code, String link)> createInvite() async {
    final code = BuddyEngine.generateInviteCode();
    await (_db.update(_db.buddyCache)..where((t) => t.id.equals('main')))
                .write(BuddyCacheCompanion(inviteCode: Value(code)));

    await _sync.enqueue(
      entityId: code,
      entityType: 'buddy_invite',
      payload: {
        'code': code,
        'status': 'pending',
        'createdAtMs': DateTime.now().millisecondsSinceEpoch,
      },
    );
    unawaitedSync(_sync.flush());
    return (code, buddyDeepLink(code));
  }

  /// Accept a code: local-beta simulation — links a ghost-buddy profile so
  /// the flow is complete; `acceptBuddyInvite` Cloud Function supersedes.
  Future<void> acceptCode(String code) async {
    final normalized = code.trim().toUpperCase();
    if (!BuddyEngine.isValidInviteCode(normalized)) {
      throw const BuddyInvalidCode();
    }
    final existing = await _row();
    if (existing.buddyId != null) return;
    final gateway = _ref.read(cloudGatewayProvider);
    if (!gateway.isAvailable) {
      throw const BuddyUnavailable();
    }
    final matches = await gateway.pullEntities(
      collection: 'buddy_invites',
      sinceMs: 0,
    );
    Map<String, Object?>? match;
    for (final e in matches) {
      if ((e['code'] as String?)?.toUpperCase() == normalized &&
          (e['status'] as String?) == 'accepted') {
        match = e;
        break;
      }
    }
    if (match == null) {
      throw const BuddyInvalidCode();
    }
    await (_db.update(_db.buddyCache)..where((t) => t.id.equals('main'))).write(
      BuddyCacheCompanion(
        buddyId: Value((match['ownerId'] as String?) ?? 'remote_$normalized'),
        buddyNick: Value((match['ownerNick'] as String?) ?? 'Someone'),
        buddyGoalPercent:
            Value(((match['goalPercent'] as num?)?.toDouble()) ?? 0),
        buddyWeeklyPercent:
            Value(((match['weeklyPercent'] as num?)?.toDouble()) ?? 0),
        buddyStreak: Value((match['streak'] as num?)?.toInt() ?? 0),
        buddyRank: Value((match['rank'] as String?) ?? 'Bronze'),
        buddyWeeklyContribs:
            Value((match['weeklyContribs'] as num?)?.toInt() ?? 0),
      ),
    );
    await _sync.enqueue(
      entityId: normalized,
      entityType: 'buddy_accept',
      payload: {
        'code': normalized,
        'status': 'accepted',
        'acceptedAtMs': DateTime.now().millisecondsSinceEpoch,
      },
    );
    unawaitedSync(_sync.flush());
  }


  Future<void> unlink() async {
    await (_db.update(_db.buddyCache)..where((t) => t.id.equals('main'))).write(
      const BuddyCacheCompanion(
        buddyId: Value(null),
        buddyNick: Value(null),
        inviteCode: Value(null),
        weekRewardClaimed: Value(false),
      ),
    );
  }

  /// ⛔ Max 3 pings/day — the 4th is blocked (criterion 12.16).
  Future<bool> sendPing(int presetIndex) async {
    final row = await _row();
    if (row.buddyId == null) return false;
    final today = kyivDateKey();
    final pingsToday = row.pingsDay == today ? row.pingsToday : 0;
    if (!BuddyEngine.canPing(pingsToday)) return false;
    await (_db.update(_db.buddyCache)..where((t) => t.id.equals('main'))).write(
      BuddyCacheCompanion(pingsToday: Value(pingsToday + 1), pingsDay: Value(today)),
    );
    return true;
  }

  Future<int> pingsLeft() async {
    final row = await _row();
    final today = kyivDateKey();
    final used = row.pingsDay == today ? row.pingsToday : 0;
    return BuddyEngine.maxPingsPerDay - used;
  }

  /// Buddy-week: both 3+ contributions → +30 Chips both (§10.8).
  Future<bool> claimBuddyWeek() async {
    final row = await _row();
    if (row.buddyId == null || row.weekRewardClaimed) return false;
    final self = await _selfWeeklyContribs();
    if (!buddyWeekComplete(self, row.buddyWeeklyContribs)) return false;
    await (_db.update(_db.buddyCache)..where((t) => t.id.equals('main')))
        .write(const BuddyCacheCompanion(weekRewardClaimed: Value(true)));
    await _ref.read(chipsRepositoryProvider).earn(30, 'buddy');
    return true;
  }

  Future<int> _selfWeeklyContribs() async {
    final weekStart = kyivWeekStart().millisecondsSinceEpoch;
    final c = _db.contributions.id.count();
    final q = _db.selectOnly(_db.contributions)
      ..addColumns([c])
      ..where(_db.contributions.occurredAt.isBiggerOrEqualValue(weekStart));
    return (await q.getSingle()).read(c) ?? 0;
  }
}

class BuddyInvalidCode implements Exception {
  const BuddyInvalidCode();
}

/// Thrown when the cloud backend is unreachable for a buddy operation that
/// requires server-side verification (e.g. accepting an invite while offline).
class BuddyUnavailable implements Exception {
  const BuddyUnavailable();
}

/// ── Live Progress Card (§10.5) ──────────────────────────────────────────
class ProgressCardRepository {
  ProgressCardRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);

  Stream<ProgressCard> watch() => (_db.select(_db.progressCards)
        ..where((t) => t.id.equals('main')))
      .watchSingle();

  Future<ProgressCard> get() async => (_db.select(_db.progressCards)
        ..where((t) => t.id.equals('main')))
      .getSingle();

  Future<void> setEnabled(bool enabled) async {
    final row = await get();
    if (enabled) {
      var token = row.token;
      token ??= const Uuid().v4();
      await (_db.update(_db.progressCards)..where((t) => t.id.equals('main'))).write(
        ProgressCardsCompanion(
          enabled: const Value(true),
          token: Value(token),
          createdAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );
    } else {
      await (_db.update(_db.progressCards)..where((t) => t.id.equals('main')))
          .write(const ProgressCardsCompanion(enabled: Value(false)));
    }
  }

  Future<void> setField({required String field, required bool value}) async {
    final patch = switch (field) {
      'rank' => ProgressCardsCompanion(showRank: Value(value)),
      'streak' => ProgressCardsCompanion(showStreak: Value(value)),
      'percent' => ProgressCardsCompanion(showPercent: Value(value)),
      'amount' => ProgressCardsCompanion(showAmount: Value(value)),
      _ => const ProgressCardsCompanion(),
    };
    await (_db.update(_db.progressCards)..where((t) => t.id.equals('main'))).write(patch);
  }

  /// Revoke + new token (§10.5): access stops immediately.
  Future<void> rotateToken() async {
    await (_db.update(_db.progressCards)..where((t) => t.id.equals('main'))).write(
      ProgressCardsCompanion(
        token: Value(const Uuid().v4()),
        views: const Value(0),
        createdAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  Future<void> incrementViews() async {
    final row = await get();
    await (_db.update(_db.progressCards)..where((t) => t.id.equals('main')))
        .write(ProgressCardsCompanion(views: Value(row.views + 1)));
  }

  /// Public page URL shape (production: Firebase Hosting `progressCardPage`).
  String publicUrl(String token) => 'https://neovault-beta.web.app/u/$token';
}

final leaderboardRepositoryProvider =
    Provider<LeaderboardRepository>((ref) => LeaderboardRepository(ref));
final buddyRepositoryProvider = Provider<BuddyRepository>((ref) => BuddyRepository(ref));
final progressCardRepositoryProvider =
    Provider<ProgressCardRepository>((ref) => ProgressCardRepository(ref));
