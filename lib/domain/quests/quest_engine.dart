import 'dart:math';

/// Neon Chips — cosmetic currency (§10.0). NEVER converts to/from XP or
/// money (⛔ §9.10/§9.11); never sold for real money.
class ChipsWallet {
  ChipsWallet({this.balance = 0, this.dust = 0});

  int balance;
  int dust;

  bool canSpend(int amount) => balance >= amount;

  /// Returns false if balance insufficient (no negative balance).
  bool spend(int amount) {
    if (amount < 0 || balance < amount) return false;
    balance -= amount;
    return true;
  }

  void earn(int amount) {
    if (amount <= 0) return;
    balance += amount;
  }

  /// Duplicate holo-card → dust (5–25 Chips equivalent, §10.0).
  void addDust(int amount) {
    if (amount <= 0) return;
    dust += amount;
  }
}

/// Quest types mapped to local event sources (§10.2).
enum QuestType {
  openScanner,
  askAi,
  addContribution,
  openChest,
  visitPet,
  viewHistory,
  weeklyContributions,
  weeklyStreak,
  weeklyScannerOpens,
  weeklyVisits,
}

class QuestDef {
  const QuestDef({
    required this.id,
    required this.type,
    required this.titleL10nKey,
    required this.rewardChips,
    required this.target,
    this.isMain = false,
    this.shardReward = 0,
  });

  final String id;
  final QuestType type;
  final String titleL10nKey;
  final int rewardChips;
  final int target;
  final bool isMain;
  final int shardReward;
}

/// Daily quest pool (§10.2 examples) + weekly chain pool.
abstract final class QuestPool {
  static const List<QuestDef> daily = [
    QuestDef(id: 'd_scanner', type: QuestType.openScanner, titleL10nKey: 'quests.quest_check_scanner', rewardChips: 10, target: 1),
    QuestDef(id: 'd_ai', type: QuestType.askAi, titleL10nKey: 'quests.quest_ask_ai', rewardChips: 10, target: 1),
    QuestDef(id: 'd_contrib', type: QuestType.addContribution, titleL10nKey: 'quests.quest_add_contrib', rewardChips: 25, target: 1, isMain: true),
    QuestDef(id: 'd_chest', type: QuestType.openChest, titleL10nKey: 'quests.quest_open_chest', rewardChips: 10, target: 1),
    QuestDef(id: 'd_pet', type: QuestType.visitPet, titleL10nKey: 'quests.quest_visit_pet', rewardChips: 10, target: 1),
    QuestDef(id: 'd_history', type: QuestType.viewHistory, titleL10nKey: 'quests.quest_view_history', rewardChips: 10, target: 1),
  ];

  static const List<QuestDef> weekly = [
    QuestDef(id: 'w_contrib3', type: QuestType.weeklyContributions, titleL10nKey: 'quests.quest_w1', rewardChips: 50, target: 3),
    QuestDef(id: 'w_streak7', type: QuestType.weeklyStreak, titleL10nKey: 'quests.quest_w2', rewardChips: 60, target: 7),
    QuestDef(id: 'w_scanner10', type: QuestType.weeklyScannerOpens, titleL10nKey: 'quests.quest_w3', rewardChips: 50, target: 10),
    QuestDef(id: 'w_visits5', type: QuestType.weeklyVisits, titleL10nKey: 'quests.quest_w4', rewardChips: 50, target: 5),
  ];
}

/// Quest engine: deterministic daily rotation (reset 00:00 Kyiv) and
/// weekly chain; claim grants Chips and NEVER XP (⛔ §9.10, criterion 12.12).
class QuestEngine {
  /// Pick exactly 3 daily quests deterministically from the day key.
  /// [dayKey] = yyyy-MM-dd (Kyiv). The main quest ⭐ (addContribution)
  /// is always included; the remaining two rotate by day seed.
  static List<QuestDef> dailyFor(String dayKey) {
    var seed = 0;
    for (final c in dayKey.codeUnits) {
      seed = (seed * 31 + c) & 0x7fffffff;
    }
    final rng = Random(seed);
    final pool = QuestPool.daily.where((q) => !q.isMain).toList()..shuffle(rng);
    final main = QuestPool.daily.firstWhere((q) => q.isMain);
    return [main, pool[0], pool[1]];
  }

  /// Weekly chain of 3 quests from the ISO week (Monday-based, Kyiv).
  static List<QuestDef> weeklyFor(DateTime kyivNow) {
    final monday = DateTime(kyivNow.year, kyivNow.month, kyivNow.day)
        .subtract(Duration(days: (kyivNow.weekday - DateTime.monday) % 7));
    final weekIndex = monday.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay ~/ 7;
    final rng = Random(weekIndex);
    final pool = [...QuestPool.weekly]..shuffle(rng);
    return pool.take(3).toList();
  }

  /// Claim: chips only. Returns reward amount; XP must NOT be granted —
  /// enforced by callers using this engine only for chips (unit-tested).
  static int claimReward(QuestDef q) => q.rewardChips;
}
