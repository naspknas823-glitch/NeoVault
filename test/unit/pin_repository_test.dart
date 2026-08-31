import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/core/db/app_database.dart';
import 'package:neovault/core/security/pin.dart';
import 'package:neovault/data/repositories/providers.dart';
import 'package:neovault/data/repositories/system_repositories.dart';

/// PIN repository behaviour against a real (in-memory) Drift database:
/// lockout persistence, its reset after the allowed time, and the transparent
/// KDF upgrade of hashes written by older builds.
///
/// These tests run the REAL key-derivation cost, so they get a generous
/// timeout instead of a lowered iteration count.
const _slow = Timeout(Duration(minutes: 3));

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late PinRepository pin;

  setUp(() async {
    db = openTestDatabase();
    await bootstrapDatabase(db, now: DateTime(2026, 8, 30, 12));
    container = ProviderContainer(overrides: [dbProvider.overrideWithValue(db)]);
    pin = container.read(pinRepositoryProvider);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<PinMetaData> row() =>
      (db.select(db.pinMeta)..where((t) => t.id.equals('main'))).getSingle();

  Future<void> setLockedUntil(int? ms) async {
    await (db.update(db.pinMeta)..where((t) => t.id.equals('main')))
        .write(PinMetaCompanion(lockedUntil: Value(ms)));
  }

  group('lockout persistence', () {
    test('3 wrong PINs lock the vault; the next attempt is refused outright',
        () async {
      expect(await pin.setupPin('9473'), isNull);

      expect(await pin.verify('1357', isAuthed: false), isA<PinFailure>());
      expect(await pin.verify('1357', isAuthed: false), isA<PinFailure>());
      final third = await pin.verify('1357', isAuthed: false);
      expect(third, isA<PinFailure>());
      expect((third as PinFailure).locked, isTrue);

      final stored = await row();
      expect(stored.failedAttempts, 3);
      expect(stored.lockedUntil, isNotNull);

      // ⛔ While blocked, even the CORRECT PIN is refused — the lock is not a
      // UI-only affordance.
      expect(await pin.verify('9473', isAuthed: false), isA<PinLockedOut>());
    }, timeout: _slow);

    test('REGRESSION: the 4th failure re-locks instead of being free',
        () async {
      await pin.setupPin('9473');
      for (var i = 0; i < 3; i++) {
        await pin.verify('1357', isAuthed: false);
      }
      // Serve the 30 s block.
      await setLockedUntil(DateTime.now().millisecondsSinceEpoch - 1);

      final fourth = await pin.verify('1357', isAuthed: false);
      expect(fourth, isA<PinFailure>());
      expect((fourth as PinFailure).locked, isTrue,
          reason: 'attempt 4 must be throttled, not free');

      final stored = await row();
      expect(stored.failedAttempts, 4);
      expect(stored.lockedUntil, isNotNull);
      expect(stored.lockedUntil!,
          greaterThan(DateTime.now().millisecondsSinceEpoch));
    }, timeout: _slow);

    test('lockout is released after the allowed time and reset on success',
        () async {
      await pin.setupPin('9473');
      for (var i = 0; i < 3; i++) {
        await pin.verify('1357', isAuthed: false);
      }
      expect(await pin.verify('9473', isAuthed: false), isA<PinLockedOut>());

      // The 30 s block elapses.
      await setLockedUntil(DateTime.now().millisecondsSinceEpoch - 1);

      expect(await pin.verify('9473', isAuthed: false), isA<PinSuccess>());

      final stored = await row();
      expect(stored.failedAttempts, 0);
      expect(stored.lockedUntil, isNull);
    }, timeout: _slow);

    test('10 failures escalate to sign-out', () async {
      await pin.setupPin('9473');
      // Jump straight to the 8th failure: the full escalation ladder is
      // covered by the pure PinLockout tests, so this stays a repository-level
      // assertion instead of paying for 10 real key derivations.
      await (db.update(db.pinMeta)..where((t) => t.id.equals('main'))).write(
        const PinMetaCompanion(
          failedAttempts: Value(8),
          lockedUntil: Value(null),
        ),
      );

      expect(await pin.verify('1357', isAuthed: false), isA<PinFailure>());
      await setLockedUntil(null); // attacker waits out the block

      expect(await pin.verify('1357', isAuthed: false), isA<PinSignOut>());
      expect((await row()).failedAttempts, PinLockout.signOutAfterFails);
    }, timeout: _slow);
  });

  group('KDF upgrade of pre-v0.9.1 hashes', () {
    test('a legacy hash verifies once, then is rehashed with current cost',
        () async {
      const salt = 'c2FsdC1mb3ItbGVnYWN5LXRlc3Q=';
      final legacy = PinSecurity.legacyHash('9473', salt);
      await (db.update(db.pinMeta)..where((t) => t.id.equals('main'))).write(
        PinMetaCompanion(pinHash: Value(legacy), salt: const Value(salt)),
      );
      expect(PinSecurity.needsRehash(legacy), isTrue);

      // Existing users keep unlocking with the same PIN.
      expect(await pin.verify('9473', isAuthed: false), isA<PinSuccess>());

      final upgraded = (await row()).pinHash!;
      expect(upgraded, isNot(legacy));
      expect(upgraded, startsWith('${PinSecurity.algorithmTag}\$'));
      expect(PinSecurity.needsRehash(upgraded), isFalse);

      // …and the upgraded hash keeps working (and is not rewritten again).
      expect(await pin.verify('9473', isAuthed: false), isA<PinSuccess>());
      expect((await row()).pinHash, upgraded);
    }, timeout: _slow);

    test('a wrong PIN never triggers an upgrade', () async {
      const salt = 'c2FsdC1mb3ItbGVnYWN5LXRlc3Q=';
      final legacy = PinSecurity.legacyHash('9473', salt);
      await (db.update(db.pinMeta)..where((t) => t.id.equals('main'))).write(
        PinMetaCompanion(pinHash: Value(legacy), salt: const Value(salt)),
      );

      expect(await pin.verify('1357', isAuthed: false), isA<PinFailure>());
      expect((await row()).pinHash, legacy);
    }, timeout: _slow);
  });

  group('setup', () {
    test('new PINs are stored in the current format, never in plaintext',
        () async {
      expect(await pin.setupPin('9473'), isNull);

      final stored = await row();
      expect(stored.pinHash, isNotNull);
      expect(stored.salt, isNotNull);
      expect(stored.pinHash, startsWith('${PinSecurity.algorithmTag}\$'));
      expect(stored.pinHash, isNot(contains('9473')));
      expect(PinSecurity.needsRehash(stored.pinHash!), isFalse);
    }, timeout: _slow);

    test('weak PINs are rejected before anything is written', () async {
      expect(await pin.setupPin('1234'), 'pin.weak');
      expect((await row()).pinHash, isNull);
    });
  });
}
