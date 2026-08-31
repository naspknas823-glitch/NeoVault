import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_harness.dart';

/// 6.11 Settings + 6.12 Themes + 6.13 Premium + 6.15 Referral (stub per ТЗ)
/// + 6.17 Export + 6.18 Force Update + 6.19 Maintenance.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('6.11 Settings: profile, sections, reduce-motion toggle',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpScreen(tester, '/settings');
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Профіль'), findsWidgets);
    expect(find.text('ЗОВНІШНІЙ ВИГЛЯД'), findsOneWidget);
    expect(find.text('Reduce Motion & Flash Effects'), findsOneWidget);
    expect(find.text('🔐 API'), findsOneWidget);
    // (30) Vacation tile + (27) Quick Phrases count as new settings tiles —
    // scroll the Account section into view to assert the referral tile.
    await tester.dragUntilVisible(
      find.text('Запросити друзів'),
      find.byType(ListView).first,
      const Offset(0, -300),
    );
    await tester.pump();
    expect(find.text('Запросити друзів'), findsOneWidget);
  });

  testWidgets('6.12 Theme Gallery: presets + XP-locked + AI badge',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpScreen(tester, '/themes');
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Theme Gallery'), findsOneWidget);
    expect(find.text('Graphite & Gold'), findsOneWidget);
    expect(find.text('Light Mode'), findsOneWidget);
    expect(find.text('Ocean Blue'), findsOneWidget);
    expect(find.text('AI-тема'), findsOneWidget);
    expect(find.text('Незабаром'), findsOneWidget);
  });

  testWidgets('6.13 Premium: benefits + disabled CTA', (tester) async {
    await pumpScreen(tester, '/premium');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('NeoVault Premium'), findsWidgets);
    expect(find.text('Незабаром'), findsOneWidget);
    expect(find.text('PIN/біометрія, офлайн і ціни — завжди безкоштовні.'),
        findsOneWidget);
  });

  testWidgets('6.15 Referral — єдина заглушка за ТЗ: «Незабаром»',
      (tester) async {
    await pumpScreen(tester, '/referral');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Реферальна програма незабаром'), findsOneWidget);
    expect(find.text('Повідомити мене'), findsOneWidget);
    await tester.tap(find.text('Повідомити мене'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Готово! Ми повідомимо тебе'), findsOneWidget);
  });

  testWidgets('6.17 Export: empty state without data', (tester) async {
    await pumpScreen(tester, '/export');
    await tester.pump(const Duration(milliseconds: 900));
    expect(find.text('Немає даних для експорту'), findsOneWidget);
  });

  testWidgets('6.18 Force Update blocks navigation', (tester) async {
    await pumpScreen(tester, '/force-update');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Потрібне оновлення'), findsOneWidget);
    expect(find.text('Оновити'), findsOneWidget);
  });

  testWidgets('6.19 Maintenance offers offline mode', (tester) async {
    await pumpScreen(tester, '/maintenance');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Технічні роботи'), findsOneWidget);
    expect(find.text('Використовувати офлайн'), findsOneWidget);
  });
}
