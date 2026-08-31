import 'dart:math';

/// Daily Drop engine (§10.3, criteria 12.13).
/// ⛔ Strictly 1/day, free forever; odds public (long-press → Odds screen);
/// drop chain is a SEPARATE counter, never confused with contribution streak.
class DailyDropEngine {
  /// Whether the chest is available for [todayKey].
  static bool isAvailable(String? lastOpenedDayKey, String todayKey) =>
      lastOpenedDayKey != todayKey;

  /// New chain length after opening on [todayKey].
  /// Consecutive day → +1; missed day → reset to 1.
  static int nextChain(String? lastOpenedDayKey, String todayKey, int currentChain) {
    if (lastOpenedDayKey == null) return 1;
    if (lastOpenedDayKey == todayKey) return currentChain;
    final last = DateTime.tryParse(lastOpenedDayKey);
    final today = DateTime.tryParse(todayKey);
    if (last == null || today == null) return 1;
    if (today.difference(last).inDays == 1) return currentChain + 1;
    return 1;
  }

  /// Day 7 of the chain → big chest (guaranteed Rare+ card).
  static bool isBigChestDay(int chainDay) => chainDay % 7 == 0;

  /// Public odds table (normal chest) — shown in the Odds screen (§10.3).
  static const List<ChestOdds> normalOdds = [
    ChestOdds(labelKey: 'chest.odds_chip5', chance: 0.35),
    ChestOdds(labelKey: 'chest.odds_chip15', chance: 0.28),
    ChestOdds(labelKey: 'chest.odds_chip30', chance: 0.18),
    ChestOdds(labelKey: 'chest.odds_chip50', chance: 0.08),
    ChestOdds(labelKey: 'chest.odds_pack', chance: 0.08),
    ChestOdds(labelKey: 'chest.odds_feed', chance: 0.02),
    ChestOdds(labelKey: 'chest.odds_rare', chance: 0.01),
  ];

  static const List<ChestOdds> bigOdds = [
    ChestOdds(labelKey: 'chest.odds_big_1', chance: 0.70),
    ChestOdds(labelKey: 'chest.odds_big_2', chance: 0.30),
  ];

  /// Roll a reward from the [odds] table using [rng] (injectable for tests).
  static ChestOdds roll(List<ChestOdds> odds, Random rng) {
    final r = rng.nextDouble();
    var acc = 0.0;
    for (final o in odds) {
      acc += o.chance;
      if (r < acc) return o;
    }
    return odds.first;
  }

  /// Big chest chips range 75–150 (§10.0).
  static int bigChestChips(Random rng) => 75 + rng.nextInt(76);
}

class ChestOdds {
  const ChestOdds({required this.labelKey, required this.chance});
  final String labelKey;
  final double chance;
}

/// Reward kinds produced by opening a chest.
enum ChestRewardKind { chips, petFeed, pack, rareCard }

class ChestReward {
  const ChestReward({required this.kind, this.chips = 0, this.odds});
  final ChestRewardKind kind;
  final int chips;
  final ChestOdds? odds;
}

/// Resolve an odds entry to a concrete reward.
ChestReward resolveOdds(ChestOdds o, Random rng, {bool bigChest = false}) {
  switch (o.labelKey) {
    case 'chest.odds_chip5':
      return const ChestReward(kind: ChestRewardKind.chips, chips: 5);
    case 'chest.odds_chip15':
      return const ChestReward(kind: ChestRewardKind.chips, chips: 15);
    case 'chest.odds_chip30':
      return const ChestReward(kind: ChestRewardKind.chips, chips: 30);
    case 'chest.odds_chip50':
      return const ChestReward(kind: ChestRewardKind.chips, chips: 50);
    case 'chest.odds_pack':
      return const ChestReward(kind: ChestRewardKind.pack);
    case 'chest.odds_feed':
      return const ChestReward(kind: ChestRewardKind.petFeed);
    case 'chest.odds_rare':
      return const ChestReward(kind: ChestRewardKind.rareCard);
    case 'chest.odds_big_1':
      return ChestReward(kind: ChestRewardKind.chips, chips: DailyDropEngine.bigChestChips(rng));
    case 'chest.odds_big_2':
      return const ChestReward(kind: ChestRewardKind.rareCard);
    default:
      return const ChestReward(kind: ChestRewardKind.chips, chips: 5);
  }
}
