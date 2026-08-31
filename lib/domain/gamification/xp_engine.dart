import 'dart:math';

/// Gamification engine — spec §5.1 formulas, HARD-FIXED constants (⛔ §9.3).
/// XP sources: financial actions ONLY (§5.1); retention NEVER gives XP (⛔ §9.10).
abstract final class Gamification {
  static const int baseXpPerTransaction = 10;
  static const int maxXpBonus = 50;
  static const int level2Threshold = 100;

  /// XP for one contribution: 10 + min(floor(amount / 500) * 5, 50).
  /// 200 ₴ → 10 XP; 1200 ₴ → 20 XP; 6000 ₴ → 60 XP.
  static int xpForContribution(num amount, {int streakDays = 0}) {
    final bonus = min((amount ~/ 500) * 5, maxXpBonus);
    final base = baseXpPerTransaction + bonus;
    return base + streakBonusXp(streakDays);
  }

  /// Streak bonus: min(days * 2, 20). Applied to the contribution made on
  /// a calendar day continuing the streak.
  static int streakBonusXp(int streakDays) => min(streakDays * 2, 20);

  /// Level thresholds L1..L20. L2 = 100; L_n = ceil(prev * 1.5).
  /// L1..L10 → 0, 100, 150, 225, 338, 507, 761, 1142, 1713, 2570.
  /// (Spec table lists 760/1141/1711/2567 for L7+ — an arithmetic slip in the
  /// source doc; the ⛔-fixed formula ceil(prev*1.5) is authoritative.)
  static List<int> levelThresholds({int maxLevel = 20}) {
    final list = <int>[0];
    var prev = level2Threshold;
    list.add(prev);
    for (var i = 3; i <= maxLevel; i++) {
      prev = (prev * 1.5).ceil();
      list.add(prev);
    }
    return list;
  }

  /// Cumulative XP → current level (1-based).
  static int levelForXp(int totalXp, {int maxLevel = 20}) {
    final th = levelThresholds(maxLevel: maxLevel);
    var level = 1;
    for (var i = 1; i < th.length; i++) {
      if (totalXp >= th[i]) level = i + 1;
    }
    return level;
  }

  /// Progress [0..1] toward the next level; 1 when at max level.
  static double levelProgress(int totalXp, {int maxLevel = 20}) {
    final th = levelThresholds(maxLevel: maxLevel);
    final level = levelForXp(totalXp, maxLevel: maxLevel);
    if (level >= maxLevel) return 1;
    final cur = th[level - 1];
    final next = th[level];
    return (totalXp - cur) / (next - cur);
  }

  /// Metal rank by level (§5.2): Bronze L1-2, Silver L3-4, Gold L5-6,
  /// Platinum L7-8, Diamond L9-10, Diamond+ beyond.
  static Rank rankForLevel(int level) {
    if (level <= 2) return Rank.bronze;
    if (level <= 4) return Rank.silver;
    if (level <= 6) return Rank.gold;
    if (level <= 8) return Rank.platinum;
    return Rank.diamond;
  }
}

enum Rank { bronze, silver, gold, platinum, diamond }

/// Streak engine §5.1: contribution at least once per calendar day
/// (Kyiv tz); a missed day hard-resets (no freeze).
class StreakEngine {
  /// Compute the new streak length after a contribution on [todayKey],
  /// given the last contribution day key.
  /// Same day → unchanged; consecutive day → +1; gap → reset to 1.
  static int nextStreak(String? lastDayKey, String todayKey, int currentStreak) {
    if (lastDayKey == null) return 1;
    if (lastDayKey == todayKey) return currentStreak <= 0 ? 1 : currentStreak;
    final last = DateTime.tryParse(lastDayKey);
    final today = DateTime.tryParse(todayKey);
    if (last == null || today == null) return 1;
    final diff = today.difference(last).inDays;
    if (diff == 1) return currentStreak + 1;
    return 1;
  }

  /// True if the streak is at risk: last contribution was yesterday and
  /// no contribution has been made today yet.
  static bool isAtRisk(String? lastDayKey, String todayKey) {
    if (lastDayKey == null) return false;
    final last = DateTime.tryParse(lastDayKey);
    final today = DateTime.tryParse(todayKey);
    if (last == null || today == null) return false;
    return today.difference(last).inDays == 1;
  }
}

/// User stats snapshot used by achievements/bundle/ai context.
class UserStats {
  UserStats({
    this.totalXp = 0,
    this.level = 1,
    this.streakDays = 0,
    this.contributionsCount = 0,
    this.totalSaved = 0,
    this.goalAmount = 0,
    this.scannerChecks = 0,
    this.priceDropsSeen = 0,
    this.goodDealSeen = false,
    this.visitedScreens = const <String>{},
    this.themeChanges = 0,
    this.aiQuestions = 0,
    this.historyViewed30d = false,
    this.nightOwlContribution = false,
    this.earlyBirdContribution = false,
    this.installDate,
    this.firstContributionAt,
    this.registeredAt,
    this.goalCompleted = false,
    this.allOthersUnlocked = false,
    this.maxSingleContribution = 0,
    this.returnedAfterPause = false,
    this.onboardedWithFirstContribution = false,
    this.lastContributionDate,
    DateTime? today,
  }) : today = today ?? DateTime(2026);

  final int totalXp;
  final int level;
  final int streakDays;
  final int contributionsCount;
  final num totalSaved;
  final num goalAmount;
  final int scannerChecks;
  final int priceDropsSeen;
  final bool goodDealSeen;
  final Set<String> visitedScreens;
  final int themeChanges;
  final int aiQuestions;
  final bool historyViewed30d;
  final bool nightOwlContribution;
  final bool earlyBirdContribution;
  final DateTime? installDate;
  final DateTime? firstContributionAt;
  final DateTime? registeredAt;
  final bool goalCompleted;
  final bool allOthersUnlocked;

  /// Largest single contribution (F9/F10 conditions).
  final int maxSingleContribution;
  /// Contribution made after a pause ≥ 7 days (S7).
  final bool returnedAfterPause;
  /// Onboarding finished together with the first contribution (O1).
  final bool onboardedWithFirstContribution;
  /// Date (Kyiv) of the most recent contribution (seasonal checks).
  final DateTime? lastContributionDate;
  /// Evaluation context "now" (Kyiv).
  final DateTime today;

  double get goalPercent => goalAmount <= 0 ? 0 : (totalSaved / goalAmount * 100);

  UserStats copyWith({
    int? totalXp,
    int? level,
    int? streakDays,
    int? contributionsCount,
    num? totalSaved,
    num? goalAmount,
    int? scannerChecks,
    int? priceDropsSeen,
    bool? goodDealSeen,
    Set<String>? visitedScreens,
    int? themeChanges,
    int? aiQuestions,
    bool? historyViewed30d,
    bool? nightOwlContribution,
    bool? earlyBirdContribution,
    DateTime? installDate,
    DateTime? firstContributionAt,
    DateTime? registeredAt,
    bool? goalCompleted,
    bool? allOthersUnlocked,
    int? maxSingleContribution,
    bool? returnedAfterPause,
    bool? onboardedWithFirstContribution,
    DateTime? lastContributionDate,
    DateTime? today,
  }) {
    return UserStats(
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      streakDays: streakDays ?? this.streakDays,
      contributionsCount: contributionsCount ?? this.contributionsCount,
      totalSaved: totalSaved ?? this.totalSaved,
      goalAmount: goalAmount ?? this.goalAmount,
      scannerChecks: scannerChecks ?? this.scannerChecks,
      priceDropsSeen: priceDropsSeen ?? this.priceDropsSeen,
      goodDealSeen: goodDealSeen ?? this.goodDealSeen,
      visitedScreens: visitedScreens ?? this.visitedScreens,
      themeChanges: themeChanges ?? this.themeChanges,
      aiQuestions: aiQuestions ?? this.aiQuestions,
      historyViewed30d: historyViewed30d ?? this.historyViewed30d,
      nightOwlContribution: nightOwlContribution ?? this.nightOwlContribution,
      earlyBirdContribution: earlyBirdContribution ?? this.earlyBirdContribution,
      installDate: installDate ?? this.installDate,
      firstContributionAt: firstContributionAt ?? this.firstContributionAt,
      registeredAt: registeredAt ?? this.registeredAt,
      goalCompleted: goalCompleted ?? this.goalCompleted,
      allOthersUnlocked: allOthersUnlocked ?? this.allOthersUnlocked,
      maxSingleContribution: maxSingleContribution ?? this.maxSingleContribution,
      returnedAfterPause: returnedAfterPause ?? this.returnedAfterPause,
      onboardedWithFirstContribution:
          onboardedWithFirstContribution ?? this.onboardedWithFirstContribution,
      lastContributionDate: lastContributionDate ?? this.lastContributionDate,
      today: today ?? this.today,
    );
  }
}
