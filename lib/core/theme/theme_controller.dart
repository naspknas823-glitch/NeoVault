import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/system_repositories.dart';
import 'app_theme.dart';

/// Theme Gallery controller (§6.12): 5 presets, 2 XP-locked (500/1200 XP).
class ThemeController extends StateNotifier<NvThemeData> {
  ThemeController(this._ref) : super(NvThemeData.cyberpunkNeon);

  final Ref _ref;

  static const Map<NvThemeId, int> unlockXp = {
    NvThemeId.oceanBlue: kOceanBlueUnlockXp,
    NvThemeId.sunsetPurple: kSunsetPurpleUnlockXp,
    NvThemeId.mintFresh: kMintFreshUnlockXp,
  };

  Future<void> load() async {
    final id = await _ref.read(settingsRepositoryProvider).themeId();
    state = NvThemeData.all.firstWhere(
      (t) => t.id == NvThemeId.fromId(id ?? ''),
      orElse: () => NvThemeData.cyberpunkNeon,
    );
  }

  bool isLocked(NvThemeId id, int totalXp) {
    final need = unlockXp[id];
    return need != null && totalXp < need;
  }

  /// Apply immediately (§6.12 tap-to-apply). Counts toward O3 «Тематик».
  Future<bool> apply(NvThemeId id, {required int totalXp}) async {
    if (isLocked(id, totalXp)) return false;
    final target = NvThemeData.all.firstWhere((t) => t.id == id);
    if (target != state) {
      state = target;
      await _ref.read(settingsRepositoryProvider).setThemeId(id.id);
      await _ref.read(goalRepositoryProvider).trackThemeChange();
    }
    return true;
  }
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, NvThemeData>(
        (ref) => ThemeController(ref));
