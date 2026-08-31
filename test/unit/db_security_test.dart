import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/data/repositories/providers.dart';

/// ⛔ §8.3 — SQLCipher passphrase policy.
///
/// Builds ≤ v0.9.0+9 fell back to a PLAINTEXT `.nv_db_key` file next to the
/// encrypted database whenever the Keystore misbehaved, which handed anyone
/// with filesystem access both the vault and its key. These tests pin the new
/// contract: Keystore or nothing.
void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('nv_db_security_test');
  });

  tearDown(() async {
    if (dir.existsSync()) await dir.delete(recursive: true);
  });

  File legacyFile() => File('${dir.path}/$kLegacyPlaintextKeyFileName');

  /// In-memory stand-in for FlutterSecureStorage.
  ({SecureRead read, SecureWrite write, Map<String, String> store}) fakeStore({
    Map<String, String>? initial,
    Object? throwOnRead,
    Object? throwOnWrite,
    bool dropWrites = false,
  }) {
    final store = <String, String>{...?initial};
    return (
      store: store,
      read: (key) async {
        final err = throwOnRead;
        if (err != null) throw err;
        return store[key];
      },
      write: (key, value) async {
        final err = throwOnWrite;
        if (err != null) throw err;
        // `dropWrites` emulates secure storage that reports success but does
        // not actually persist (observed with a broken Keystore provider).
        if (!dropWrites) store[key] = value;
      },
    );
  }

  group('resolveDbPassphrase — Keystore unavailable ⇒ fail-fast', () {
    test('read failure throws KeystoreUnavailableException', () async {
      final s = fakeStore(throwOnRead: Exception('BAD_DECRYPT'));

      await expectLater(
        resolveDbPassphrase(dir: dir, read: s.read, write: s.write),
        throwsA(isA<KeystoreUnavailableException>().having(
          (e) => e.stage,
          'stage',
          KeystoreFailureStage.read,
        )),
      );
    });

    test('write failure throws KeystoreUnavailableException', () async {
      final s = fakeStore(throwOnWrite: Exception('keystore full'));

      await expectLater(
        resolveDbPassphrase(dir: dir, read: s.read, write: s.write),
        throwsA(isA<KeystoreUnavailableException>().having(
          (e) => e.stage,
          'stage',
          KeystoreFailureStage.write,
        )),
      );
    });

    test('silently dropped write is caught by the read-back check', () async {
      final s = fakeStore(dropWrites: true);

      await expectLater(
        resolveDbPassphrase(dir: dir, read: s.read, write: s.write),
        throwsA(isA<KeystoreUnavailableException>().having(
          (e) => e.stage,
          'stage',
          KeystoreFailureStage.verify,
        )),
      );
    });

    test('the error message is honest about why the app refuses to start',
        () async {
      final s = fakeStore(throwOnRead: Exception('BAD_DECRYPT'));

      Object? captured;
      try {
        await resolveDbPassphrase(dir: dir, read: s.read, write: s.write);
      } catch (e) {
        captured = e;
      }

      expect(captured, isA<KeystoreUnavailableException>());
      final text = '$captured';
      expect(text, contains('Keystore'));
      expect(text, contains('never'));
      expect(text, contains('BAD_DECRYPT'));
    });
  });

  group('resolveDbPassphrase — ⛔ no plaintext fallback on disk', () {
    test('Keystore read failure writes no key file', () async {
      final s = fakeStore(throwOnRead: Exception('nope'));

      try {
        await resolveDbPassphrase(dir: dir, read: s.read, write: s.write);
      } catch (_) {
        // expected — asserted in the group above
      }

      expect(legacyFile().existsSync(), isFalse);
      expect(dir.listSync(), isEmpty);
    });

    test('Keystore write failure writes no key file', () async {
      final s = fakeStore(throwOnWrite: Exception('nope'));

      try {
        await resolveDbPassphrase(dir: dir, read: s.read, write: s.write);
      } catch (_) {
        // expected — asserted in the group above
      }

      expect(legacyFile().existsSync(), isFalse);
      expect(dir.listSync(), isEmpty);
    });

    test('happy path keeps the key in secure storage only', () async {
      final s = fakeStore();

      final passphrase =
          await resolveDbPassphrase(dir: dir, read: s.read, write: s.write);

      expect(passphrase, isNotEmpty);
      expect(s.store[kDbPassphraseStorageKey], passphrase);
      // Nothing whatsoever is persisted next to the database.
      expect(dir.listSync(), isEmpty);
    });

    test('a second run reuses the stored key instead of rotating it',
        () async {
      final s = fakeStore();

      final first =
          await resolveDbPassphrase(dir: dir, read: s.read, write: s.write);
      final second =
          await resolveDbPassphrase(dir: dir, read: s.read, write: s.write);

      expect(second, first);
      expect(dir.listSync(), isEmpty);
    });
  });

  group('resolveDbPassphrase — legacy plaintext key migration', () {
    test('adopts the leaked key, moves it to Keystore and shreds the file',
        () async {
      final s = fakeStore();
      await legacyFile().writeAsString('legacy-passphrase-from-old-build\n');

      final passphrase =
          await resolveDbPassphrase(dir: dir, read: s.read, write: s.write);

      // The existing vault stays readable…
      expect(passphrase, 'legacy-passphrase-from-old-build');
      // …the key now lives in the Keystore…
      expect(s.store[kDbPassphraseStorageKey], passphrase);
      // …and the plaintext copy is gone.
      expect(legacyFile().existsSync(), isFalse);
      expect(dir.listSync(), isEmpty);
    });

    test('a stale key file is shredded even when Keystore already has a key',
        () async {
      final s = fakeStore(initial: {kDbPassphraseStorageKey: 'keystore-key'});
      await legacyFile().writeAsString('stale-leaked-key');

      final passphrase =
          await resolveDbPassphrase(dir: dir, read: s.read, write: s.write);

      expect(passphrase, 'keystore-key');
      expect(legacyFile().existsSync(), isFalse);
    });

    test('migration failure must not leave the plaintext key behind as a '
        'working fallback', () async {
      final s = fakeStore(throwOnWrite: Exception('keystore down'));
      await legacyFile().writeAsString('legacy-passphrase');

      await expectLater(
        resolveDbPassphrase(dir: dir, read: s.read, write: s.write),
        throwsA(isA<KeystoreUnavailableException>()),
      );
      // The file is still there (we could not migrate it yet) but it is NEVER
      // used to open the vault — the call threw instead of returning it.
      expect(legacyFile().existsSync(), isTrue);
    });
  });

  group('generateDbPassphrase', () {
    test('256-bit hex key, injection-safe alphabet', () {
      final key = generateDbPassphrase();
      expect(key, hasLength(64));
      expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(key), isTrue);
    });

    test('does not repeat', () {
      final keys = {for (var i = 0; i < 20; i++) generateDbPassphrase()};
      expect(keys, hasLength(20));
    });
  });

  group('pragmaKeyStatement — safe SQL construction', () {
    test('wraps a generated key as a quoted literal', () {
      expect(
        pragmaKeyStatement('deadbeef'),
        "PRAGMA key = 'deadbeef';",
      );
    });

    test('escapes single quotes instead of interpolating them raw', () {
      // A raw interpolation of this value would terminate the literal and
      // append an attacker-controlled statement.
      const hostile = "x'; ATTACH DATABASE '/tmp/evil.db' AS evil; --";

      final sql = pragmaKeyStatement(hostile);

      expect(sql, startsWith("PRAGMA key = '"));
      expect(sql, endsWith("';"));
      expect(sql, contains("x''; ATTACH DATABASE ''/tmp/evil.db'' AS evil; --"));
      // Exactly one statement: the opening quote, the escaped body, the
      // closing quote — no unescaped quote can split it.
      final quotes = "'".allMatches(sql).length;
      expect(quotes.isEven, isTrue);
    });

    test('rejects control characters and empty keys', () {
      expect(() => pragmaKeyStatement(''), throwsArgumentError);
      expect(() => pragmaKeyStatement('abc\u0000def'), throwsArgumentError);
      expect(() => pragmaKeyStatement('abc\ndef'), throwsArgumentError);
    });
  });
}
