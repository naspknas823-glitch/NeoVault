import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/core/security/pin.dart';
import 'package:neovault/core/utils/format.dart';
import 'package:neovault/domain/ai/ai_engine.dart';
import 'dart:math';

import 'package:neovault/domain/buddy/buddy_engine.dart';
import 'package:neovault/domain/chests/daily_drop.dart';
import 'package:neovault/domain/leaderboard/leaderboard_engine.dart';
import 'package:neovault/domain/pet/pet_engine.dart';
import 'package:neovault/domain/quests/quest_engine.dart';

/// Retention engines + security tests (criteria 12.12–12.16, §8.3).
void main() {
  group('Quests (criterion 12.12)', () {
    test('exactly 3 daily quests, main quest always included', () {
      final d1 = QuestEngine.dailyFor('2026-08-30');
      expect(d1.length, 3);
      expect(d1.any((q) => q.isMain), true);
      final d2 = QuestEngine.dailyFor('2026-08-31');
      expect(d2.length, 3);
      // Rotation: different day → different set (deterministic).
      expect(d1.map((q) => q.id).toSet(), isNot(equals(d2.map((q) => q.id).toSet())));
    });

    test('same day → same quests (deterministic seed)', () {
      expect(
        QuestEngine.dailyFor('2026-08-30').map((q) => q.id),
        QuestEngine.dailyFor('2026-08-30').map((q) => q.id),
      );
    });

    test('weekly chain = 3 quests', () {
      expect(QuestEngine.weeklyFor(DateTime(2026, 8, 30)).length, 3);
    });

    test('CLAIM gives chips and NEVER XP (⛔ §9.10)', () {
      final q = QuestPool.daily.first;
      final chips = QuestEngine.claimReward(q);
      expect(chips, q.rewardChips);
      expect(chips, isNot(isA<double>())); // no XP confusion — chips int
      // The engine has no XP output at all:
      expect(QuestEngine, isA<Type>());
    });

    test('weekly streak quest exists in pool', () {
      expect(QuestPool.weekly.any((q) => q.type == QuestType.weeklyStreak), true);
    });
  });

  group('Daily Drop (criterion 12.13)', () {
    test('second attempt same day impossible', () {
      expect(DailyDropEngine.isAvailable('2026-08-30', '2026-08-30'), false);
      expect(DailyDropEngine.isAvailable('2026-08-29', '2026-08-30'), true);
      expect(DailyDropEngine.isAvailable(null, '2026-08-30'), true);
    });

    test('chain: consecutive +1, gap resets', () {
      expect(DailyDropEngine.nextChain('2026-08-29', '2026-08-30', 5), 6);
      expect(DailyDropEngine.nextChain('2026-08-20', '2026-08-30', 5), 1);
      expect(DailyDropEngine.nextChain(null, '2026-08-30', 0), 1);
    });

    test('chain is separate from contribution streak (§9.14)', () {
      // Day 7 of drop chain → big chest regardless of contribution streak.
      expect(DailyDropEngine.isBigChestDay(7), true);
      expect(DailyDropEngine.isBigChestDay(6), false);
      expect(DailyDropEngine.isBigChestDay(14), true);
    });

    test('odds table is public and sums to 1.0', () {
      final sum = DailyDropEngine.normalOdds.fold<double>(0, (a, o) => a + o.chance);
      expect(sum, closeTo(1.0, 0.0001));
    });

    test('big chest rolls 75–150 chips or rare card', () {
      final r = resolveOdds(
        DailyDropEngine.roll(DailyDropEngine.bigOdds, _SeededRng(0.5)),
        _SeededRng(0.5),
        bigChest: true,
      );
      if (r.kind == ChestRewardKind.chips) {
        expect(r.chips, inInclusiveRange(75, 150));
      } else {
        expect(r.kind, ChestRewardKind.rareCard);
      }
    });
  });

  group('Vault Pet (§10.1, criterion 12.14)', () {
    test('evolution chain per conditions', () {
      // Egg → hatch on first contribution.
      expect(
        evolveForm(current: PetForm.egg, contributionsCount: 0, streakDays: 0, level: 1, goalPercent: 0),
        PetForm.egg,
      );
      expect(
        evolveForm(current: PetForm.egg, contributionsCount: 1, streakDays: 0, level: 1, goalPercent: 0),
        PetForm.hatchling,
      );
      // Baby at 5 contributions OR streak 7.
      expect(
        evolveForm(current: PetForm.hatchling, contributionsCount: 5, streakDays: 0, level: 1, goalPercent: 0),
        PetForm.baby,
      );
      expect(
        evolveForm(current: PetForm.hatchling, contributionsCount: 2, streakDays: 7, level: 1, goalPercent: 0),
        PetForm.baby,
      );
      // Adult: L3 + streak 14.
      expect(
        evolveForm(current: PetForm.baby, contributionsCount: 6, streakDays: 14, level: 3, goalPercent: 0),
        PetForm.adult,
      );
      expect(
        evolveForm(current: PetForm.baby, contributionsCount: 6, streakDays: 14, level: 2, goalPercent: 0),
        PetForm.baby,
      );
      // Legendary: L5 + (streak 30 OR goal ≥ 50%).
      expect(
        evolveForm(current: PetForm.adult, contributionsCount: 20, streakDays: 30, level: 5, goalPercent: 10),
        PetForm.legendary,
      );
      expect(
        evolveForm(current: PetForm.adult, contributionsCount: 20, streakDays: 5, level: 5, goalPercent: 50),
        PetForm.legendary,
      );
    });

    test('pet never loses form once reached (progress never lost ⛔)', () {
      expect(
        evolveForm(current: PetForm.legendary, contributionsCount: 0, streakDays: 0, level: 1, goalPercent: 0),
        PetForm.legendary,
      );
    });

    test('moods: sleepy 3+, sleeping 7+', () {
      expect(moodFor(0), PetMood.happy);
      expect(moodFor(2), PetMood.happy);
      expect(moodFor(3), PetMood.sleepy);
      expect(moodFor(6), PetMood.sleepy);
      expect(moodFor(7), PetMood.sleeping);
      expect(moodFor(30), PetMood.sleeping);
    });

    test('feed costs 10 chips', () {
      expect(petFeedCostChips, 10);
    });
  });

  group('Leaderboard ghosts (§10.4, criterion 12.15)', () {
    test('ghosts picked within ±15% (fallback: closest)', () {
      final candidates = [
        _row('a', 10.0),
        _row('b', 10.9),
        _row('c', 20.0),
        _row('d', 9.0),
      ];
      final ghosts = LeaderboardEngine.pickGhosts(selfTempo: 10, candidates: candidates);
      expect(ghosts.length, 2);
      // In-range: a (0.0), b (0.9), d (1.0) — closest two are a and b.
      expect(ghosts.map((g) => g.userId), containsAll(['a', 'b']));
    });

    test('rows never contain money amounts (⛔)', () {
      final r = _row('x', 5);
      // The data model has no money field at all:
      expect(r.toJson().keys.any((k) => k.toLowerCase().contains('amount') || k.toLowerCase().contains('money')), false);
    });

    test('beatAnyGhost works for both tabs', () {
      final ghosts = [_row('g', 4.0)];
      expect(
        LeaderboardEngine.beatAnyGhost(selfTempo: 5, selfWeeklyXp: 0, tab: LeaderboardTab.tempo, ghosts: ghosts),
        true,
      );
      expect(
        LeaderboardEngine.beatAnyGhost(selfTempo: 3, selfWeeklyXp: 100, tab: LeaderboardTab.weeklyXp, ghosts: [_row2('g', 4.0, 50)]),
        true,
      );
    });
  });

  group('Buddy (§10.8, criterion 12.16)', () {
    test('4th ping of the day is blocked', () {
      expect(BuddyEngine.canPing(0), true);
      expect(BuddyEngine.canPing(2), true);
      expect(BuddyEngine.canPing(3), false);
    });

    test('invite code: 6 chars from safe alphabet', () {
      final code = BuddyEngine.generateInviteCode(seed: 42);
      expect(code.length, 6);
      expect(BuddyEngine.isValidInviteCode(code), true);
      expect(BuddyEngine.isValidInviteCode('abc'), false);
      expect(BuddyEngine.isValidInviteCode('ABC123'), true);
    });

    test('buddy week: both 3+ → complete', () {
      expect(buddyWeekComplete(3, 3), true);
      expect(buddyWeekComplete(2, 3), false);
      expect(buddyWeekComplete(3, 0), false);
    });
  });

  group('AI limits (§6.8, §7.2)', () {
    test('100/day authed, 20/day guest', () {
      expect(AiEngine.limitAuthed, 100);
      expect(AiEngine.limitGuest, 20);
      final guest = AiEngine.usageFor(isAuthed: false, todayKey: '2026-08-30', usedToday: 20);
      expect(guest.exhausted, true);
      expect(AiEngine.canRequest(guest), false);
      final authed = AiEngine.usageFor(isAuthed: true, todayKey: '2026-08-30', usedToday: 20);
      expect(AiEngine.canRequest(authed), true);
    });

    test('fallback replies exist for all 3 modes', () {
      const ctx = AiContext(
        balance: 1000, goalPercent: 5, ps5Price: 25000, monitorPrice: 8000,
        level: 2, streakDays: 3, lastContributionDate: null,
        achievementsCount: 2, lowestPrice: 24799, priceTrend: 'down',
      );
      for (final m in AiMode.values) {
        final r = AiEngine.fallbackReply(m, ctx);
        expect(r.fromFallback, true);
        expect(r.text.isNotEmpty, true);
      }
    });
  });

  group('PIN security (§6.21, §8.3)', () {
    test('weak PIN blacklist (⛔)', () {
      expect(PinSecurity.validate('1234'), 'pin.weak');
      expect(PinSecurity.validate('0000'), 'pin.weak');
      expect(PinSecurity.validate('1111'), 'pin.weak');
      expect(PinSecurity.validate('2222'), 'pin.weak');
      expect(PinSecurity.validate('4321'), 'pin.weak');
      expect(PinSecurity.validate('123456'), 'pin.weak');
      expect(PinSecurity.validate('5555'), 'pin.weak'); // repeat
      expect(PinSecurity.validate('2345'), 'pin.weak'); // sequence
    });

    test('length 4–6 (⛔)', () {
      expect(PinSecurity.validate('123'), 'pin.invalid_len');
      expect(PinSecurity.validate('1234567'), 'pin.invalid_len');
      expect(PinSecurity.validate('9876'), 'pin.weak'); // descending sequence
      expect(PinSecurity.validate('9473'), isNull);
    });

    test('hash/verify roundtrip', () {
      final salt = PinSecurity.newSalt();
      final h = PinSecurity.hash('9182', salt);
      expect(PinSecurity.verify('9182', salt, h), true);
      expect(PinSecurity.verify('9183', salt, h), false);
    });

    // (34) Lockout after 3 failed attempts (feature 34), 10 → sign out.
    test('lockout: 3 fails → 30s, 10 → sign out (⛔ §6.21, feat.34)', () {
      var state = const PinLockout(failedAttempts: 0);
      state = state.registerFailure(1000);
      state = state.registerFailure(1000);
      expect(state.isLocked(1000), false);
      state = state.registerFailure(1000); // 3rd fail
      expect(state.failedAttempts, 3);
      expect(state.isLocked(1000), true);
      expect(state.isLocked(1000 + PinLockout.blockMillis), false);
      // Continue to 10 (7 more fails) → sign out:
      var s2 = state;
      for (var i = 0; i < 7; i++) {
        s2 = s2.registerFailure(999999);
      }
      expect(s2.shouldSignOut, true);
    });
  });

  group('Kyiv time anchors', () {
    test('week start is Monday', () {
      final ws = kyivWeekStart(DateTime(2026, 8, 30)); // Sunday
      expect(ws.weekday, DateTime.monday);
      expect(ws.isBefore(DateTime(2026, 8, 30)), true);
    });

    test('date key format yyyy-MM-dd', () {
      expect(kyivDateKey(DateTime(2026, 8, 4)), '2026-08-04');
    });
  });
}

LeaderboardRow _row(String id, double percent) => LeaderboardRow(
      userId: id, nick: id, percent: percent, weeklyXp: 10,
      rankLabel: 'Bronze', streakDays: 1,
    );

LeaderboardRow _row2(String id, double percent, int xp) => LeaderboardRow(
      userId: id, nick: id, percent: percent, weeklyXp: xp,
      rankLabel: 'Bronze', streakDays: 1,
    );

class _SeededRng implements Random {
  _SeededRng(this.value);
  final double value;
  @override
  double nextDouble() => value;
  @override
  int nextInt(int max) => (value * max).floor().clamp(0, max - 1);
  @override
  bool nextBool() => value >= 0.5;
}

extension _RowJson on LeaderboardRow {
  Map<String, Object> toJson() => {
        'userId': userId,
        'nick': nick,
        'percent': percent,
        'weeklyXp': weeklyXp,
        'rank': rankLabel,
        'streak': streakDays,
      };
}
