import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

/// PIN security (§6.21, §6.22, §8.3): 4–6 digits, weak-PIN blacklist,
/// PBKDF2-HMAC-SHA256 hash, lockout 3 fails → 30 s (feature 34) re-armed on
/// every further failure, 10 fails → sign out.
///
/// ⚠️ RESIDUAL RISK (documented on purpose): a 4–6 digit PIN spans only
/// 10^4–10^6 candidates, so no iteration count makes an OFFLINE attack on an
/// extracted `pin_meta` row truly infeasible — it only raises the cost. The
/// real mitigations are that (a) `pin_meta` lives inside the SQLCipher vault
/// whose key never leaves the Android Keystore (see
/// `data/repositories/providers.dart`), and (b) backups/data-extraction are
/// disabled in the manifest. Binding the hash to a Keystore-held pepper is
/// the recommended next hardening step.
abstract final class PinSecurity {
  static final RegExp digitsOnly = RegExp(r'^\d{4,6}$');

  /// Simple PIN blacklist (⛔): common codes, repeats, sequences.
  static const Set<String> weakPins = {
    '1234', '0000', '1111', '2222', '4321', '123456', '111111', '121212',
    '123123', '654321', '666666', '888888', '999999', '112233', '1004',
  };

  /// Returns null if valid, else a weak-reason key.
  static String? validate(String pin) {
    if (!digitsOnly.hasMatch(pin)) return 'pin.invalid_len';
    if (weakPins.contains(pin)) return 'pin.weak';
    // Same digit repeated (e.g. 5555).
    if (RegExp(r'^(\d)\1+$').hasMatch(pin)) return 'pin.weak';
    // Ascending / descending sequence (e.g. 2345, 8765).
    if (_isSequence(pin, 1) || _isSequence(pin, -1)) return 'pin.weak';
    return null;
  }

  static bool _isSequence(String pin, int dir) {
    for (var i = 1; i < pin.length; i++) {
      final d = pin.codeUnitAt(i) - pin.codeUnitAt(i - 1);
      if (d != dir) return false;
    }
    return true;
  }

  static String newSalt({Random? rng}) {
    final r = rng ?? Random.secure();
    final bytes = List<int>.generate(16, (_) => r.nextInt(256));
    return base64Encode(bytes);
  }

  /// ── Key derivation ────────────────────────────────────────────────────
  /// Algorithm tag of the current (RFC 2898) format.
  static const String algorithmTag = 'pbkdf2-sha256';

  /// Current KDF cost. Raised 10 000 → 50 000 (5× harder offline brute-force)
  /// while keeping a single unlock well under the frame budget of the PIN
  /// screen — the derivation runs synchronously on the UI isolate.
  static const int defaultIterations = 50000;

  /// Cost baked into hashes written by builds ≤ v0.9.0+9.
  static const int legacyIterations = 10000;

  /// Sanity bounds when parsing a stored hash (a corrupted row must not be
  /// able to hang the app with an absurd iteration count).
  static const int _maxParsableIterations = 5000000;

  static const int _hLenBytes = 32; // SHA-256 output
  static const int _dkLenBytes = 32;

  /// Derives a NEW hash in the self-describing format
  /// `pbkdf2-sha256$<iterations>$<base64 dk>`.
  ///
  /// The parameters travel with the hash, so the cost can be raised later
  /// without a schema migration — [needsRehash] flags stale rows and
  /// `PinRepository.verify` upgrades them on the next successful unlock.
  static String hash(
    String pin,
    String salt, {
    int iterations = defaultIterations,
  }) {
    if (iterations < 1) {
      throw ArgumentError.value(iterations, 'iterations', 'must be >= 1');
    }
    final dk = _pbkdf2(
      password: utf8.encode(pin),
      salt: utf8.encode(salt),
      iterations: iterations,
      dkLen: _dkLenBytes,
    );
    return '$algorithmTag\$$iterations\$${base64Encode(dk)}';
  }

  /// Verifies [pin] against [storedHash], transparently supporting the
  /// legacy (pre-v0.9.1) format so existing installs keep working without a
  /// database migration or a forced PIN re-enrollment.
  static bool verify(String pin, String salt, String storedHash) {
    final parsed = _ParsedHash.tryParse(storedHash);
    if (parsed == null) {
      // Legacy rows are a bare base64 digest (no '$' separators).
      return _fixedEq(legacyHash(pin, salt), storedHash);
    }
    final candidate = base64Encode(_pbkdf2(
      password: utf8.encode(pin),
      salt: utf8.encode(salt),
      iterations: parsed.iterations,
      dkLen: _dkLenBytes,
    ));
    return _fixedEq(candidate, parsed.encodedDk);
  }

  /// True when [storedHash] was produced by an older/weaker configuration and
  /// should be re-derived after the next successful verify.
  static bool needsRehash(String storedHash) {
    final parsed = _ParsedHash.tryParse(storedHash);
    if (parsed == null) return true; // legacy format
    return parsed.iterations < defaultIterations;
  }

  /// Exact hash function used by builds ≤ v0.9.0+9 — kept ONLY so existing
  /// PINs still verify. ⛔ Never use it to write new hashes.
  @visibleForTesting
  static String legacyHash(String pin, String salt) {
    var key = _hmacSha256(utf8.encode(salt), utf8.encode(pin));
    var acc = List<int>.from(key);
    for (var i = 1; i < legacyIterations; i++) {
      key = _hmacSha256(utf8.encode(salt), key);
      for (var j = 0; j < acc.length; j++) {
        acc[j] ^= key[j];
      }
    }
    return base64Encode(acc);
  }

  /// PBKDF2 as specified by RFC 2898 (HMAC-SHA256 PRF).
  static List<int> _pbkdf2({
    required List<int> password,
    required List<int> salt,
    required int iterations,
    required int dkLen,
  }) {
    final prf = Hmac(sha256, password);
    final blocks = (dkLen / _hLenBytes).ceil();
    final output = <int>[];
    for (var block = 1; block <= blocks; block++) {
      var u = prf.convert([...salt, ..._uint32be(block)]).bytes;
      final t = List<int>.from(u);
      for (var i = 1; i < iterations; i++) {
        u = prf.convert(u).bytes;
        for (var j = 0; j < _hLenBytes; j++) {
          t[j] ^= u[j];
        }
      }
      output.addAll(t);
    }
    return output.sublist(0, dkLen);
  }

  static List<int> _uint32be(int value) => [
        (value >> 24) & 0xFF,
        (value >> 16) & 0xFF,
        (value >> 8) & 0xFF,
        value & 0xFF,
      ];

  static List<int> _hmacSha256(List<int> key, List<int> msg) {
    final h = Hmac(sha256, key);
    return h.convert(msg).bytes;
  }

  static bool _fixedEq(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}

/// Parsed `algorithm$iterations$base64` hash.
class _ParsedHash {
  const _ParsedHash({required this.iterations, required this.encodedDk});

  final int iterations;
  final String encodedDk;

  static _ParsedHash? tryParse(String stored) {
    final parts = stored.split(r'$');
    if (parts.length != 3) return null;
    if (parts[0] != PinSecurity.algorithmTag) return null;
    final iterations = int.tryParse(parts[1]);
    if (iterations == null ||
        iterations < 1 ||
        iterations > PinSecurity._maxParsableIterations) {
      return null;
    }
    if (parts[2].isEmpty) return null;
    return _ParsedHash(iterations: iterations, encodedDk: parts[2]);
  }
}

/// Lockout state machine (⛔): from the 3rd failure onwards every wrong PIN
/// re-arms a 30 s block (feature 34); 10 total failures → sign out.
class PinLockout {
  const PinLockout({
    required this.failedAttempts,
    this.lockedUntilMs,
  });

  final int failedAttempts;
  final int? lockedUntilMs;

  static const int blockAfterFails = 3; // (34) Lockout after 3 failed attempts
  static const int signOutAfterFails = 10;
  static const int blockMillis = 30000;

  bool isLocked(int nowMs) =>
      lockedUntilMs != null && nowMs < lockedUntilMs!;

  /// New state after a failed attempt.
  ///
  /// ⛔ SECURITY: EVERY failure at or beyond [blockAfterFails] re-arms the
  /// block. The previous `fails % blockAfterFails == 0` rule only locked on
  /// attempts 3, 6 and 9, so once a block expired the attacker got two free
  /// guesses (4–5, 7–8) before the next one — a 3× cheaper online attack.
  PinLockout registerFailure(int nowMs) {
    final fails = failedAttempts + 1;
    final blocked = fails >= blockAfterFails;
    return PinLockout(
      failedAttempts: fails,
      lockedUntilMs: blocked ? nowMs + blockMillis : null,
    );
  }

  bool get shouldSignOut => failedAttempts >= signOutAfterFails;

  PinLockout reset() => const PinLockout(failedAttempts: 0);
}
