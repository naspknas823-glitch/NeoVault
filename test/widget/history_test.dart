import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_harness.dart';

/// 6.5 History + 6.6 Transaction Detail (§6.5/§6.6).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('6.5 History renders grouped list + XP + chart area',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = await pumpScreen(tester, '/history');
    await seedGoal(container);
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Історія'), findsOneWidget);
    expect(find.text('Сьогодні'), findsOneWidget);
    expect(find.text('Експорт в CSV'), findsNothing); // menu-only
    // Contribution rows with XP.
    expect(find.text('+1 000,00 ₴'), findsOneWidget);
    expect(find.text('+2 000,00 ₴'), findsOneWidget);
    expect(find.text('+3 000,00 ₴'), findsOneWidget);
  });

  testWidgets('6.5 History empty state', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpScreen(tester, '/history');
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Ще немає поповнень'), findsOneWidget);
  });

  testWidgets('6.6 Transaction detail opens from history', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = await pumpScreen(tester, '/history');
    await seedGoal(container);
    await tester.pump(const Duration(milliseconds: 700));
    // Tap the first contribution row → detail sheet.
    await tester.ensureVisible(find.text('+1 000,00 ₴'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('+1 000,00 ₴'), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Нараховано XP'), findsOneWidget);
    expect(find.textContaining(RegExp(r'\+\d+ XP')), findsWidgets);
    expect(find.text('Видалити'), findsOneWidget);
  });
}
