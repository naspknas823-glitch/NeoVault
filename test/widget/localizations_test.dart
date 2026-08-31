import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/app.dart';
import 'package:neovault/core/utils/format.dart' show stringsProvider;
import 'package:neovault/data/cloud/cloud_gateway.dart';
import 'package:neovault/data/repositories/providers.dart';
import 'package:neovault/data/repositories/ui_providers.dart'
    show countdownTickProvider;
import 'package:neovault/shared/widgets/widgets.dart' show reduceMotionProvider;

/// Device regression: the app root forces locale 'uk' (§2). With the old
/// English-only DefaultMaterialLocalizations the first TextField crashed
/// with "No MaterialLocalizations found" (onboarding step 2 on device).
/// This pumps the REAL NeoVaultApp so the MaterialApp delegate config is
/// exercised exactly as shipped.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('NeoVaultApp (forced uk locale) provides MaterialLocalizations',
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

    // Deterministic l10n asset read before the first frame.
    await tester.runAsync(() => container.read(stringsProvider.future));

    await tester.pumpWidget(
      TooltipVisibility(
        visible: false,
        child: UncontrolledProviderScope(
          container: container,
          child: const NeoVaultApp(), // real root: delegates + locale uk
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));
    // Splash brand window (1700ms) → route decision (onboarding/dashboard).
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));

    expect(tester.takeException(), isNull);
    final ctx = tester.element(find.byType(Scaffold).first);
    expect(
      Localizations.of<MaterialLocalizations>(ctx, MaterialLocalizations),
      isNotNull,
      reason:
          'MaterialLocalizations must resolve under the forced uk locale, '
          'otherwise any TextField crashes on device.',
    );
  });
}
