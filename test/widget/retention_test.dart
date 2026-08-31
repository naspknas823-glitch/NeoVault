import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_harness.dart';

/// 6.25 Pet + 6.26 Quests/DailyDrop + 6.30 Events.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('6.25 Pet: egg empty state + CTA (§6.25)', (tester) async {
    await pumpScreen(tester, '/pet');
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Vault Pet'), findsOneWidget);
    // §6.25 empty (яйце): themed state + CTA.
    expect(find.text('Твій пет вилупиться після першого поповнення'),
        findsOneWidget);
    expect(find.text('Додати гроші'), findsOneWidget);
  });

  testWidgets('6.26 Quests: 3 daily + weekly chain + reset timer',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpScreen(tester, '/quests');
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Квести'), findsWidgets);
    expect(find.textContaining('Reset через'), findsOneWidget);
    expect(find.text('Щоденні'), findsOneWidget);
    expect(find.text('Тижневі'), findsOneWidget);
    expect(find.text('Daily Drop'), findsOneWidget);
    expect(find.textContaining('Серія дропів'), findsOneWidget);
  });

  testWidgets('6.26 Daily Drop opens once (1/добу ⛔), reward dialog',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpScreen(tester, '/quests');
    await tester.pump(const Duration(milliseconds: 700));
    await tester.tap(find.text('Відкрити скриньку'), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Скриньку відкрито!'), findsOneWidget);
  });

  testWidgets('6.30 Events: no active event empty state', (tester) async {
    await pumpScreen(tester, '/event');
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Зараз немає активних подій'), findsOneWidget);
  });
}
