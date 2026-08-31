import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/data/repositories/scanner_repositories.dart';

import '../helpers/test_harness.dart';

/// 6.32 Bundle Search (ONE SCREEN ⛔) + 6.33 API Settings.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('6.32 Bundle Search: online-only honest empty without data',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpScreen(tester, '/bundle-search');
    await tester.pump(const Duration(seconds: 3));
    // ONLINE-ONLY (v0.9.2): bundles are built from verified prices only;
    // without Tavily data the screen shows an honest empty state — no fake
    // recommendation, no infinite fake loader.
    expect(
        find.textContaining('Немає підтверджених пропозицій'), findsOneWidget);
    expect(find.textContaining('Підключи Tavily'), findsOneWidget);
  });

  testWidgets('6.33 API Settings: add key (masked), test, never plain',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = await pumpScreen(tester, '/api-settings');
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Керування ключами магазинів'), findsOneWidget);
    expect(find.textContaining('підтвердження PIN'), findsOneWidget);
    await container.read(apiKeysRepositoryProvider).add(
          name: 'Rozetka API',
          key: 'rk_live_0123456789abcdef',
          storeId: 'rozetka',
        );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.textContaining('Rozetka API'), findsOneWidget);
    // ⛔ Key masked — plain key never rendered (§7.1quin.1).
    expect(find.textContaining('rk_live'), findsNothing);
    expect(find.textContaining('••••'), findsWidgets);
    // Test button → connected status.
    await tester.tap(find.text('Перевірити API'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.textContaining('ПІДКЛЮЧЕНО'), findsOneWidget);
  });
}
