import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/data/repositories/goal_repository.dart';

import '../helpers/test_harness.dart';

/// 6.2 Onboarding (§6.2): 5 steps, validation, first contribution.
/// NOTE: navigation-performing tests go LAST in the file (router global
/// pointer routes poison later taps otherwise).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('6.2 renders welcome + progress dots', (tester) async {
    await pumpScreen(tester, '/onboarding', onboarded: false);
    expect(find.text('Ласкаво просимо до NeoVault'), findsOneWidget);
    expect(find.text('Почати'), findsOneWidget);
    // Steps 2–5 reachable render checks (no nav out of the app).
    await tester.tap(find.text('Почати'));
    await tester.pump();
    expect(find.text('Скільки коштує PS5?'), findsOneWidget);
    expect(find.text('Середня ~₴18 000'), findsOneWidget);
    await tester.tap(find.text('Продовжити'));
    await tester.pump();
    expect(find.text('Скільки коштує монітор?'), findsOneWidget);
    await tester.tap(find.text('Продовжити'));
    await tester.pump();
    expect(find.text('Назви свою ціль'), findsOneWidget);
    await tester.tap(find.text('Продовжити'));
    await tester.pump();
    expect(find.text('Перше поповнення'), findsOneWidget);
    // Quick amount chips present.
    expect(find.text('500 ₴'), findsOneWidget);
    expect(find.text('5000 ₴'), findsOneWidget);
  });

  testWidgets('6.2 empty price shows validation error', (tester) async {
    await pumpScreen(tester, '/onboarding', onboarded: false);
    await tester.tap(find.text('Почати'));
    await tester.pump();
    await tester.enterText(find.byType(TextField).first, '');
    await tester.tap(find.text('Продовжити'));
    await tester.pump();
    expect(find.text('Введи коректну суму більше 0'), findsOneWidget);
  });

  testWidgets('6.2 first contribution creates goal + routes to dashboard',
      (tester) async {
    final container =
        await pumpScreen(tester, '/onboarding', onboarded: false);
    await tester.tap(find.text('Почати'));
    await tester.pump();
    await tester.tap(find.text('Продовжити'));
    await tester.pump();
    await tester.tap(find.text('Продовжити'));
    await tester.pump();
    await tester.tap(find.text('Продовжити'));
    await tester.pump();
    await tester.tap(find.text('1000 ₴'));
    await tester.pump();
    await tester.tap(find.text('Внести'));
    // Async chain: insert → stats → XP → achievements → route (fake-async
    // needs generous pump to flush every microtask turn).
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump(const Duration(milliseconds: 1500));
    // Single confirmation (§6.4): lands on Dashboard immediately.
    expect(find.text('Додати гроші'), findsWidgets);
    final goal = await container.read(goalRepositoryProvider).getGoal();
    expect(goal, isNotNull);
    expect(goal!.saved, 1000);
  });
}
