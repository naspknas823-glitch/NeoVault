import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_harness.dart';

/// 6.7 Price Scanner + 6.8 AI Guardian (§6.7/§6.8).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('6.7 Scanner: product cards, buy badge, next scan, offers',
      (tester) async {
    await pumpScreen(tester, '/scanner');
    await tester.pump(const Duration(milliseconds: 800));
    expect(find.text('Price Scanner'), findsWidgets);
    // ⛔ No manual refresh — only next-scan info (§9.5).
    expect(find.textContaining('08:00'), findsWidgets);
    // ONLINE-ONLY (v0.9.2): no Tavily key → honest empty state —
    // NO seed/mock price substitution (⛔).
    expect(find.textContaining('Ціни — тільки онлайн'), findsOneWidget);
    // Bundle CTA (§6.7) — scroll down to it.
    await tester.scrollUntilVisible(
      find.textContaining('Знайти комплект'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('Знайти комплект'), findsOneWidget);
    // API status block — further down, scroll again.
    await tester.scrollUntilVisible(
      find.text('API-підключення'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('API-підключення'), findsOneWidget);
  });

  testWidgets('6.8 AI Chat: modes, welcome, fallback reply offline',
      (tester) async {
    await pumpScreen(tester, '/ai');
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('AI Guardian'), findsOneWidget);
    expect(find.text('Advisor'), findsOneWidget);
    expect(find.text('Guardian'), findsOneWidget);
    expect(find.text('Motivator'), findsOneWidget);
    // Limits label (100 authed / 20 guest — guest default).
    expect(find.text('Запитів лишилось: 20'), findsOneWidget);
    // Type and send → offline fallback preset (LocalOnlyGateway).
    await tester.enterText(find.byType(TextField), 'Як справи?');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump(const Duration(milliseconds: 700));
    // User bubble + assistant fallback with offline indicator.
    expect(find.text('Як справи?'), findsOneWidget);
    expect(find.text('Офлайн-режим асистента'), findsOneWidget);
  });
}
