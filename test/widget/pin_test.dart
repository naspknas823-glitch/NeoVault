import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/data/repositories/system_repositories.dart';

import '../helpers/test_harness.dart';

/// 6.21 PIN Setup + 6.22 PIN Lock (§6.21/§6.22).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('6.21 PIN setup: weak PIN rejected with reason',
      (tester) async {
    await pumpScreen(tester, '/pin-setup');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Придумай PIN (4–6 цифр)'), findsOneWidget);
    for (final d in ['1', '2', '3', '4']) {
      await tester.tap(find.text(d));
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(find.text('Занадто простий PIN'), findsOneWidget);
  });

  testWidgets('6.21 PIN setup: valid PIN → confirm → biometrics step',
      (tester) async {
    await pumpScreen(tester, '/pin-setup');
    await tester.pump(const Duration(milliseconds: 300));
    for (final d in ['9', '4', '7', '3']) {
      await tester.tap(find.text(d));
      await tester.pump(const Duration(milliseconds: 350));
    }
    expect(find.text('Підтверди PIN'), findsOneWidget);
    for (final d in ['9', '4', '7', '3']) {
      await tester.tap(find.text(d));
      await tester.pump(const Duration(milliseconds: 350));
    }
    await tester.pump(const Duration(milliseconds: 800));
    // Step 3 title (appbar step label) + question text.
    expect(find.text('Біометрія'), findsWidgets);
    expect(find.text('Використовувати біометрію для розблокування?'),
        findsOneWidget);
  });

  testWidgets('6.22 PIN lock: wrong PIN → error message', (tester) async {
    final container = await pumpScreen(tester, '/pin-lock');
    await container.read(pinRepositoryProvider).setupPin('9473');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Введи PIN'), findsOneWidget);
    for (final d in ['1', '2', '3', '4']) {
      await tester.tap(find.text(d));
      await tester.pump(const Duration(milliseconds: 200));
    }
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Невірний PIN'), findsOneWidget);
  });
}
