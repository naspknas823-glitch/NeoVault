import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_harness.dart';

/// 6.28 Live Progress Card + 6.31 Buddy.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('6.28 Progress card: empty → enable → link + QR', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpScreen(tester, '/progress-card');
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Поділись прогресом із друзями'), findsOneWidget);
    await tester.tap(find.text('Увімкнути').first);
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.textContaining('neovault-beta.web.app'), findsOneWidget);
    expect(find.text('QR-код'), findsOneWidget);
    expect(find.text('Оновити посилання'), findsOneWidget);
    // ⛔ Amount field off by default (§10.5).
    expect(find.text('Показувати суму'), findsOneWidget);
  });
}
