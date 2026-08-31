import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/features/bootstrap/bootstrap_error_screen.dart';

/// Bootstrap error screen (zero-white-screen guarantee): renders the reason
/// in a themed, localized shell and wires a REAL Retry callback.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('bootstrap error renders title, reason and retry',
      (tester) async {
    var retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: BootstrapErrorScreen(
          error: StateError('db open failed'),
          onRetry: () => retried = true,
        ),
      ),
    );
    // l10n asset read is REAL async I/O: escape fake-async with a small
    // real-time window, then settle. Deterministic across machines.
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 150)));
    await tester.pumpAndSettle();

    expect(find.text('Не вдалося запустити NeoVault'), findsOneWidget);
    expect(find.text('Спробувати ще раз'), findsOneWidget);
    expect(find.text('Технічні деталі'), findsOneWidget);

    // The reason text lives inside the details expansion → expand first.
    await tester.tap(find.text('Технічні деталі'));
    await tester.pumpAndSettle();
    expect(find.textContaining('db open failed'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bootstrap_retry')));
    expect(retried, isTrue);
  });

  testWidgets('bootstrap error raw-key fallback keeps UI functional',
      (tester) async {
    // The very first frame (before the FutureBuilder resolves strings) must
    // already render tappable UI — no blank screen while l10n loads.
    await tester.pumpWidget(
      MaterialApp(
        home: BootstrapErrorScreen(
          error: const FormatException('bad key'),
          onRetry: () {},
        ),
      ),
    );
    expect(find.byKey(const Key('bootstrap_retry')), findsOneWidget);

    await tester.pumpAndSettle();
    // Tap by key: works whether the async l10n asset read has landed or not
    // (raw-key fallback frame must stay fully interactive).
    await tester.tap(find.byKey(const Key('bootstrap_details_tile')));
    await tester.pumpAndSettle();
    expect(find.textContaining('FormatException'), findsOneWidget);
  });
}
