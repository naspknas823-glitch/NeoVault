import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_harness.dart';

/// 6.3 Dashboard + 6.4 Add Money sheet (§6.3/§6.4).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('6.3 Dashboard glanceable hierarchy renders', (tester) async {
    final container = await pumpScreen(tester, '/dashboard');
    await seedGoal(container);
    await tester.pump(const Duration(milliseconds: 600));
    // Header + big amount + sub-cards + buy status + ETA + live strip.
    expect(find.text('Накопичено'), findsOneWidget);
    expect(find.text('Гість'), findsOneWidget);
    // ONLINE-ONLY (v0.9.2): without a Tavily key the scanner has no prices —
    // the buy status honestly says «watching», no good-deal from seeds.
    expect(find.text('Стежимо за цінами'), findsOneWidget);
    expect(find.text('Консервативний прогноз'), findsOneWidget);
    expect(find.text('Оптимістичний прогноз'), findsOneWidget);
    expect(find.text('6 000,00 ₴'), findsOneWidget); // animated counter
    // Bottom nav 4 tabs (§8.1).
    expect(find.text('Головна'), findsOneWidget);
    expect(find.text('Price Scanner'), findsOneWidget);
    expect(find.text('Досягнення'), findsOneWidget);
    expect(find.text('Профіль'), findsOneWidget);
    // FAB.
    expect(find.text('Додати гроші'), findsOneWidget);
  });

  testWidgets('6.3 empty dashboard shows themed empty state', (tester) async {
    await pumpScreen(tester, '/dashboard');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Ціль не налаштована'), findsOneWidget);
  });

  testWidgets('6.4 Add Money: quick sum, single confirmation, XP toast',
      (tester) async {
    final container = await pumpScreen(tester, '/dashboard');
    await seedGoal(container);
    await tester.pump(const Duration(milliseconds: 600));
    // Open the sheet via FAB.
    await tester.tap(find.text('Додати гроші'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 300));
    // Sheet confirm button (single confirmation ⛔ §6.4).
    expect(find.text('Внести'), findsOneWidget);
    // Quick sums chips.
    expect(find.text('500 ₴'), findsOneWidget);
    // Enter 500 via chip and confirm.
    await tester.tap(find.text('500 ₴'));
    await tester.pump();
    await tester.tap(find.text('Внести'));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 300));
    // Success: XP toast (500 ₴ → 10 XP + streak bonus, §5.1) + Done button.
    expect(find.text('Поповнення додано'), findsOneWidget);
    expect(find.textContaining(RegExp(r'\+\d+ XP')), findsWidgets);
    await tester.tap(find.text('Готово'));
    await tester.pump(const Duration(milliseconds: 500));
    // Balance updated: 6000 + 500 = 6500.
    expect(find.text('6 500,00 ₴'), findsOneWidget);
  });

  testWidgets('6.3b Dashboard additions: XP bar, target+milestone, last deposit',
      (tester) async {
    final container = await pumpScreen(tester, '/dashboard');
    await seedGoal(container);
    await tester.pump(const Duration(milliseconds: 600));
    // Second frame: the latest-deposit card subscribes to the history stream
    // only after the goal (and the card itself) first appears, so its first
    // emission lands one frame later.
    await tester.pump(const Duration(milliseconds: 600));
    // Target line on the big amount card (18 000 PS5 + 8 000 monitor).
    expect(find.textContaining('Ціль:'), findsOneWidget);
    // Next 25% milestone: 6 000 / 26 000 = 23.1% → «До 25% — ще 500 ₴».
    expect(find.text('До 25% — ще 500 ₴'), findsOneWidget);
    // Latest deposit block: 3 seeded contributions, newest is 3 000 ₴.
    expect(find.text('Останнє поповнення'), findsOneWidget);
    expect(find.textContaining('+3 000'), findsOneWidget);
    // Header XP progress: caption «до N LVL» where N = level + 1 (the exact
    // level depends on seeded XP incl. streak bonuses — covered by XP tests).
    expect(find.textContaining(RegExp(r'до \d+ LVL')), findsOneWidget);
  });
}
