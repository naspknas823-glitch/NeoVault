import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:neovault/core/db/app_database.dart';
import 'package:neovault/core/utils/format.dart' show stringsProvider;
import 'package:neovault/core/router/app_router.dart';
import 'package:neovault/data/cloud/cloud_gateway.dart';
import 'package:neovault/data/repositories/goal_repository.dart';
import 'package:neovault/data/repositories/providers.dart';
import 'package:neovault/data/repositories/ui_providers.dart';
import 'package:neovault/shared/widgets/widgets.dart' show reduceMotionProvider;

/// Shared widget-test harness: in-memory Drift + seeded bootstrap +
/// LocalOnlyGateway + test-safe countdown (no pending timers) +
/// reduce-motion ON (finite frames only, so pumps settle deterministically).
Future<ProviderContainer> pumpHarness(
  WidgetTester tester,
  Widget child, {
  String initialLocation = '/dashboard',
  List<Override> extra = const [],
  bool onboarded = true,
  bool? setupWizard,
  GoRouter? router,
  bool skipFirstPumps = false,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final db = openTestDatabase();
  await bootstrapDatabase(db, now: DateTime(2026, 8, 30, 12));
  // Onboarding gate flag (splash routing decision §6.1).
  await db.into(db.settings).insertOnConflictUpdate(SettingsCompanion.insert(
        key: 'onboarded',
        value: onboarded ? 'true' : 'false',
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ));
  await db.into(db.settings).insertOnConflictUpdate(SettingsCompanion.insert(
        key: 'setup_wizard',
        value: (setupWizard ?? onboarded) ? 'true' : 'false',
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      ));

  final container = ProviderContainer(overrides: [
    dbProvider.overrideWithValue(db),
    cloudGatewayProvider.overrideWithValue(LocalOnlyGateway()),
    countdownTickProvider.overrideWith((ref) => Stream.value(0)),
    reduceMotionProvider.overrideWith((ref) => true),
    ...extra,
  ]);
  addTearDown(container.dispose);

  // Deterministic l10n load BEFORE first frame: runAsync escapes the fake
  // async zone so the real asset read completes without pumps.
  await tester.runAsync(() => container.read(stringsProvider.future));

  final effectiveRouter = router ?? buildRouter(initialLocation: initialLocation);
  await tester.pumpWidget(
    TooltipVisibility(
      visible: false,
      child: UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: effectiveRouter),
      ),
    ),
  );
  if (skipFirstPumps) return container;
  // l10n load + first frames (finite animations settle within 3 pumps).
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 400));
  return container;
}

/// Pump a screen through the REAL router (deep-link style entry).
Future<ProviderContainer> pumpScreen(
  WidgetTester tester,
  String route, {
  List<Override> extra = const [],
  bool onboarded = true,
  bool? setupWizard,
}) =>
    pumpHarness(tester, const SizedBox.shrink(),
        initialLocation: route, extra: extra, onboarded: onboarded, setupWizard: setupWizard);

/// Seed a goal + contributions for dashboard/history scenarios.
Future<void> seedGoal(ProviderContainer container,
    {int contributions = 3}) async {
  final goals = container.read(goalRepositoryProvider);
  await goals.createGoal(
      title: 'Моя ігрова установка', ps5Price: 18000, monitorPrice: 8000);
  for (var i = 0; i < contributions; i++) {
    await goals.addContribution(amount: 1000 * (i + 1));
  }
}
