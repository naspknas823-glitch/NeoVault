import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/utils/format.dart';
import '../../domain/chests/daily_drop.dart';
import '../../domain/pet/pet_engine.dart' hide PetSkin;
import '../../domain/quests/quest_engine.dart';
import 'goal_repository.dart';
import 'providers.dart';

/// ── Neon Chips wallet (§10.0) ───────────────────────────────────────────
/// ⛔ NEVER converts to/from XP or money; sources: quests/chests/ghosts/
/// buddy/events/dust. Claim = Chips only, XP untouched (criterion 12.12).
class ChipsRepository {
  ChipsRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);

  Stream<ChipsWalletTableData> watch() => (_db.select(_db.chipsWalletTable)
        ..where((t) => t.id.equals('main')))
      .watchSingle();

  Future<ChipsWalletTableData> get() async => (_db.select(_db.chipsWalletTable)
        ..where((t) => t.id.equals('main')))
      .getSingle();

  Future<bool> spend(int amount, String reason, {String? refId}) async {
    final wallet = await get();
    if (!wallet.balance.canSpendChips(amount)) return false;
    await _apply(-amount, reason, refId: refId);
    return true;
  }

  Future<void> earn(int amount, String reason, {String? refId}) async {
    if (amount <= 0) return;
    await _apply(amount, reason, refId: refId);
  }

  Future<void> _apply(int delta, String reason, {String? refId}) async {
    await _db.transaction(() async {
      final wallet = await get();
      final newBalance = (wallet.balance + delta).clamp(0, 1 << 30);
      await (_db.update(_db.chipsWalletTable)..where((t) => t.id.equals('main')))
          .write(ChipsWalletTableCompanion(balance: Value(newBalance)));
      await _db.into(_db.chipsLedger).insert(ChipsLedgerCompanion.insert(
            reason: reason,
            delta: delta,
            refId: Value(refId),
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ));
    });
  }

  Future<void> addDust(int amount) async {
    if (amount <= 0) return;
    final wallet = await get();
    await (_db.update(_db.chipsWalletTable)..where((t) => t.id.equals('main')))
        .write(ChipsWalletTableCompanion(dust: Value(wallet.dust + amount)));
  }
}

extension _IntChips on int {
  bool canSpendChips(int amount) => this >= amount && amount >= 0;
}

/// ── Quests (§10.2) ──────────────────────────────────────────────────────
class QuestRepository {
  QuestRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);
  ChipsRepository get _chips => _ref.read(chipsRepositoryProvider);
  GoalRepository get _goals => _ref.read(goalRepositoryProvider);

  /// Today's 3 daily quests (reset 00:00 Kyiv, criterion 12.12) + progress.
  Future<List<QuestState>> dailyNow() async {
    final day = kyivDateKey();
    final defs = QuestEngine.dailyFor(day);
    final result = <QuestState>[];
    for (final d in defs) {
      final row = await (_db.select(_db.questsDaily)
            ..where((t) => t.id.equals('${d.id}:$day')))
          .getSingleOrNull();
      result.add(QuestState(
        def: d,
        progress: row?.progress ?? 0,
        claimed: row?.claimed ?? false,
        isWeekly: false,
      ));
    }
    return result;
  }

  Future<List<QuestState>> weeklyNow() async {
    final week = kyivDateKey(kyivWeekStart());
    final defs = QuestEngine.weeklyFor(kyivNow());
    final result = <QuestState>[];
    for (final d in defs) {
      final row = await (_db.select(_db.questsWeekly)
            ..where((t) => t.id.equals('${d.id}:$week')))
          .getSingleOrNull();
      result.add(QuestState(
        def: d,
        progress: row?.progress ?? 0,
        claimed: row?.claimed ?? false,
        isWeekly: true,
      ));
    }
    return result;
  }

  /// Track a local event (e.g. opened scanner) → advance matching quests.
  Future<void> track(QuestType type, {int by = 1}) async {
    final day = kyivDateKey();
    for (final d in QuestEngine.dailyFor(day)) {
      if (d.type != type) continue;
      await _advanceDaily(d, day, by);
    }
    final week = kyivDateKey(kyivWeekStart());
    for (final d in QuestEngine.weeklyFor(kyivNow())) {
      if (d.type != type) continue;
      final row = await (_db.select(_db.questsWeekly)
            ..where((t) => t.id.equals('${d.id}:$week')))
          .getSingleOrNull();
      final current = row?.progress ?? 0;
      // Weekly streak quest reads the live streak, handled at claim time.
      if (d.type == QuestType.weeklyStreak) continue;
      await _upsertWeekly(d, week, current + by);
    }
  }

  Future<void> _advanceDaily(QuestDef d, String day, int by) async {
    final id = '${d.id}:$day';
    final row = await (_db.select(_db.questsDaily)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    final current = row?.progress ?? 0;
    if (current >= d.target) return;
    await _db.into(_db.questsDaily).insertOnConflictUpdate(
          QuestsDailyCompanion.insert(
            id: id,
            questId: d.id,
            dayKey: day,
            progress: Value(min(current + by, d.target)),
            claimed: Value(row?.claimed ?? false),
          ),
        );
  }

  Future<void> _upsertWeekly(QuestDef d, String week, int progress) async {
    final id = '${d.id}:$week';
    final row = await (_db.select(_db.questsWeekly)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await _db.into(_db.questsWeekly).insertOnConflictUpdate(
          QuestsWeeklyCompanion.insert(
            id: id,
            questId: d.id,
            weekKey: week,
            progress: Value(min(progress, d.target)),
            claimed: Value(row?.claimed ?? false),
          ),
        );
  }

  /// CLAIM: grants Chips and NEVER XP (⛔ §9.10 — unit-tested).
  Future<int> claim(QuestState q) async {
    if (q.claimed || !q.isComplete) return 0;
    final chips = q.def.rewardChips;
    if (q.isWeekly) {
      final week = kyivDateKey(kyivWeekStart());
      final row = await (_db.select(_db.questsWeekly)
            ..where((t) => t.id.equals('${q.def.id}:$week')))
          .getSingleOrNull();
      if (row == null) return 0;
      await (_db.update(_db.questsWeekly)..where((t) => t.id.equals(row.id)))
          .write(const QuestsWeeklyCompanion(claimed: Value(true)));
    } else {
      final day = kyivDateKey();
      await (_db.update(_db.questsDaily)
            ..where((t) => t.id.equals('${q.def.id}:$day')))
          .write(const QuestsDailyCompanion(claimed: Value(true)));
    }
    await _chips.earn(chips, 'quest', refId: q.def.id);
    _ref.read(syncTickProvider.notifier).state++;
    return chips;
  }

  /// Sync weekly progress rows with live stats (streak).
  Future<void> syncWeeklyFromStats() async {
    final stats = await _goals.rawStats();
    final week = kyivDateKey(kyivWeekStart());
    for (final d in QuestEngine.weeklyFor(kyivNow())) {
      if (d.type == QuestType.weeklyStreak) {
        await _upsertWeekly(d, week, stats.streakDays);
      }
    }
  }
}

class QuestState {
  const QuestState({
    required this.def,
    required this.progress,
    required this.claimed,
    required this.isWeekly,
  });
  final QuestDef def;
  final int progress;
  final bool claimed;
  final bool isWeekly;

  bool get isComplete => progress >= def.target;
  double get progressFraction => def.target <= 0 ? 0 : (progress / def.target).clamp(0, 1);
}

/// ── Daily Drop (§10.3) ──────────────────────────────────────────────────
class ChestRepository {
  ChestRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);
  ChipsRepository get _chips => _ref.read(chipsRepositoryProvider);
  PetRepository get _pet => _ref.read(petRepositoryProvider);
  HoloRepository get _holo => _ref.read(holoRepositoryProvider);

  Future<ChestState> stateNow() async {
    final row = await (_db.select(_db.chests)..where((t) => t.id.equals('main')))
        .getSingle();
    final today = kyivDateKey();
    final available = DailyDropEngine.isAvailable(row.lastOpenedDay, today);
    return ChestState(
      availableToday: available,
      chain: row.chain,
      lastOpenedDay: row.lastOpenedDay,
      totalOpened: row.totalOpened,
      isBigChestDay: DailyDropEngine.isBigChestDay(row.chain + 1) && available,
    );
  }

  /// ⛔ Strictly 1/day. Second call the same day throws [ChestAlreadyOpened].
  Future<ChestReward> open({int? seed}) async {
    final row = await (_db.select(_db.chests)..where((t) => t.id.equals('main')))
        .getSingle();
    final today = kyivDateKey();
    final chain = DailyDropEngine.nextChain(row.lastOpenedDay, today, row.chain);
    final big = DailyDropEngine.isBigChestDay(chain);
    final rng = Random(seed ?? DateTime.now().millisecondsSinceEpoch);
    final reward = resolveOdds(DailyDropEngine.roll(
      big ? DailyDropEngine.bigOdds : DailyDropEngine.normalOdds,
      rng,
    ), rng, bigChest: big);

    switch (reward.kind) {
      case ChestRewardKind.chips:
        await _chips.earn(reward.chips, 'chest');
        break;
      case ChestRewardKind.petFeed:
        await _pet.bumpFeedPacks();
        break;
      case ChestRewardKind.pack:
      case ChestRewardKind.rareCard:
        await _holo.grantPack(rareCard: reward.kind == ChestRewardKind.rareCard);
        break;
    }

    await (_db.update(_db.chests)..where((t) => t.id.equals('main'))).write(
      ChestsCompanion(
        lastOpenedDay: Value(today),
        chain: Value(chain),
        totalOpened: Value(row.totalOpened + 1),
      ),
    );
    _ref.read(chestOpenedTickProvider.notifier).state++;
    return reward;
  }
}

class ChestState {
  const ChestState({
    required this.availableToday,
    required this.chain,
    required this.lastOpenedDay,
    required this.totalOpened,
    required this.isBigChestDay,
  });
  final bool availableToday;
  final int chain;
  final String? lastOpenedDay;
  final int totalOpened;
  final bool isBigChestDay;
}

class ChestAlreadyOpened implements Exception {
  const ChestAlreadyOpened();
  @override
  String toString() => 'chest already opened today';
}

/// ── Vault Pet (§10.1) ───────────────────────────────────────────────────
class PetRepository {
  PetRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);
  ChipsRepository get _chips => _ref.read(chipsRepositoryProvider);
  GoalRepository get _goals => _ref.read(goalRepositoryProvider);

  Future<Pet> _row() async =>
      (_db.select(_db.pets)..where((t) => t.id.equals('main'))).getSingle();

  Stream<Pet> watch() => (_db.select(_db.pets)..where((t) => t.id.equals('main')))
      .watchSingle();

  /// Visit tracking: mood update on open (§10.1 mood rules).
  Future<PetState> stateNow() async {
    final row = await _row();
    final goal = await _goals.getGoal();
    final stats = await _goals.rawStats();
    final daysSinceOpen = _daysSince(row.lastOpenDay);
    final form = evolveForm(
      current: PetForm.values.byName(row.form),
      contributionsCount: stats.contributionsCount,
      streakDays: stats.streakDays,
      level: GamificationLevelHelper.level(stats.totalXp),
      goalPercent: goal?.percent ?? 0,
    );
    if (form.name != row.form) {
      await (_db.update(_db.pets)..where((t) => t.id.equals('main')))
          .write(PetsCompanion(form: Value(form.name)));
      if (row.form == 'egg' && form != PetForm.egg) {
        await (_db.update(_db.pets)..where((t) => t.id.equals('main'))).write(
          PetsCompanion(hatchedAt: Value(DateTime.now().millisecondsSinceEpoch)),
        );
      }
    }
    final today = kyivDateKey();
    if (row.lastOpenDay != today) {
      await (_db.update(_db.pets)..where((t) => t.id.equals('main')))
          .write(PetsCompanion(lastOpenDay: Value(today)));
    }
    final mood = moodFor(daysSinceOpen);
    if (mood.name != row.mood) {
      await (_db.update(_db.pets)..where((t) => t.id.equals('main')))
          .write(PetsCompanion(mood: Value(mood.name)));
    }
    return PetState(
      form: form,
      mood: mood,
      skin: row.skin,
      hatchedAt: row.hatchedAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.hatchedAt!),
      daysTogether: row.hatchedAt == null
          ? 0
          : DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(row.hatchedAt!)).inDays,
      feedCount: row.feedCount,
      contributionsNearby: stats.contributionsCount,
      lastActivityDay: row.lastOpenDay,
    );
  }

  /// Feed: 10 Chips (§10.0) → mood boost. No XP effect.
  Future<bool> feed() async {
    final ok = await _chips.spend(petFeedCostChips, 'feed');
    if (!ok) return false;
    final row = await _row();
    await (_db.update(_db.pets)..where((t) => t.id.equals('main'))).write(
      PetsCompanion(
        feedCount: Value(row.feedCount + 1),
        mood: Value(PetMood.happy.name),
        lastFedDay: Value(kyivDateKey()),
      ),
    );
    return true;
  }

  Future<void> setSkin(String skinId) async {
    await (_db.update(_db.pets)..where((t) => t.id.equals('main')))
        .write(PetsCompanion(skin: Value(skinId)));
  }

  Future<List<PetSkin>> skins() async => _db.select(_db.petSkins).get();

  Future<void> ownSkin(String skinId) async {
    await _db.into(_db.petSkins).insertOnConflictUpdate(
          PetSkinsCompanion.insert(id: skinId, owned: const Value(true)),
        );
  }

  /// Chest reward «корм пета» — a free feed pack.
  Future<void> bumpFeedPacks() async {
    await feed();
  }

  Future<void> grantSadPushGuard() async {
    await (_db.update(_db.pets)..where((t) => t.id.equals('main'))).write(
      PetsCompanion(lastSadPushAt: Value(DateTime.now().millisecondsSinceEpoch)),
    );
  }

  int _daysSince(String? dayKey) {
    if (dayKey == null) return 0;
    final d = DateTime.tryParse(dayKey);
    if (d == null) return 0;
    final today = DateTime.tryParse(kyivDateKey())!;
    return today.difference(d).inDays;
  }
}

/// Small helper to avoid importing xp_engine twice in pet logic.
abstract final class GamificationLevelHelper {
  static int level(int xp) {
    var level = 1;
    var threshold = 0;
    var prev = 100;
    if (xp < prev) return 1;
    level = 2;
    threshold = prev;
    while (level < 20) {
      prev = (threshold * 1.5).ceil();
      if (xp < prev) return level;
      threshold = prev;
      level++;
    }
    return level;
  }
}

/// ── Holo-cards (§10.6) ──────────────────────────────────────────────────
class HoloRepository {
  HoloRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);
  ChipsRepository get _chips => _ref.read(chipsRepositoryProvider);

  Stream<List<HoloCard>> watchCards() => _db.select(_db.holoCards).watch();

  Stream<List<HoloOwnedData>> watchOwned() => _db.select(_db.holoOwned).watch();

  Future<List<HoloCard>> cards() async => _db.select(_db.holoCards).get();

  Future<List<HoloOwnedData>> owned() async => _db.select(_db.holoOwned).get();

  static const int packCost = 80;

  /// Open a pack (80 Chips): random card; duplicate → dust 5–25 (§10.0).
  Future<(HoloCard, bool isNew)> openPack({int? seed}) async {
    final ok = await _chips.spend(packCost, 'pack');
    if (!ok) throw const NotEnoughChips();
    final all = await cards();
    final rng = Random(seed ?? DateTime.now().millisecondsSinceEpoch);
    // Weight: c 60%, r 25%, e 12%, l 3%.
    final pool = <HoloCard>[];
    for (final c in all) {
      final w = switch (c.rarity) { 'c' => 60, 'r' => 25, 'e' => 12, _ => 3 };
      pool.addAll(List.filled(w, c));
    }
    final card = pool[rng.nextInt(pool.length)];
    final existing = await (_db.select(_db.holoOwned)
          ..where((t) => t.cardId.equals(card.id)))
        .getSingleOrNull();
    var isNew = existing == null;
    if (existing == null) {
      await _db.into(_db.holoOwned).insert(HoloOwnedCompanion.insert(
            cardId: card.id,
            copies: const Value(1),
            firstOwnedAt: DateTime.now().millisecondsSinceEpoch,
          ));
    } else {
      await (_db.update(_db.holoOwned)..where((t) => t.cardId.equals(card.id)))
          .write(HoloOwnedCompanion(copies: Value(existing.copies + 1)));
      await _chips.addDust(5 + rng.nextInt(21)); // 5–25 dust
    }
    return (card, isNew);
  }

  /// Auto-grant a pack from chests (rareCard guarantee).
  Future<HoloCard> grantPack({required bool rareCard}) async {
    final all = await cards();
    final rng = Random();
    final pool = rareCard
        ? all.where((c) => c.rarity == 'r' || c.rarity == 'e' || c.rarity == 'l').toList()
        : all;
    final card = pool[rng.nextInt(pool.length)];
    final existing = await (_db.select(_db.holoOwned)
          ..where((t) => t.cardId.equals(card.id)))
        .getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.holoOwned).insert(HoloOwnedCompanion.insert(
            cardId: card.id,
            copies: const Value(1),
            firstOwnedAt: DateTime.now().millisecondsSinceEpoch,
          ));
    } else {
      await (_db.update(_db.holoOwned)..where((t) => t.cardId.equals(card.id)))
          .write(HoloOwnedCompanion(copies: Value(existing.copies + 1)));
    }
    return card;
  }

  Future<int> ownedCount() async => _db.holoOwned.count().getSingle();
}

class NotEnoughChips implements Exception {
  const NotEnoughChips();
  @override
  String toString() => 'not enough chips';
}

/// ── Seasonal events (§10.7) ─────────────────────────────────────────────
class EventsRepository {
  EventsRepository(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(dbProvider);

  /// Active event read from app_config-driven cache (⛔ §9.15: server can
  /// start/stop events without APK update — repository honours status).
  Future<EventsCacheData?> activeEvent() async {
    final rows = await _db.select(_db.eventsCache).get();
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final r in rows) {
      if (r.status == 'active' && now >= r.startsAt && now <= r.endsAt) return r;
    }
    return null;
  }

  Future<List<EventQuest>> eventQuests(String eventId) async =>
      (_db.select(_db.eventQuests)..where((t) => t.eventId.equals(eventId))).get();

  Future<void> advanceEventQuest(String eventId, QuestType type, {int by = 1}) async {
    // Event quests map loosely: contributions/scanner/streak.
    final quests = await eventQuests(eventId);
    for (final q in quests) {
      final targetKey = q.titleKey;
      final matches = switch (targetKey) {
        'event.quest_contrib3' => type == QuestType.addContribution,
        'event.quest_scanner5' => type == QuestType.openScanner,
        'event.quest_streak5' => type == QuestType.weeklyStreak,
        _ => false,
      };
      if (!matches) continue;
      await (_db.update(_db.eventQuests)..where((t) => t.id.equals(q.id))).write(
        EventQuestsCompanion(progress: Value(min(q.progress + by, q.target))),
      );
    }
  }

  /// Claim event reward: +20–40 Chips or pet skin (§10.0).
  Future<bool> claimEventQuest(EventQuest q) async {
    if (q.claimed || q.progress < q.target) return false;
    await (_db.update(_db.eventQuests)..where((t) => t.id.equals(q.id)))
        .write(const EventQuestsCompanion(claimed: Value(true)));
    await _ref.read(chipsRepositoryProvider).earn(30, 'event', refId: q.id);
    return true;
  }

  Future<void> markReminderSet(String eventId) async {
    final row = await (_db.select(_db.eventsCache)..where((t) => t.id.equals(eventId)))
        .getSingleOrNull();
    if (row == null) return;
    await (_db.update(_db.eventsCache)..where((t) => t.id.equals(eventId))).write(
      EventsCacheCompanion(
        rewardsJson: Value(
            const JsonEncoder().convert({'reminderSet': true})),
      ),
    );
  }
}

final chipsRepositoryProvider = Provider<ChipsRepository>((ref) => ChipsRepository(ref));
final questRepositoryProvider = Provider<QuestRepository>((ref) => QuestRepository(ref));
final chestRepositoryProvider = Provider<ChestRepository>((ref) => ChestRepository(ref));
final petRepositoryProvider = Provider<PetRepository>((ref) => PetRepository(ref));
final holoRepositoryProvider = Provider<HoloRepository>((ref) => HoloRepository(ref));
final eventsRepositoryProvider = Provider<EventsRepository>((ref) => EventsRepository(ref));

/// UI ticks to invalidate streams after chest/holo mutations.
final chestOpenedTickProvider = StateProvider<int>((ref) => 0);
final holoChangedTickProvider = StateProvider<int>((ref) => 0);
final chipsChangedTickProvider = StateProvider<int>((ref) => 0);
