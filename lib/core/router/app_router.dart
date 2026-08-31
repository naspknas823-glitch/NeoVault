import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/achievements/achievements_screen.dart';
import '../../features/ai_chat/ai_chat_screen.dart';
import '../../features/api_settings/api_settings_screen.dart';
import '../../features/buddy/buddy_screen.dart';
import '../../features/bundle_search/bundle_search_screen.dart';
import '../../features/collection/collection_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/events/events_screen.dart';
import '../../features/expenses/expense_simulator_screen.dart';
import '../../features/tools/tools_screen.dart';
import '../../features/gamification/gamification_screen.dart';
import '../../features/gamification/savings_curve_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/onboarding/onboarding_screen.dart' show OnboardingScreen;
import '../../features/onboarding/setup_wizard_screen.dart';
import '../../features/preview/room_preview_screen.dart';
import '../../features/dashboard/add_money_sheet.dart' show showAddMoneySheet;
import '../../features/leaderboard/leaderboard_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/pet/pet_screen.dart';
import '../../features/pin/pin_screens.dart';
import '../../features/progress_card/progress_card_screen.dart';
import '../../features/quests/quests_screen.dart';
import '../../features/scanner/scanner_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/system_screens.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/themes/theme_gallery_screen.dart';

/// Navigation (§8.1): Bottom Navigation Bar 4 таби + FAB — Dashboard |
/// Scanner | Achievements | Profile; FAB «Додати гроші». History /
/// Notification Center — НЕ в таб-барі. Retention-в'їзди — сегменти/пункти.
/// Deep links (§3): vault://dashboard, vault://pet, vault://buddy/join?code=...
/// Navigator key is per-router-instance (test-safe).
///
/// PIN gate (§6.22, HOTFIX v0.9.0+9.2): when [isLocked] is wired, `true`
/// forces every route onto `/pin-lock`; unlocking lets `/pin-lock` fall back
/// to `/dashboard`. When null (widget tests) the guard is fully disabled so
/// screens remain deep-linkable one-by-one.
GoRouter buildRouter({
  String initialLocation = '/',
  Listenable? refreshListenable,
  bool Function()? isLocked,
}) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final locked = isLocked?.call();
      if (locked == null) return null; // gate not wired (tests).
      final onLock = state.matchedLocation.startsWith('/pin-lock');
      if (locked) return onLock ? null : '/pin-lock';
      return onLock ? '/dashboard' : null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash', // 6.1
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/setup-wizard',
        builder: (context, state) => const SetupWizardScreen(),
      ),
      GoRoute(
        path: '/onboarding', // 6.2
        builder: (context, state) => const OnboardingScreen(),
      ),
      // ── Shell tabs (4 таби + FAB, §8.1) ──
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: '/dashboard', // 6.3
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/scanner', // 6.7
            builder: (context, state) => const ScannerScreen(),
          ),
          GoRoute(
            path: '/achievements', // 6.9 (+ segments 6.27/6.29 §10.9)
            builder: (context, state) => const AchievementsScreen(),
          ),
          GoRoute(
            path: '/settings', // 6.11
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      // ── Secondary screens (не в таб-барі, §8.1) ──
      GoRoute(
        path: '/history', // 6.5
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/notifications', // 6.10
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/ai', // 6.8
        builder: (context, state) => const AiChatScreen(),
      ),
      GoRoute(
        path: '/themes', // 6.12
        builder: (context, state) => const ThemeGalleryScreen(),
      ),
      GoRoute(
        path: '/premium', // 6.13
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: '/referral', // 6.15 — заглушка за ТЗ (єдина)
        builder: (context, state) => const ReferralScreen(),
      ),
      GoRoute(
        path: '/export', // 6.17
        builder: (context, state) => const ExportScreen(),
      ),
      GoRoute(
        path: '/force-update', // 6.18
        builder: (context, state) => const ForceUpdateScreen(),
      ),
      GoRoute(
        path: '/maintenance', // 6.19
        builder: (context, state) => const MaintenanceScreen(),
      ),
      GoRoute(
        path: '/delete-account', // 6.20
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        path: '/pin-setup', // 6.21
        builder: (context, state) => const PinSetupScreen(),
      ),
      GoRoute(
        path: '/pin-lock', // 6.22
        builder: (context, state) => const PinLockScreen(),
      ),
      GoRoute(
        path: '/victory', // 6.24
        builder: (context, state) => const VictoryScreen(),
      ),
      GoRoute(
        path: '/pet', // 6.25
        builder: (context, state) => const PetScreen(),
      ),
      GoRoute(
        path: '/quests', // 6.26 (+ Daily Drop §10.3)
        builder: (context, state) => const QuestsScreen(),
      ),
      GoRoute(
        path: '/expense-simulator',
        builder: (context, state) => const ExpenseSimulatorScreen(),
      ),
      GoRoute(
        path: '/tools',
        builder: (context, state) => const ToolsScreen(),
      ),
      GoRoute(
        path: '/gamification',
        builder: (context, state) => const GamificationScreen(),
      ),
      GoRoute(
        path: '/room-preview', // (35) AR-analog room preview
        builder: (context, state) => const RoomPreviewScreen(),
      ),
      GoRoute(
        path: '/savings-curve',
        builder: (context, state) => const SavingsCurveScreen(),
      ),
      GoRoute(
        path: '/leaderboard', // 6.27
        builder: (context, state) => const LeaderboardScreen(),
      ),
      GoRoute(
        path: '/progress-card', // 6.28
        builder: (context, state) => const ProgressCardScreen(),
      ),
      GoRoute(
        path: '/collection', // 6.29
        builder: (context, state) => const CollectionScreen(),
      ),
      GoRoute(
        path: '/event', // 6.30
        builder: (context, state) => const EventScreen(),
      ),
      GoRoute(
        path: '/buddy', // 6.31
        builder: (context, state) => const BuddyScreen(),
      ),
      GoRoute(
        path: '/bundle-search', // 6.32
        builder: (context, state) => const BundleSearchScreen(),
      ),
      GoRoute(
        path: '/api-settings', // 6.33
        builder: (context, state) => const ApiSettingsScreen(),
      ),
      // ── Add money (deep-linkable modal, §3 vault://add-money) ──
      GoRoute(
        path: '/add-money', // 6.4 sheet — full-screen fallback
        builder: (context, state) => const _AddMoneyRouteScreen(),
      ),
    ],
  );
}

// Onboarding uses the real screen widget (6.2, §6.2).

/// Full-screen wrapper for the add-money sheet when deep-linked.
class _AddMoneyRouteScreen extends ConsumerWidget {
  const _AddMoneyRouteScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final outcome = await showAddMoneySheet(context, ref);
      if (context.mounted) context.pop();
      if (outcome != null && outcome.result.goalCompleted && context.mounted) {
        context.push('/victory');
      }
    });
    return const DashboardScreen();
  }
}

/// Deep link helper used from Android intent-filter handlers (§3).
void handleVaultDeepLink(BuildContext context, String uri) {
  final parsed = Uri.parse(uri);
  switch (parsed.host) {
    case 'buddy':
      if (parsed.path == '/join') {
        context.go('/buddy');
        final code = parsed.queryParameters['code'];
        if (code != null) {
          // Pre-fill handled by BuddyScreen via shared controller; toast for
          // visibility in beta.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('vault://buddy/join?code=$code')),
          );
        }
      }
      return;
    default:
      final target = '/${parsed.host}';
      context.go(target);
  }
}
