import 'package:flutter/material.dart';
import '../../core/utils/format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/security/pin_gate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_controller.dart';
import '../../data/repositories/system_repositories.dart';
import '../../data/repositories/tavily_repository.dart';
import '../../shared/widgets/widgets.dart';

/// 6.1 Splash (§6.1): brand moment + parallel init + routing decision.
/// new user → Onboarding; user → Dashboard (PIN gate handled by guard);
/// stale version → Force Update; 503 → Maintenance (with «Використовувати
/// офлайн»).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    // Parallel init window (§6.1): 1.5–2s brand moment; theme preload.
    // Hardened: a failing config read must never leave the user stuck on
    // the splash — degrade to the safe default route and surface the rest
    // through per-screen error states (§6 handling of 4 states).
    try {
      await ref.read(themeControllerProvider.notifier).load();
    } catch (e, st) {
      debugPrint('NV splash: theme load failed: $e\n$st');
    }
    // One-shot Tavily key hydration (Keystore → memory; see TavilyKeyRepository).
    try {
      await ref.read(tavilyKeyRepositoryProvider).hydrate();
    } catch (e, st) {
      debugPrint('NV splash: tavily hydrate failed: $e\n$st');
    }
    await Future<void>.delayed(const Duration(milliseconds: 1700));
    if (!mounted) return;

    // Version gate (§6.18) and maintenance flag (§6.19) from app_config.
    final config = ref.read(appConfigRepositoryProvider);
    var forceUpdate = false;
    var maintenance = false;
    var setupWizardCompleted = false;
    var onboarded = false;
    try {
      forceUpdate = await config.needsForceUpdate('0.9.0');
    } catch (e, st) {
      debugPrint('NV splash: force-update check failed: $e\n$st');
    }
    if (forceUpdate) {
      if (mounted) context.go('/force-update');
      return;
    }
    try {
      maintenance = await config.maintenanceFlag();
    } catch (e, st) {
      debugPrint('NV splash: maintenance check failed: $e\n$st');
    }
    if (maintenance) {
      if (mounted) context.go('/maintenance');
      return;
    }

    try {
      final settings = ref.read(settingsRepositoryProvider);
      setupWizardCompleted = await settings.setupWizardCompleted();
      onboarded = await settings.onboarded();
    } catch (e, st) {
      debugPrint('NV splash: onboarding flags read failed: $e\n$st');
    }

    // PIN gate (§6.22, HOTFIX v0.9.0+9.2): a configured PIN now actually
    // locks the app on cold start — router redirect sends every route to
    // /pin-lock until the user verifies (PIN or biometrics).
    try {
      if (await ref.read(pinRepositoryProvider).hasPin()) {
        ref.read(pinGateProvider.notifier).state = true;
      }
    } catch (e, st) {
      debugPrint('NV splash: pin gate check failed: $e\n$st');
    }

    if (!mounted) return;
    if (!setupWizardCompleted) {
      context.go('/setup-wizard');
    } else {
      context.go(onboarded ? '/dashboard' : '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return Scaffold(
      backgroundColor: c.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            final pulse = 0.94 + _ctrl.value * 0.06; // calm breathing
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: pulse,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: c.accent, width: 1.5),
                    ),
                    child: Icon(Icons.lock_outline_rounded,
                        size: 44, color: c.accent),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  t('common.app_name'),
                  style: NvType.h1(c), // ivory brand name, gold reserved for mark
                ),
                const SizedBox(height: 8),
                Text(t('common.tagline'), style: NvType.bodySecondary(c)),
                const SizedBox(height: 32),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: c.accent,
                  ),
                ),
                const SizedBox(height: 12),
                Text(t('splash.init'), style: NvType.caption(c)),
              ],
            );
          },
        ),
      ),
    );
  }
}
