import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/core/utils/format.dart' show stringsProvider;
import 'package:neovault/data/cloud/cloud_gateway.dart';
import 'package:neovault/data/repositories/providers.dart';
import 'package:neovault/data/repositories/ui_providers.dart'
    show countdownTickProvider;
import 'package:neovault/features/settings/auth_sheet.dart';
import 'package:neovault/shared/widgets/widgets.dart' show reduceMotionProvider;

/// HOTFIX v0.9.0+9.2 — device crash: the auth sheet's TabBar had no
/// controller (a modal bottom sheet lives on its own route, so no
/// page-level DefaultTabController is visible above it) →
/// «No TabController for TabBar». Regression: the sheet must open, show
/// both tabs and reveal the nickname field after switching to register.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'auth sheet: opens without crash, register tab shows nickname field',
      (tester) async {
    final db = openTestDatabase();
    await bootstrapDatabase(db, now: DateTime(2026, 8, 30, 12));

    final container = ProviderContainer(overrides: [
      dbProvider.overrideWithValue(db),
      cloudGatewayProvider.overrideWithValue(LocalOnlyGateway()),
      countdownTickProvider.overrideWith((ref) => Stream.value(0)),
      reduceMotionProvider.overrideWith((ref) => true),
    ]);
    addTearDown(container.dispose);

    await tester.runAsync(() => container.read(stringsProvider.future));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => showAuthSheet(context, ref),
                  child: const Text('OPEN_AUTH'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text('OPEN_AUTH'));
    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    // Tabs render (previously the whole sheet content crashed here).
    expect(find.text('Вхід'), findsOneWidget);
    expect(find.text('Реєстрація'), findsOneWidget);
    // Login mode: email + password.
    expect(find.byType(TextField), findsNWidgets(2));

    // Switch to register: nickname + agree checkbox appear.
    await tester.tap(find.text('Реєстрація'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(CheckboxListTile), findsOneWidget);
  });
}
