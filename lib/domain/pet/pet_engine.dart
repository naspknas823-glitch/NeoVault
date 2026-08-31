/// Vault Pet engine (§10.1, criterion 12.14).
/// ⛔ Pet NEVER dies and NEVER loses progress (§9.13).
enum PetForm { egg, hatchling, baby, adult, legendary }

enum PetMood { happy, calm, sleepy, sleeping }

class PetState {
  const PetState({
    required this.form,
    required this.mood,
    required this.skin,
    required this.hatchedAt,
    required this.daysTogether,
    required this.feedCount,
    required this.contributionsNearby,
    required this.lastActivityDay,
  });

  final PetForm form;
  final PetMood mood;
  final String skin;
  final DateTime? hatchedAt;
  final int daysTogether;
  final int feedCount;
  final int contributionsNearby;
  final String? lastActivityDay;
}

/// Evolution conditions (§10.1):
/// Egg → Hatchling: first contribution.
/// Hatchling → Baby: 5 contributions OR streak 7.
/// Baby → Adult: level L3 AND streak 14.
/// Adult → Legendary: level L5 AND (streak 30 OR goal ≥ 50%).
PetForm evolveForm({
  required PetForm current,
  required int contributionsCount,
  required int streakDays,
  required int level,
  required double goalPercent,
}) {
  switch (current) {
    case PetForm.egg:
      if (contributionsCount >= 1) return PetForm.hatchling;
      return PetForm.egg;
    case PetForm.hatchling:
      if (contributionsCount >= 5 || streakDays >= 7) return PetForm.baby;
      return PetForm.hatchling;
    case PetForm.baby:
      if (level >= 3 && streakDays >= 14) return PetForm.adult;
      return PetForm.baby;
    case PetForm.adult:
      if (level >= 5 && (streakDays >= 30 || goalPercent >= 50)) {
        return PetForm.legendary;
      }
      return PetForm.adult;
    case PetForm.legendary:
      return PetForm.legendary;
  }
}

/// Mood rules (§10.1): Sleepy after 3+ days without opening the app,
/// Sleeping after 7+ days. Never worse than Sleeping (pet never dies).
PetMood moodFor(int daysSinceLastOpen) {
  if (daysSinceLastOpen >= 7) return PetMood.sleeping;
  if (daysSinceLastOpen >= 3) return PetMood.sleepy;
  return PetMood.happy;
}

/// Feeding costs 10 Chips (§10.0) and boosts mood; no XP/ savings effect.
const int petFeedCostChips = 10;

/// «Pet is sad» push: at most 1 per 72h, toggleable (⛔ §9.13).
const Duration petSadPushInterval = Duration(hours: 72);

/// Pet skins (§10.1): Neon Cyan default; others from chests/events.
class PetSkin {
  const PetSkin(this.id, this.nameL10nKey, {this.unlockChips = 0});
  final String id;
  final String nameL10nKey;
  final int unlockChips;
}

const List<PetSkin> petSkins = [
  PetSkin('neon_cyan', 'pet.skin_default'),
  PetSkin('neon_magenta', 'pet.skin_magenta'),
  PetSkin('gold_rush', 'pet.skin_gold'),
];
