import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/domain/gamification/achievements.dart';
import 'package:neovault/domain/gamification/xp_engine.dart';

/// Gamification engine tests — spec §5.1 formulas (⛔ fixed, criterion 12.4).
void main() {
  group('XP formula (§5.1)', () {
    test('200 ₴ → 10 XP', () {
      expect(Gamification.xpForContribution(200), 10);
    });

    test('1200 ₴ → 20 XP', () {
      expect(Gamification.xpForContribution(1200), 20);
    });

    test('6000 ₴ → 60 XP (bonus capped at 50)', () {
      expect(Gamification.xpForContribution(6000), 60);
    });

    test('bonus cap: 10000 ₴ still 60 XP base', () {
      expect(Gamification.xpForContribution(100000), 60);
    });

    test('streak bonus: min(days*2, 20)', () {
      expect(Gamification.streakBonusXp(0), 0);
      expect(Gamification.streakBonusXp(1), 2);
      expect(Gamification.streakBonusXp(5), 10);
      expect(Gamification.streakBonusXp(10), 20);
      expect(Gamification.streakBonusXp(30), 20); // capped
    });

    test('200 ₴ on streak day 5 → 10 + 10 = 20 XP', () {
      expect(Gamification.xpForContribution(200, streakDays: 5), 20);
    });
  });

  group('Levels (§5.1 LEVEL_N = ceil(prev*1.5))', () {
    test('thresholds L1..L10: 0, 100, 150, 225, 338', () {
      final th = Gamification.levelThresholds();
      expect(th[0], 0);
      expect(th[1], 100);
      expect(th[2], 150);
      expect(th[3], 225);
      expect(th[4], 338); // ceil(225*1.5) = ceil(337.5) = 338
      expect(th[5], 507);
    });

    test('L5 = 338 cumulative XP (criterion 12.4)', () {
      expect(Gamification.levelForXp(337), 4);
      expect(Gamification.levelForXp(338), 5);
    });

    test('L2 = 100', () {
      expect(Gamification.levelForXp(99), 1);
      expect(Gamification.levelForXp(100), 2);
    });

    test('level progress bounds', () {
      expect(Gamification.levelProgress(0), 0.0);
      expect(Gamification.levelProgress(50), 0.5);
      expect(Gamification.levelProgress(999999), 1.0);
    });
  });

  group('Ranks (§5.2)', () {
    test('Bronze L1-2, Silver L3-4, Gold L5-6, Platinum L7-8, Diamond L9+', () {
      expect(Gamification.rankForLevel(1), Rank.bronze);
      expect(Gamification.rankForLevel(2), Rank.bronze);
      expect(Gamification.rankForLevel(3), Rank.silver);
      expect(Gamification.rankForLevel(5), Rank.gold);
      expect(Gamification.rankForLevel(7), Rank.platinum);
      expect(Gamification.rankForLevel(9), Rank.diamond);
      expect(Gamification.rankForLevel(20), Rank.diamond);
    });
  });

  group('StreakEngine (§5.1, hard reset)', () {
    test('first contribution → 1', () {
      expect(StreakEngine.nextStreak(null, '2026-08-30', 0), 1);
    });

    test('same day → unchanged', () {
      expect(StreakEngine.nextStreak('2026-08-30', '2026-08-30', 7), 7);
    });

    test('consecutive day → +1', () {
      expect(StreakEngine.nextStreak('2026-08-29', '2026-08-30', 7), 8);
    });

    test('gap of 2+ days → hard reset to 1 (no freeze)', () {
      expect(StreakEngine.nextStreak('2026-08-27', '2026-08-30', 7), 1);
      expect(StreakEngine.nextStreak('2026-08-01', '2026-08-30', 30), 1);
    });

    test('streak at risk when last contribution was yesterday', () {
      expect(StreakEngine.isAtRisk('2026-08-29', '2026-08-30'), true);
      expect(StreakEngine.isAtRisk('2026-08-30', '2026-08-30'), false);
      expect(StreakEngine.isAtRisk(null, '2026-08-30'), false);
    });
  });

  group('Achievements (§5.3 — enumerated list = 39)', () {
    // The §5.3 header says «40 ачівок» but enumerates exactly 39 ids
    // (10F + 7S + 5P + 5G + 5O + 3L + 4X = 39) — the enumerated list is
    // authoritative; the header number is a doc slip (documented in report).
    test('exactly the 39 enumerated achievements defined', () {
      expect(Achievements.all.length, 39);
    });

    test('bonus XP sums match §5.3', () {
      expect(Achievements.byId('F1')!.bonusXp, 20);
      expect(Achievements.byId('F7')!.bonusXp, 150);
      expect(Achievements.byId('S6')!.bonusXp, 500);
      expect(Achievements.byId('X4')!.bonusXp, 250);
    });

    test('F1 unlocks on first contribution', () {
      final s = UserStats(contributionsCount: 1);
      expect(Achievements.newlyUnlocked(s, {}), contains('F1'));
    });

    test('F2 unlocks at 1000 ₴ saved', () {
      expect(Achievements.newlyUnlocked(UserStats(totalSaved: 999), {}), isNot(contains('F2')));
      expect(Achievements.newlyUnlocked(UserStats(totalSaved: 1000), {}), contains('F2'));
    });

    test('F9/F10 single-contribution thresholds', () {
      expect(
        Achievements.newlyUnlocked(UserStats(maxSingleContribution: 5000), {}),
        contains('F9'),
      );
      expect(
        Achievements.newlyUnlocked(UserStats(maxSingleContribution: 4999), {}),
        isNot(contains('F9')),
      );
    });

    test('S2 weekly marathon at streak 7', () {
      expect(Achievements.newlyUnlocked(UserStats(streakDays: 7), {}), contains('S2'));
      expect(Achievements.newlyUnlocked(UserStats(streakDays: 6), {}), isNot(contains('S2')));
    });

    test('already-unlocked never re-appear', () {
      final s = UserStats(contributionsCount: 1);
      expect(Achievements.newlyUnlocked(s, {'F1'}), isNot(contains('F1')));
    });

    test('secret achievements marked', () {
      expect(Achievements.byId('X1')!.secret, true);
      expect(Achievements.byId('F1')!.secret, false);
    });

    test('night owl 00:00-04:59 / early bird 05:00-06:59 (Kyiv hours)', () {
      expect(isNightOwl(DateTime(2026, 8, 30, 3)), true);
      expect(isNightOwl(DateTime(2026, 8, 30, 5)), false);
      expect(isEarlyBird(DateTime(2026, 8, 30, 6)), true);
      expect(isEarlyBird(DateTime(2026, 8, 30, 7)), false);
    });

    test('O2 explorer requires all trackable screens', () {
      final s = UserStats(visitedScreens: Achievements.trackableScreens.toSet());
      expect(Achievements.newlyUnlocked(s, {}), contains('O2'));
      final partial = UserStats(visitedScreens: {'dashboard'});
      expect(Achievements.newlyUnlocked(partial, {}), isNot(contains('O2')));
    });

    test('X3 thousand-power at 1000 XP', () {
      expect(Achievements.newlyUnlocked(UserStats(totalXp: 1000), {}), contains('X3'));
    });
  });
}
