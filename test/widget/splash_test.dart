import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_harness.dart';

/// 6.1 Splash (§6.1): brand moment + init + routing decision.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('6.1 Splash renders brand and routes after init',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpScreen(tester, '/');
    expect(find.text('NeoVault'), findsOneWidget);
    expect(find.text('Save. Level up. Unlock your setup.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));
    // Onboarded user → Dashboard.
    expect(find.text('Додати гроші'), findsOneWidget);
  });

  testWidgets('6.1 Splash: new user → SetupWizard', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await pumpScreen(tester, '/', onboarded: false, setupWizard: false);
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
  });
}
