import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/core/security/pin.dart';

/// PIN hashing (§6.21/§8.3) and the lockout state machine (feature 34).
///
/// Cheap iteration counts are passed explicitly wherever the test is about
/// FORMAT or MIGRATION rather than about cost.
void main() {
  group('PinSecurity — hash format', () {
    test(r'new hashes are self-describing: algorithm$iterations$digest', () {
      final salt = PinSecurity.newSalt();
      final h = PinSecurity.hash('9473', salt, iterations: 100);

      final parts = h.split(r'$');
      expect(parts, hasLength(3));
      expect(parts[0], PinSecurity.algorithmTag);
      expect(parts[1], '100');
      expect(parts[2], isNotEmpty);
    });

    test('same input + same salt ⇒ same digest; different salt ⇒ different',
        () {
      const salt = 'c2FsdC1vbmU=';
      const other = 'c2FsdC10d28=';
      expect(
        PinSecurity.hash('9473', salt, iterations: 100),
        PinSecurity.hash('9473', salt, iterations: 100),
      );
      expect(
        PinSecurity.hash('9473', salt, iterations: 100),
        isNot(PinSecurity.hash('9473', other, iterations: 100)),
      );
    });

    test('cost is part of the digest, so raising it changes the hash', () {
      const salt = 'c2FsdA==';
      expect(
        PinSecurity.hash('9473', salt, iterations: 100),
        isNot(PinSecurity.hash('9473', salt, iterations: 200)),
      );
    });

    test('rejects a nonsensical cost', () {
      expect(() => PinSecurity.hash('9473', 'c2FsdA==', iterations: 0),
          throwsArgumentError);
    });

    test('default cost is meaningfully higher than the legacy one', () {
      expect(PinSecurity.defaultIterations,
          greaterThan(PinSecurity.legacyIterations));
    });
  });

  group('PinSecurity — verify', () {
    test('accepts the correct PIN and rejects everything else', () {
      final salt = PinSecurity.newSalt();
      final h = PinSecurity.hash('9182', salt, iterations: 100);

      expect(PinSecurity.verify('9182', salt, h), isTrue);
      expect(PinSecurity.verify('9183', salt, h), isFalse);
      expect(PinSecurity.verify('91820', salt, h), isFalse);
      expect(PinSecurity.verify('', salt, h), isFalse);
    });

    test('rejects a hash derived with a different salt', () {
      final h = PinSecurity.hash('9182', 'c2FsdC1vbmU=', iterations: 100);
      expect(PinSecurity.verify('9182', 'c2FsdC10d28=', h), isFalse);
    });

    test('a corrupted / absurd stored hash never throws, just fails', () {
      const salt = 'c2FsdA==';
      for (final broken in <String>[
        '',
        'not-a-hash',
        r'pbkdf2-sha256$',
        r'pbkdf2-sha256$abc$zzz',
        r'pbkdf2-sha256$999999999999$zzz', // would hang if honoured
        r'scrypt$100$zzz',
      ]) {
        expect(PinSecurity.verify('9182', salt, broken), isFalse,
            reason: 'stored hash: $broken');
      }
    });
  });

  group('PinSecurity — migration from pre-v0.9.1 hashes', () {
    test('legacy digests still verify (no forced PIN re-enrollment)', () {
      final salt = PinSecurity.newSalt();
      final legacy = PinSecurity.legacyHash('9473', salt);

      expect(PinSecurity.verify('9473', salt, legacy), isTrue);
      expect(PinSecurity.verify('1357', salt, legacy), isFalse);
    });

    test('needsRehash flags legacy and under-cost hashes only', () {
      final salt = PinSecurity.newSalt();

      expect(PinSecurity.needsRehash(PinSecurity.legacyHash('9473', salt)),
          isTrue);
      expect(
        PinSecurity.needsRehash(
            PinSecurity.hash('9473', salt, iterations: 100)),
        isTrue,
      );
      expect(
        PinSecurity.needsRehash(PinSecurity.hash('9473', salt)),
        isFalse,
      );
    });
  });

  group('PinLockout — no free attempts after a block expires (⛔)', () {
    test('first two failures do not block', () {
      var s = const PinLockout(failedAttempts: 0);
      s = s.registerFailure(1000);
      expect(s.isLocked(1000), isFalse);
      s = s.registerFailure(1000);
      expect(s.isLocked(1000), isFalse);
      expect(s.failedAttempts, 2);
    });

    test('the 3rd failure arms a 30s block', () {
      var s = const PinLockout(failedAttempts: 2);
      s = s.registerFailure(1000);

      expect(s.failedAttempts, 3);
      expect(s.isLocked(1000), isTrue);
      expect(s.isLocked(1000 + PinLockout.blockMillis - 1), isTrue);
      // Reset exactly when the allowed time has elapsed.
      expect(s.isLocked(1000 + PinLockout.blockMillis), isFalse);
      expect(s.isLocked(1000 + PinLockout.blockMillis + 5000), isFalse);
    });

    test(
        'REGRESSION: attempts 4 and 5 re-arm the block instead of being free',
        () {
      // Old rule was `fails % 3 == 0`, so after the 3rd block expired the
      // attacker got attempts 4 and 5 unthrottled before the next lock at 6.
      var s = const PinLockout(failedAttempts: 3, lockedUntilMs: 31000);
      expect(s.isLocked(31000), isFalse); // block served

      s = s.registerFailure(31000); // 4th
      expect(s.failedAttempts, 4);
      expect(s.isLocked(31000), isTrue,
          reason: '4th failure must block, not be free');

      s = s.registerFailure(61000); // 5th, after serving the block
      expect(s.failedAttempts, 5);
      expect(s.isLocked(61000), isTrue,
          reason: '5th failure must block, not be free');
    });

    test('every failure from the 3rd to the 10th is throttled', () {
      var s = const PinLockout(failedAttempts: 0);
      var now = 0;
      for (var attempt = 1; attempt <= PinLockout.signOutAfterFails; attempt++) {
        s = s.registerFailure(now);
        if (attempt < PinLockout.blockAfterFails) {
          expect(s.isLocked(now), isFalse, reason: 'attempt $attempt');
        } else {
          expect(s.isLocked(now), isTrue, reason: 'attempt $attempt');
        }
        // Attacker waits out the block before the next guess.
        now += PinLockout.blockMillis;
      }
      expect(s.failedAttempts, PinLockout.signOutAfterFails);
      expect(s.shouldSignOut, isTrue);
    });

    test('sign-out threshold is not reached early', () {
      var s = const PinLockout(failedAttempts: 0);
      for (var i = 0; i < PinLockout.signOutAfterFails - 1; i++) {
        s = s.registerFailure(1000);
        expect(s.shouldSignOut, isFalse);
      }
      s = s.registerFailure(1000);
      expect(s.shouldSignOut, isTrue);
    });

    test('reset() clears both the counter and the block', () {
      const s = PinLockout(failedAttempts: 7, lockedUntilMs: 99999);
      final r = s.reset();
      expect(r.failedAttempts, 0);
      expect(r.isLocked(0), isFalse);
      expect(r.shouldSignOut, isFalse);
    });
  });
}
