import 'dart:convert';

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/db/app_database.dart';
import '../../core/sync/sync_queue.dart';
import '../../core/utils/format.dart';
import '../../domain/gamification/achievements.dart';
import '../../domain/gamification/xp_engine.dart';
import 'providers.dart';

/// ── Models exposed to UI ────────────────────────────────────────────────
class GoalView {
  const GoalView({
    required this.id,
    required this.title,
    required this.ps5Target,
    required this.monitorTarget,
    required this.saved,
    required this.createdAt,
    required this.completed,
  });

  final String id;
  final String title;
  final int ps5Target;
  final int monitorTarget;
  final int saved;
  final DateTime createdAt;
  final bool completed;

  int get target => ps5Target + monitorTarget;
  double get percent => target <= 0 ? 0 : (saved / target * 100).clamp(0, 100);
  int get remaining => (target - saved).clamp(0, target);
  bool get isComplete => saved >= target && target > 0;
}

class ContributionView {
  const ContributionView({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.comment,
    required this.receiptPath,
    required this.xpEarned,
    required this.streakBonus,
    required this.occurredAt,
  });

  final String id;
  final String goalId;
  final int amount;
  final String? comment;
  final String? receiptPath;
  final int xpEarned;
  final int streakBonus;
  final DateTime occurredAt;
}

/// Result of adding a contribution — drives XP toast / level-up / victory.
class ContributionResult {
  const ContributionResult({
    required this.xp,
    required this.streakBonusXp,
    required this.newLevel,
    required this.leveledUp,
    required this.rank,
    required this.newAchievements,
    required this.streakDays,
    required this.goalCompleted,
  });

  final int xp;
  final int streakBonusXp;
  final int newLevel;
  final bool leveledUp;
  final Rank rank;
  final List<AchievementDef> newAchievements;
  final int streakDays;
  final bool goalCompleted;
}

/// ── Goals & contributions repository ────────────────────────────────────
class GoalRepository {
  GoalRepository(this._ref);

  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);
  SyncQueueEngine get _sync => _ref.read(syncEngineProvider);

  /// Current goal stream (single active goal). The saved amount is a
  /// live aggregate over contributions — the stream re-emits on EVERY
  /// contribution insert/update/delete (combineLatest), so the animated
  /// counter reacts instantly (§6.3).
  Stream<GoalView?> watchGoal() {
    late final StreamController<GoalView?> controller;
    Goal? lastGoal;
    int lastSaved = 0;
    bool emitScheduled = false;

    void emit() {
      final g = lastGoal;
      if (g == null) {
        controller.add(null);
        return;
      }
      controller.add(GoalView(
        id: g.id,
        title: g.title,
        ps5Target: g.ps5Price,
        monitorTarget: g.monitorPrice,
        saved: lastSaved,
        createdAt: DateTime.fromMillisecondsSinceEpoch(g.createdAt),
        completed: g.completed || lastSaved >= g.ps5Price + g.monitorPrice,
      ));
    }

    void scheduleEmit() {
      // Coalesce burst updates (e.g. delete+restore) into one microtask —
      // no Timer (fake-async tests assert zero pending timers).
      if (emitScheduled) return;
      emitScheduled = true;
      scheduleMicrotask(() {
        emitScheduled = false;
        emit();
      });
    }

    controller = StreamController<GoalView?>(
      onListen: () {
        final sumExpr = _db.contributions.amount.sum();
        final sub1 = (_db.select(_db.goals)
              ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]))
            .watchSingleOrNull()
            .listen((g) {
          lastGoal = g;
          scheduleEmit();
        });
        final sub2 = (_db.selectOnly(_db.contributions)..addColumns([sumExpr]))
            .watchSingleOrNull()
            .listen((row) {
          lastSaved = row?.read(sumExpr) ?? 0;
          scheduleEmit();
        });
        controller.onCancel = () {
          sub1.cancel();
          sub2.cancel();
        };
      },
    );
    return controller.stream;
  }

  Future<GoalView?> getGoal() async {
    final row = await (_db.select(_db.goals)
          ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]))
        .getSingleOrNull();
    if (row == null) return null;
    final savedExpr = _db.contributions.amount.sum();
    final q = _db.selectOnly(_db.contributions)
      ..addColumns([savedExpr])
      ..where(_db.contributions.goalId.equals(row.id));
    final saved = (await q.getSingle()).read(savedExpr) ?? 0;
    return GoalView(
      id: row.id,
      title: row.title,
      ps5Target: row.ps5Price,
      monitorTarget: row.monitorPrice,
      saved: saved,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
      completed: row.completed || saved >= row.ps5Price + row.monitorPrice,
    );
  }

  /// Onboarding result: create the goal (§6.2 steps 2–4).
  Future<void> createGoal({
    required String title,
    required int ps5Price,
    required int monitorPrice,
  }) async {
    final id = _uuid();
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.into(_db.goals).insert(GoalsCompanion.insert(
          id: id,
          title: title,
          ps5Price: ps5Price,
          monitorPrice: monitorPrice,
          createdAt: now,
        ));
    await _db.into(_db.goalItems).insert(GoalItemsCompanion.insert(
          id: '${id}_ps5',
          goalId: id,
          kind: 'ps5',
          title: 'PS5',
          targetPrice: ps5Price,
        ));
    await _db.into(_db.goalItems).insert(GoalItemsCompanion.insert(
          id: '${id}_monitor',
          goalId: id,
          kind: 'monitor',
          title: 'Monitor',
          targetPrice: monitorPrice,
        ));
    unawaitedSync(_sync.enqueue(
      entityId: id,
      entityType: 'goal',
      payload: {
        'id': id,
        'title': title,
        'ps5_price': ps5Price,
        'monitor_price': monitorPrice,
        'created_at': now,
      },
    ));
  }

  /// Contributions list (filters/sort per §6.5).
  Stream<List<ContributionView>> watchContributions({
    required HistoryFilter filter,
    required bool newestFirst,
    String? searchQuery,
  }) {
    final now = DateTime.now();
    return (_db.select(_db.contributions)
          ..where((c) {
            final conds = <Expression<bool>>[];
            switch (filter) {
              case HistoryFilter.month:
                final from = DateTime(now.year, now.month).millisecondsSinceEpoch;
                conds.add(c.occurredAt.isBiggerOrEqualValue(from));
                break;
              case HistoryFilter.year:
                final from = DateTime(now.year).millisecondsSinceEpoch;
                conds.add(c.occurredAt.isBiggerOrEqualValue(from));
                break;
              case HistoryFilter.all:
                break;
            }
            if (searchQuery != null && searchQuery.isNotEmpty) {
              conds.add(c.comment.like('%$searchQuery%'));
            }
            if (conds.isEmpty) return const CustomExpression<bool>('1 = 1');
            return Expression.and(conds);
          })
          ..orderBy([
            (c) => OrderingTerm(
                expression: c.occurredAt, mode: newestFirst ? OrderingMode.desc : OrderingMode.asc)
          ]))
        .watch()
        .map((rows) => rows
            .map((r) => ContributionView(
                  id: r.id,
                  goalId: r.goalId,
                  amount: r.amount,
                  comment: r.comment,
                  receiptPath: r.receiptPath,
                  xpEarned: r.xpEarned,
                  streakBonus: r.streakBonus,
                  occurredAt: DateTime.fromMillisecondsSinceEpoch(r.occurredAt),
                ))
            .toList());
  }

  /// One-shot fetch (export §6.17 uses a snapshot, not a live stream).
  Future<List<ContributionView>> getContributions({
    HistoryFilter filter = HistoryFilter.all,
    bool newestFirst = false,
  }) async {
    final now = DateTime.now();
    final query = _db.select(_db.contributions);
    query.where((c) {
      switch (filter) {
        case HistoryFilter.month:
          return c.occurredAt.isBiggerOrEqualValue(
              DateTime(now.year, now.month).millisecondsSinceEpoch);
        case HistoryFilter.year:
          return c.occurredAt
              .isBiggerOrEqualValue(DateTime(now.year).millisecondsSinceEpoch);
        case HistoryFilter.all:
          return const CustomExpression<bool>('1 = 1');
      }
    });
    query.orderBy([
      (c) => OrderingTerm(
          expression: c.occurredAt,
          mode: newestFirst ? OrderingMode.desc : OrderingMode.asc)
    ]);
    final rows = await query.get();
    return rows
        .map((r) => ContributionView(
              id: r.id,
              goalId: r.goalId,
              amount: r.amount,
              comment: r.comment,
              receiptPath: r.receiptPath,
              xpEarned: r.xpEarned,
              streakBonus: r.streakBonus,
              occurredAt: DateTime.fromMillisecondsSinceEpoch(r.occurredAt),
            ))
        .toList();
  }

  /// ⛔ Single confirmation: the record is saved IMMEDIATELY (§6.4) with
  /// XP + streak + achievements + level checks (§5.1 formulas).
  Future<ContributionResult> addContribution({
    required int amount,
    DateTime? occurredAt,
    String? comment,
    String? receiptPath,
    bool viaOnboarding = false,
  }) async {
    final goal = await getGoal();
    final now = DateTime.now();
    final when = occurredAt ?? now;
    final kyiv = kyivNow();
    final dayKey = kyivDateKey(kyiv);

    final statsRow = await (_db.select(_db.userStatsTable)
          ..where((t) => t.id.equals('main')))
        .getSingle();

    final newStreak =
        StreakEngine.nextStreak(statsRow.lastContributionDay, dayKey, statsRow.streakDays);
    final streakBonus = Gamification.streakBonusXp(newStreak);
    final baseXp = Gamification.xpForContribution(amount);
    final xp = baseXp + streakBonus;

    final id = _uuid();
    await _db.into(_db.contributions).insert(ContributionsCompanion.insert(
          id: id,
          goalId: goal?.id ?? 'default',
          amount: amount,
          comment: Value(comment),
          receiptPath: Value(receiptPath),
          xpEarned: Value(xp),
          streakBonus: Value(streakBonus),
          occurredAt: when.millisecondsSinceEpoch,
          createdAt: now.millisecondsSinceEpoch,
        ));

    unawaitedSync(_sync.enqueue(
      entityId: id,
      entityType: 'contribution',
      payload: {
        'id': id,
        'goal_id': goal?.id,
        'amount': amount,
        'comment': comment,
        'occurred_at': when.millisecondsSinceEpoch,
        'xp': xp,
        'created_at': now.millisecondsSinceEpoch,
      },
    ));

    // Update stats + XP + level.
    final totalXp = statsRow.totalXp + xp;
    final newLevel = Gamification.levelForXp(totalXp);
    final contribs = statsRow.contributionsCount + 1;
    await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main'))).write(
      UserStatsTableCompanion(
        totalXp: Value(totalXp),
        level: Value(newLevel),
        streakDays: Value(newStreak),
        lastContributionDay: Value(dayKey),
        contributionsCount: Value(contribs),
        maxSingleContribution:
            Value((statsRow.maxSingleContribution < amount) ? amount : statsRow.maxSingleContribution),
      ),
    );

    // Achievements evaluation.
    final unlocked = await _unlockedIds();
    final goalView = goal;
    final stats = UserStats(
      totalXp: totalXp,
      level: newLevel,
      streakDays: newStreak,
      contributionsCount: contribs,
      totalSaved: (goalView?.saved ?? amount),
      goalAmount: (goalView?.target ?? 0),
      maxSingleContribution: (statsRow.maxSingleContribution < amount)
          ? amount
          : statsRow.maxSingleContribution,
      returnedAfterPause: _isReturnAfterPause(statsRow.lastContributionDay, dayKey),
      onboardedWithFirstContribution: viaOnboarding,
      nightOwlContribution: isNightOwl(kyiv),
      earlyBirdContribution: isEarlyBird(kyiv),
      lastContributionDate: DateTime(when.year, when.month, when.day),
      registeredAt: statsRow.registeredAt != null
          ? DateTime.fromMillisecondsSinceEpoch(statsRow.registeredAt!)
          : null,
      today: kyiv,
    );
    final newly = Achievements.newlyUnlocked(stats, unlocked);
    for (final achId in newly) {
      await unlockAchievement(achId, DateTime.now().millisecondsSinceEpoch);
    }

    final completed = goalView != null && goalView.isComplete;
    if (completed) {
      await (_db.update(_db.goals)..where((g) => g.id.equals(goalView.id)))
          .write(const GoalsCompanion(completed: Value(true)));
    }

    return ContributionResult(
      xp: xp,
      streakBonusXp: streakBonus,
      newLevel: newLevel,
      leveledUp: newLevel > statsRow.level,
      rank: Gamification.rankForLevel(newLevel),
      newAchievements: [for (final id2 in newly) Achievements.byId(id2)!],
      streakDays: newStreak,
      goalCompleted: completed,
    );
  }

  Future<void> updateContribution({
    required String id,
    int? amount,
    String? comment,
  }) async {
    await (_db.update(_db.contributions)..where((c) => c.id.equals(id))).write(
      ContributionsCompanion(
        amount: amount == null ? const Value.absent() : Value(amount),
        comment: comment == null ? const Value.absent() : Value(comment),
      ),
    );
    unawaitedSync(_sync.enqueue(
      entityId: id,
      entityType: 'contribution',
      payload: {'id': id, 'amount': amount, 'comment': comment, 'updated': true},
    ));
  }

  /// Delete with undo support (§6.6): returns the removed row for restore.
  Future<Contribution?> deleteContribution(String id) async {
    final row =
        await (_db.select(_db.contributions)..where((c) => c.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    await (_db.delete(_db.contributions)..where((c) => c.id.equals(id))).go();
    // Roll back XP.
    final stats = await (_db.select(_db.userStatsTable)..where((t) => t.id.equals('main')))
        .getSingle();
    await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main'))).write(
      UserStatsTableCompanion(
        totalXp: Value((stats.totalXp - row.xpEarned).clamp(0, 1 << 31)),
        level: Value(Gamification.levelForXp((stats.totalXp - row.xpEarned).clamp(0, 1 << 31))),
        contributionsCount: Value((stats.contributionsCount - 1).clamp(0, 1 << 31)),
      ),
    );
    return row;
  }

  Future<void> restoreContribution(Contribution row) async {
    await _db.into(_db.contributions).insert(ContributionsCompanion.insert(
          id: row.id,
          goalId: row.goalId,
          amount: row.amount,
          comment: Value(row.comment),
          receiptPath: Value(row.receiptPath),
          xpEarned: Value(row.xpEarned),
          streakBonus: Value(row.streakBonus),
          occurredAt: row.occurredAt,
          createdAt: row.createdAt,
        ));
    final stats = await (_db.select(_db.userStatsTable)..where((t) => t.id.equals('main')))
        .getSingle();
    final newXp = stats.totalXp + row.xpEarned;
    await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main'))).write(
      UserStatsTableCompanion(
        totalXp: Value(newXp),
        level: Value(Gamification.levelForXp(newXp)),
        contributionsCount: Value(stats.contributionsCount + 1),
      ),
    );
  }

  Future<ContributionView?> getContribution(String id) async {
    final row =
        await (_db.select(_db.contributions)..where((c) => c.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return ContributionView(
      id: row.id,
      goalId: row.goalId,
      amount: row.amount,
      comment: row.comment,
      receiptPath: row.receiptPath,
      xpEarned: row.xpEarned,
      streakBonus: row.streakBonus,
      occurredAt: DateTime.fromMillisecondsSinceEpoch(row.occurredAt),
    );
  }

  /// Cumulative curve for the History chart (§6.5).
  Future<List<(DateTime, int)>> cumulativeCurve() async {
    final rows = await (_db.select(_db.contributions)
          ..orderBy([(c) => OrderingTerm.asc(c.occurredAt)]))
        .get();
    var acc = 0;
    return [
      for (final r in rows)
        (
          DateTime.fromMillisecondsSinceEpoch(r.occurredAt),
          acc += r.amount,
        )
    ];
  }

  Future<void> unlockAchievement(String achievementId, int atMs) async {
    await _db.into(_db.achievementsUnlocked).insertOnConflictUpdate(
          AchievementsUnlockedCompanion.insert(
            achievementId: achievementId,
            unlockedAt: atMs,
          ),
        );
    final def = Achievements.byId(achievementId);
    if (def != null && def.bonusXp > 0) {
      final stats = await (_db.select(_db.userStatsTable)..where((t) => t.id.equals('main')))
          .getSingle();
      final newXp = stats.totalXp + def.bonusXp;
      await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main'))).write(
        UserStatsTableCompanion(
          totalXp: Value(newXp),
          level: Value(Gamification.levelForXp(newXp)),
        ),
      );
    }
    // X4 «Колекціонер»: all 39 others unlocked.
    final unlocked = await _unlockedIds();
    final others = Achievements.all.where((a) => a.id != 'X4').map((a) => a.id).toSet();
    if (!unlocked.contains('X4') && unlocked.containsAll(others)) {
      await unlockAchievement('X4', DateTime.now().millisecondsSinceEpoch);
    }
  }

  Future<Set<String>> _unlockedIds() async {
    final rows = await _db.select(_db.achievementsUnlocked).get();
    return rows.map((r) => r.achievementId).toSet();
  }

  Stream<List<(AchievementDef, DateTime?)>> watchAchievements() async* {
    final defs = <(AchievementDef, DateTime?)>[];
    for (final a in Achievements.all) {
      final row = await (_db.select(_db.achievementsUnlocked)
            ..where((t) => t.achievementId.equals(a.id)))
          .getSingleOrNull();
      defs.add((a, row == null ? null : DateTime.fromMillisecondsSinceEpoch(row.unlockedAt)));
    }
    yield defs;
  }

  Future<List<(AchievementDef, DateTime?)>> getAchievements() async {
    final result = <(AchievementDef, DateTime?)>[];
    for (final a in Achievements.all) {
      final row = await (_db.select(_db.achievementsUnlocked)
            ..where((t) => t.achievementId.equals(a.id)))
          .getSingleOrNull();
      result.add((a, row == null ? null : DateTime.fromMillisecondsSinceEpoch(row.unlockedAt)));
    }
    return result;
  }

  /// Stats snapshot for Profile / AI context / dashboard (§6.11).
  Future<UserStats> statsSnapshot({Set<String>? visitedScreens}) async {
    final row = await (_db.select(_db.userStatsTable)..where((t) => t.id.equals('main')))
        .getSingle();
    final goal = await getGoal();
    final unlocked = await _unlockedIds();
    final others = Achievements.all.where((a) => a.id != 'X4').map((a) => a.id).toSet();
    return UserStats(
      totalXp: row.totalXp,
      level: row.level,
      streakDays: row.streakDays,
      contributionsCount: row.contributionsCount,
      totalSaved: goal?.saved ?? 0,
      goalAmount: goal?.target ?? 0,
      scannerChecks: row.scannerChecks,
      priceDropsSeen: row.priceDropsSeen,
      goodDealSeen: row.goodDealSeen,
      visitedScreens: visitedScreens ?? row.visitedScreens.split(',').where((e) => e.isNotEmpty).toSet(),
      themeChanges: row.themeChanges,
      aiQuestions: row.aiQuestions,
      historyViewed30d: row.historyViewed30d,
      maxSingleContribution: row.maxSingleContribution,
      registeredAt: row.registeredAt != null
          ? DateTime.fromMillisecondsSinceEpoch(row.registeredAt!)
          : null,
      allOthersUnlocked: unlocked.containsAll(others),
      today: kyivNow(),
    );
  }

  Future<void> updateStats(UserStatsTableCompanion patch) async {
    await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main'))).write(patch);
  }

  Future<UserStatsTableData> rawStats() async =>
      (_db.select(_db.userStatsTable)..where((t) => t.id.equals('main'))).getSingle();

  bool _isReturnAfterPause(String? lastDay, String today) {
    if (lastDay == null) return false;
    final last = DateTime.tryParse(lastDay);
    final now = DateTime.tryParse(today);
    if (last == null || now == null) return false;
    final diff = now.difference(last).inDays;
    return diff >= 7;
  }

  // ── Auth / account (§6.14 Local-First Merge) ──────────────────────────
  /// ⛔ Guest migration: local data is ADDED to the cloud profile with
  /// original timestamps; overwriting cloud data is forbidden. With the
  /// local-only gateway this marks all rows pending sync — nothing is lost.
  Future<int> prepareGuestMigration() async {
    var pending = 0;
    await _db.transaction(() async {
      final rows = await _db.select(_db.contributions).get();
      for (final r in rows) {
        if (!r.synced) {
          await _sync.enqueue(entityId: r.id, entityType: 'contribution', payload: {
            'id': r.id,
            'amount': r.amount,
            'occurred_at': r.occurredAt,
            'comment': r.comment,
          });
          pending++;
        }
      }
      final goal = await _db.select(_db.goals).get();
      for (final g in goal) {
        await _sync.enqueue(entityId: g.id, entityType: 'goal', payload: {
          'id': g.id,
          'title': g.title,
          'created_at': g.createdAt,
        });
        pending++;
      }
    });
    return pending;
  }

  Future<void> setAccount({required String? email, required bool authed}) async {
    await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main'))).write(
      UserStatsTableCompanion(
        email: Value(email),
        authed: Value(authed),
        registeredAt: authed ? Value(DateTime.now().millisecondsSinceEpoch) : const Value.absent(),
      ),
    );
  }

  Future<void> setNickname(String nick) async {
    await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main')))
        .write(UserStatsTableCompanion(nickname: Value(nick)));
  }

  /// Local wipe for Delete Account (§6.20): local data removal after cloud
  /// deletion request. Pet/progress never migrate; full reset → Splash.
  Future<void> wipeLocalData() async {
    await _db.transaction(() async {
      await _db.contributions.deleteAll();
      await _db.goals.deleteAll();
      await _db.goalItems.deleteAll();
      await _db.achievementsUnlocked.deleteAll();
      await _db.chatMessages.deleteAll();
      await _db.notificationsCache.deleteAll();
      await _db.syncQueue.deleteAll();
      await _db.chipsLedger.deleteAll();
      await _db.questsDaily.deleteAll();
      await _db.questsWeekly.deleteAll();
      await _db.holoOwned.deleteAll();
      await _db.ghostCache.deleteAll();
      await _db.eventQuests.deleteAll();
      await _db.searchHistory.deleteAll();
      await _db.apiKeys.deleteAll();
      await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main'))).write(
        const UserStatsTableCompanion(
          totalXp: Value(0),
          level: Value(1),
          streakDays: Value(0),
          contributionsCount: Value(0),
          lastContributionDay: Value(null),
          authed: Value(false),
          email: Value(null),
          registeredAt: Value(null),
          nickname: Value(''),
        ),
      );
      await (_db.update(_db.chipsWalletTable)..where((t) => t.id.equals('main')))
          .write(const ChipsWalletTableCompanion(balance: Value(0), dust: Value(0)));
      await (_db.update(_db.pets)..where((t) => t.id.equals('main'))).write(
        const PetsCompanion(
          form: Value('egg'),
          mood: Value('happy'),
          hatchedAt: Value(null),
          feedCount: Value(0),
        ),
      );
      await (_db.update(_db.chests)..where((t) => t.id.equals('main')))
          .write(const ChestsCompanion(chain: Value(0), lastOpenedDay: Value(null)));
    });
  }

  String _uuid() => const Uuid().v4();
}

void unawaitedSync(Future<void> f) {
  // Intentionally unawaited: the sync queue schedules retries with backoff.
  f.ignore();
}

enum HistoryFilter { all, month, year }

/// Visitor bookkeeping for O2 «Дослідник» (§5.3).
extension VisitTracking on GoalRepository {
  Future<void> trackScreenVisit(String screen) async {
    final row = await rawStats();
    final set = row.visitedScreens.split(',').where((e) => e.isNotEmpty).toSet();
    if (set.contains(screen)) return;
    set.add(screen);
    await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main'))).write(
      UserStatsTableCompanion(visitedScreens: Value(set.join(','))),
    );
  }

  Future<void> trackScannerCheck() async {
    final row = await rawStats();
    await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main'))).write(
      UserStatsTableCompanion(scannerChecks: Value(row.scannerChecks + 1)),
    );
  }

  Future<void> trackAiQuestion() async {
    final row = await rawStats();
    await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main'))).write(
      UserStatsTableCompanion(aiQuestions: Value(row.aiQuestions + 1)),
    );
  }

  Future<void> trackThemeChange() async {
    final row = await rawStats();
    await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main'))).write(
      UserStatsTableCompanion(themeChanges: Value(row.themeChanges + 1)),
    );
  }

  Future<void> markHistoryViewed30d() async {
    await (_db.update(_db.userStatsTable)..where((t) => t.id.equals('main')))
        .write(const UserStatsTableCompanion(historyViewed30d: Value(true)));
  }
}

final goalRepositoryProvider = Provider<GoalRepository>((ref) => GoalRepository(ref));

/// Watched stats row for reactive UI (header XP etc.).
final statsRowProvider = StreamProvider<UserStatsTableData>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.userStatsTable)..where((t) => t.id.equals('main')))
      .watchSingle();
});

final goalProvider = StreamProvider<GoalView?>(
    (ref) => ref.watch(goalRepositoryProvider).watchGoal());

/// Notifications from the contribution pipeline are posted by the caller
/// (UI layer) — the repository stays persistence-only.
String encodeParams(Map<String, Object?> params) => jsonEncode(params);
