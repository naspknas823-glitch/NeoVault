import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_harness.dart';

/// 6.9 Achievements + segments 6.29 Collection / 6.27 Leaders (§10.9).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('6.9 Achievements grid renders with progress + filters',
      (tester) async {
    await pumpScreen(tester, '/achievements');
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Досягнення'), findsWidgets);
    expect(find.text('0 / 39'), findsOneWidget);
    expect(find.text('Всі категорії'), findsOneWidget);
    expect(find.text('Фінансові'), findsOneWidget);
  });

  testWidgets('6.29 Collection segment: sets + pack cost', (tester) async {
    await pumpScreen(tester, '/achievements');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text('Колекція'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Гроші'), findsOneWidget);
    expect(find.textContaining('80 Chips'), findsOneWidget);
  });

  testWidgets('6.27 Leaders segment: opt-in gate first', (tester) async {
    await pumpScreen(tester, '/achievements');
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text('Лідери'));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 500));
    // Opt-in dialog appears on first entry (§10.4).
    expect(find.text('Приєднатись до лідерборду?'), findsOneWidget);
    // Accept → race track with 2 ghosts + own row (no money amounts ⛔).
    await tester.tap(find.text('Приєднатись').last);
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text('Тижневі перегони'), findsOneWidget);
  });
}
