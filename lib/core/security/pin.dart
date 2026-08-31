import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// PIN security (§6.21, §6.22, §8.3): 4–6 digits, weak-PIN blacklist,
/// PBKDF2-HMAC-SHA256 hash (Android Keystore-backed salt in prod binding),
/// lockout 3 fails → 30 s (feature 34), 10 fails → sign out.
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

  /// PBKDF2-HMAC-SHA256, 10k iterations (fast enough for mobile UX).
  static String hash(String pin, String salt) {
    var key = _hmacSha256(utf8.encode(salt), utf8.encode(pin));
    var acc = List<int>.from(key);
    const iterations = 10000;
    for (var i = 1; i < iterations; i++) {
      key = _hmacSha256(utf8.encode(salt), key);
      for (var j = 0; j < acc.length; j++) {
        acc[j] ^= key[j];
      }
    }
    return base64Encode(acc);
  }

  static List<int> _hmacSha256(List<int> key, List<int> msg) {
    final h = Hmac(sha256, key);
    return h.convert(msg).bytes;
  }

  static bool verify(String pin, String salt, String expectedHash) =>
      _fixedEq(hash(pin, salt), expectedHash);

  static bool _fixedEq(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}

/// Lockout state machine (⛔): 3 fails → 30 s block (feature 34); 10 → sign out.
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
  PinLockout registerFailure(int nowMs) {
    final fails = failedAttempts + 1;
    if (fails >= signOutAfterFails) {
      return PinLockout(failedAttempts: fails, lockedUntilMs: null);
    }
    if (fails >= blockAfterFails && fails % blockAfterFails == 0) {
      return PinLockout(
        failedAttempts: fails,
        lockedUntilMs: nowMs + blockMillis,
      );
    }
    return PinLockout(failedAttempts: fails);
  }

  bool get shouldSignOut => failedAttempts >= signOutAfterFails;

  PinLockout reset() => const PinLockout(failedAttempts: 0);
}
