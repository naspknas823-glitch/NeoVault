import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App-level PIN gate (§6.22): `true` = every route except `/pin-lock` is
/// redirected to `/pin-lock` by the router guard. Set by:
///   • splash bootstrap — when a PIN exists in `pin_meta` (cold-start lock);
///   • autolock lifecycle observer (app.dart) — backgrounded longer than the
///     configured autolock interval;
/// cleared by [PinLockScreen] after a successful PIN/biometric verify.
///
/// Tests that build the router without a gate (the harness default) keep the
/// redirect disabled, so pumping `/pin-lock` directly still works.
final pinGateProvider = StateProvider<bool>((ref) => false);
