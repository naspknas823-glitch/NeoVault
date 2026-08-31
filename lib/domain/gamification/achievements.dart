import 'package:intl/intl.dart';

import 'xp_engine.dart';

/// Achievement categories (§5.3).
enum AchievementCategory {
  financial('cat_financial'),
  regularity('cat_regular'),
  priceHunter('cat_price'),
  levels('cat_level'),
  exploration('cat_explore'),
  seasonal('cat_season'),
  secret('cat_secret');

  const AchievementCategory(this.l10nKey);
  final String l10nKey;
}

/// Static definition of one achievement (§5.3 — all 40).
class AchievementDef {
  const AchievementDef({
    required this.id,
    required this.name,
    required this.category,
    required this.bonusXp,
    this.secret = false,
  });

  final String id;
  final String name;
  final AchievementCategory category;
  final int bonusXp;
  final bool secret;
}

/// All 40 achievements (§5.3) with condition evaluators.
abstract final class Achievements {
  static const List<AchievementDef> all = [
    // Financial (F1–F10)
    AchievementDef(id: 'F1', name: 'Перший крок', category: AchievementCategory.financial, bonusXp: 20),
    AchievementDef(id: 'F2', name: '₴1 000', category: AchievementCategory.financial, bonusXp: 15),
    AchievementDef(id: 'F3', name: '₴5 000', category: AchievementCategory.financial, bonusXp: 30),
    AchievementDef(id: 'F4', name: '₴10 000', category: AchievementCategory.financial, bonusXp: 50),
    AchievementDef(id: 'F5', name: '₴25 000', category: AchievementCategory.financial, bonusXp: 100),
    AchievementDef(id: 'F6', name: '₴50 000+', category: AchievementCategory.financial, bonusXp: 200),
    AchievementDef(id: 'F7', name: 'Ціль досягнута!', category: AchievementCategory.financial, bonusXp: 150),
    AchievementDef(id: 'F8', name: 'Залишок < 10%', category: AchievementCategory.financial, bonusXp: 25),
    AchievementDef(id: 'F9', name: 'Золотий внесок', category: AchievementCategory.financial, bonusXp: 40),
    AchievementDef(id: 'F10', name: 'Мега-внесок', category: AchievementCategory.financial, bonusXp: 75),
    // Regularity (S1–S7)
    AchievementDef(id: 'S1', name: 'Стрик 2', category: AchievementCategory.regularity, bonusXp: 10),
    AchievementDef(id: 'S2', name: 'Тижневий марафон', category: AchievementCategory.regularity, bonusXp: 40),
    AchievementDef(id: 'S3', name: 'Стрик 14', category: AchievementCategory.regularity, bonusXp: 60),
    AchievementDef(id: 'S4', name: 'Місячна дисципліна', category: AchievementCategory.regularity, bonusXp: 100),
    AchievementDef(id: 'S5', name: 'Стрик 90', category: AchievementCategory.regularity, bonusXp: 250),
    AchievementDef(id: 'S6', name: 'Річний подвиг', category: AchievementCategory.regularity, bonusXp: 500),
    AchievementDef(id: 'S7', name: 'Повернення', category: AchievementCategory.regularity, bonusXp: 15),
    // Price hunter (P1–P5)
    AchievementDef(id: 'P1', name: '10 перевірок', category: AchievementCategory.priceHunter, bonusXp: 15),
    AchievementDef(id: 'P2', name: '50 перевірок', category: AchievementCategory.priceHunter, bonusXp: 50),
    AchievementDef(id: 'P3', name: '200 перевірок', category: AchievementCategory.priceHunter, bonusXp: 120),
    AchievementDef(id: 'P4', name: '5 падінь ціни', category: AchievementCategory.priceHunter, bonusXp: 30),
    AchievementDef(id: 'P5', name: 'Вигідна покупка', category: AchievementCategory.priceHunter, bonusXp: 25),
    // Levels (G1–G5)
    AchievementDef(id: 'G1', name: 'Рівень 2', category: AchievementCategory.levels, bonusXp: 10),
    AchievementDef(id: 'G2', name: 'Рівень 3', category: AchievementCategory.levels, bonusXp: 20),
    AchievementDef(id: 'G3', name: 'Рівень 5', category: AchievementCategory.levels, bonusXp: 50),
    AchievementDef(id: 'G4', name: 'Легенда', category: AchievementCategory.levels, bonusXp: 150),
    AchievementDef(id: 'G5', name: 'Рівень 20', category: AchievementCategory.levels, bonusXp: 500),
    // Exploration (O1–O5)
    AchievementDef(id: 'O1', name: 'Швидкий старт', category: AchievementCategory.exploration, bonusXp: 10),
    AchievementDef(id: 'O2', name: 'Дослідник', category: AchievementCategory.exploration, bonusXp: 25),
    AchievementDef(id: 'O3', name: 'Тематик', category: AchievementCategory.exploration, bonusXp: 20),
    AchievementDef(id: 'O4', name: 'AI-користувач', category: AchievementCategory.exploration, bonusXp: 10),
    AchievementDef(id: 'O5', name: 'Подорож у часі', category: AchievementCategory.exploration, bonusXp: 15),
    // Seasonal (L1–L3)
    AchievementDef(id: 'L1', name: 'Новорічний бонус', category: AchievementCategory.seasonal, bonusXp: 100),
    AchievementDef(id: 'L2', name: "Чорна п'ятниця", category: AchievementCategory.seasonal, bonusXp: 75),
    AchievementDef(id: 'L3', name: 'День народження', category: AchievementCategory.seasonal, bonusXp: 50),
    // Secret (X1–X4)
    AchievementDef(id: 'X1', name: 'Совина година', category: AchievementCategory.secret, bonusXp: 30, secret: true),
    AchievementDef(id: 'X2', name: 'Ранній птах', category: AchievementCategory.secret, bonusXp: 30, secret: true),
    AchievementDef(id: 'X3', name: 'Тисяча сил', category: AchievementCategory.secret, bonusXp: 75, secret: true),
    AchievementDef(id: 'X4', name: 'Колекціонер', category: AchievementCategory.secret, bonusXp: 250, secret: true),
  ];

  /// Screens tracked for the O2 «Дослідник» achievement.
  static const List<String> trackableScreens = [
    'dashboard', 'history', 'scanner', 'ai', 'achievements', 'notifications',
    'settings', 'themes', 'premium', 'pet', 'quests', 'leaderboard',
    'progress_card', 'collection', 'events', 'buddy', 'bundle_search',
    'api_settings', 'export', 'victory', 'pin', 'referral', 'auth', 'add_money',
  ];

  static AchievementDef? byId(String id) {
    for (final a in all) {
      if (a.id == id) return a;
    }
    return null;
  }

  /// Evaluate: ids of achievements whose condition is satisfied by [s]
  /// but NOT present in [unlocked]. X4 (all others) is excluded here —
  /// it is granted by the repository only when 39 others are unlocked.
  static List<String> newlyUnlocked(UserStats s, Set<String> unlocked) {
    final result = <String>[];
    for (final a in all) {
      if (unlocked.contains(a.id)) continue;
      final cond = _conditions[a.id];
      if (cond == null) continue;
      if (cond(s)) result.add(a.id);
    }
    return result;
  }

  static final Map<String, bool Function(UserStats)> _conditions = {
    'F1': (s) => s.contributionsCount >= 1,
    'F2': (s) => s.totalSaved >= 1000,
    'F3': (s) => s.totalSaved >= 5000,
    'F4': (s) => s.totalSaved >= 10000,
    'F5': (s) => s.totalSaved >= 25000,
    'F6': (s) => s.totalSaved >= 50000,
    'F7': (s) => s.goalCompleted,
    'F8': (s) => s.goalAmount > 0 && s.goalPercent >= 90,
    'F9': (s) => s.maxSingleContribution >= 5000,
    'F10': (s) => s.maxSingleContribution >= 10000,
    'S1': (s) => s.streakDays >= 2,
    'S2': (s) => s.streakDays >= 7,
    'S3': (s) => s.streakDays >= 14,
    'S4': (s) => s.streakDays >= 30,
    'S5': (s) => s.streakDays >= 90,
    'S6': (s) => s.streakDays >= 365,
    'S7': (s) => s.returnedAfterPause,
    'P1': (s) => s.scannerChecks >= 10,
    'P2': (s) => s.scannerChecks >= 50,
    'P3': (s) => s.scannerChecks >= 200,
    'P4': (s) => s.priceDropsSeen >= 5,
    'P5': (s) => s.goodDealSeen,
    'G1': (s) => s.level >= 2,
    'G2': (s) => s.level >= 3,
    'G3': (s) => s.level >= 5,
    'G4': (s) => s.level >= 10,
    'G5': (s) => s.level >= 20,
    'O1': (s) => s.onboardedWithFirstContribution,
    'O2': (s) => s.visitedScreens.containsAll(trackableScreens),
    'O3': (s) => s.themeChanges >= 5,
    'O4': (s) => s.aiQuestions >= 1,
    'O5': (s) => s.historyViewed30d,
    'L1': (s) => _isNewYear(s),
    'L2': (s) => _isBlackFriday(s),
    'L3': (s) => _isBirthday(s),
    'X1': (s) => s.nightOwlContribution,
    'X2': (s) => s.earlyBirdContribution,
    'X3': (s) => s.totalXp >= 1000,
    'X4': (s) => s.allOthersUnlocked,
  };

  static bool _isNewYear(UserStats s) =>
      s.lastContributionDate != null &&
      s.lastContributionDate!.month == 1 &&
      s.lastContributionDate!.day == 1;

  static bool _isBlackFriday(UserStats s) {
    final d = s.lastContributionDate;
    if (d == null) return false;
    return d.month == 11 &&
        d.weekday == DateTime.thursday &&
        (d.day + 6) ~/ 7 == 4;
  }

  static bool _isBirthday(UserStats s) {
    final reg = s.registeredAt;
    final ref = s.lastContributionDate;
    if (reg == null || ref == null) return false;
    final df = DateFormat('Md');
    return df.format(ref) == df.format(reg) && ref.year > reg.year;
  }
}

/// Night-owl (00:00–04:59) and early-bird (05:00–06:59) detection (§5.3).
bool isNightOwl(DateTime kyiv) => kyiv.hour <= 4;
bool isEarlyBird(DateTime kyiv) => kyiv.hour >= 5 && kyiv.hour <= 6;
