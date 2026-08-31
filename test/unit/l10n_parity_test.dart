import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/core/l10n/strings.dart';

/// Criterion 12.8: UA+EN complete — 0 untranslated strings.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('UA and EN locales have IDENTICAL key sets', () async {
    final uk = await NvStrings.keysOf(NvStrings.ua);
    final en = await NvStrings.keysOf(NvStrings.en);
    expect(uk, isNotEmpty);
    expect(en, isNotEmpty);
    expect(
      uk.difference(en),
      isEmpty,
      reason: 'Keys missing in EN: ${uk.difference(en).toList()}',
    );
    expect(
      en.difference(uk),
      isEmpty,
      reason: 'Keys missing in UA: ${en.difference(uk).toList()}',
    );
  });

  test('no empty translation values in either locale', () async {
    for (final code in [NvStrings.ua, NvStrings.en]) {
      final s = await NvStrings.load(code);
      final empty = s.keys().where((k) {
        final v = s.t(k);
        return v.trim().isEmpty || v == k;
      }).toList();
      expect(empty, isEmpty, reason: 'locale $code: $empty');
    }
  });

  test('interpolation placeholders resolve', () async {
    final s = await NvStrings.load(NvStrings.ua);
    final out = s.t('add_money.xp_toast', {'n': 12});
    expect(out.contains('{n}'), isFalse);
    expect(out.contains('12'), isTrue);
  });
}
