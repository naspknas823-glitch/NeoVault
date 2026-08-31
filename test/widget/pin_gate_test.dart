import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/core/router/app_router.dart';
import 'package:neovault/core/security/pin_gate.dart';
import 'package:neovault/features/dashboard/dashboard_screen.dart';
import 'package:neovault/features/settings/settings_screen.dart';

import '../helpers/test_harness.dart';

/// §6.22 PIN gate — HOTFIX v0.9.0+9.2: a configured PIN now actually locks
/// the app (previously `/pin-lock` was an orphan route nothing ever
/// navigated to, so «PIN не працює»). Router redirect must:
///   • send every route to /pin-lock while the gate is locked;
///   • release /pin-lock back to /dashboard after unlock;
///   • stay inert for regular navigation when unlocked.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('locked gate redirects /dashboard → /pin-lock, unlock releases',
      (tester) async {
    var locked = true;
    final router = buildRouter(
      initialLocation: '/dashboard',
      isLocked: () => locked,
    );
    final container =
        await pumpHarness(tester, const SizedBox.shrink(), router: router);
    await tester.pump(const Duration(milliseconds: 300));

    // Locked: dashboard is replaced by the PIN lock screen.
    expect(find.text('Введи PIN'), findsOneWidget);
    expect(find.byType(DashboardScreen), findsNothing);

    // The PinLockScreen unlock path: clear the gate, then notify the router
    // (in the app the gate listener drives refresh via refreshListenable).
    locked = false;
    container.read(pinGateProvider.notifier).state = false;
    router.refresh();
    // Route transition needs a few frames to fully retire /pin-lock; the
    // exact frame count depends on the platform page transition (Flutter
    // 3.44 changed the Android default), so settle all animations instead
    // of hardcoding pump counts.
    await tester.pumpAndSettle();

    expect(find.text('Введи PIN'), findsNothing);
    expect(find.byType(DashboardScreen), findsOneWidget);
  });

  testWidgets('unlocked gate keeps regular navigation untouched',
      (tester) async {
    final router = buildRouter(
      initialLocation: '/settings',
      isLocked: () => false,
    );
    await pumpHarness(tester, const SizedBox.shrink(), router: router);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  testWidgets('gate provider defaults to unlocked', (tester) async {
    // /dashboard (not the splash '/') so no 1700ms brand timer stays pending.
    final container = await pumpHarness(
      tester,
      const SizedBox.shrink(),
      initialLocation: '/dashboard',
      router: buildRouter(initialLocation: '/dashboard'),
    );
    expect(container.read(pinGateProvider), isFalse);
  });
}
