import 'package:flutter/material.dart';
import '../../core/utils/format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/security/pin.dart';
import '../../core/security/pin_gate.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/system_repositories.dart';
import '../../shared/widgets/widgets.dart';

/// Biometric prompt service (§6.23): system Android BiometricPrompt via
/// local_auth; graceful fallback to PIN when unavailable (tests/desktop).
class BiometricGate {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> available() async {
    try {
      return await _auth.canCheckBiometrics ||
          await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Returns true on successful biometric auth; false = fallback to PIN.
  static Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}

/// Protected-action gate (§6.23): biometrics first (if enabled), else PIN.
/// Used by: Delete Account, API-key edit/delete (⛔ §7.1quin.10).
Future<bool> showProtectedActionGate(BuildContext context, WidgetRef ref) async {
  final t = ref.read(tProvider);
  final pin = ref.read(pinRepositoryProvider);

  if (await pin.biometricEnabled() && await BiometricGate.available()) {
    final ok = await BiometricGate.authenticate(t('pin.biometric_prompt'));
    if (ok) return true;
  }
  if (!context.mounted) return false;
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => const _PinDialog(),
  );
  return result ?? false;
}

class _PinDialog extends ConsumerStatefulWidget {
  const _PinDialog();

  @override
  ConsumerState<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends ConsumerState<_PinDialog> {
  String _pin = '';
  String? _error;
  bool _locked = false;

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return AlertDialog(
      title: Text(t('pin.protected_title')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(t('pin.protected_body'), style: NvType.caption(c)),
          const SizedBox(height: 12),
          _PinDots(pin: _pin, error: _error != null, accent: c.accent),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!,
                  style: NvType.caption(c).copyWith(color: c.danger)),
            ),
          _Keypad(
            accent: c.accent,
            onDigit: (d) {
              if (_pin.length < 6) setState(() => _pin += d);
            },
            onBackspace: () {
              if (_pin.isNotEmpty) {
                setState(() => _pin = _pin.substring(0, _pin.length - 1));
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(t('common.cancel')),
        ),
        TextButton(
          onPressed: _locked
              ? null
              : () async {
                  final result = await ref
                      .read(pinRepositoryProvider)
                      .verify(_pin, isAuthed: false);
                  switch (result) {
                    case PinSuccess():
                      if (context.mounted) Navigator.pop(context, true);
                    case PinFailure():
                      setState(() => _error = ref.read(tProvider)('pin.wrong'));
                    case PinLockedOut():
                      setState(() {
                        _locked = true;
                        _error = ref.read(tProvider)('pin.locked_out');
                      });
                    case PinSignOut():
                      setState(() => _error =
                          ref.read(tProvider)('pin.too_many'));
                  }
                },
          child: Text(t('common.confirm')),
        ),
      ],
    );
  }
}

/// PIN dots (green on success, red + shake on error — §6.22).
class _PinDots extends ConsumerWidget {
  const _PinDots({
    required this.pin,
    required this.error,
    required this.accent,
  });
  final String pin;
  final bool error;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 6; i++)
          Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < pin.length
                  ? (error ? c.danger : accent)
                  : Colors.transparent,
              border: Border.all(color: error ? c.danger : c.border),
            ),
          ),
      ],
    );
  }
}

/// Neon keypad (§6.21).
class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.accent,
    required this.onDigit,
    required this.onBackspace,
  });
  final Color accent;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Column(
        children: [
          for (final row in [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
          ])
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final d in row)
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: _key(d),
                  ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 68),
              Padding(
                padding: const EdgeInsets.all(6),
                child: _key('0'),
              ),
              SizedBox(
                width: 68,
                height: 56,
                child: IconButton(
                  onPressed: onBackspace,
                  icon: Icon(Icons.backspace_outlined, color: accent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _key(String digit) {
    return SizedBox(
      width: 68,
      height: 56,
      child: OutlinedButton(
        onPressed: () => onDigit(digit),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: accent.withOpacity(0.3)),
        ),
        child: Text(digit,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: accent,
              fontFeatures: NvType.tabularFigures,
            )),
      ),
    );
  }
}

/// 6.21 PIN Setup (§6.21): 3 steps — create, confirm, biometrics option.
class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  int _step = 0;
  String _first = '';
  String _pin = '';
  String? _error;
  bool _biometric = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('pin');
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final stepTitle = switch (_step) {
      0 => t('pin.setup_step1'),
      1 => t('pin.setup_step2'),
      _ => t('pin.setup_step3'),
    };
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('pin.setup_title'))),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Text(stepTitle, style: NvType.h2(c), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            if (_step < 2) ...[
              _PinDots(pin: _pin, error: _error != null, accent: c.accent),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(_error!,
                      style: NvType.caption(c).copyWith(color: c.danger),
                      textAlign: TextAlign.center),
                ),
              _Keypad(
                accent: c.accent,
                onDigit: (d) async {
                  if (_pin.length >= 6) return;
                  setState(() {
                    _pin += d;
                    _error = null;
                  });
                  // Auto-advance at 4 digits (min) — also when confirming.
                  if (_pin.length == 4 || _pin.length == 6) {
                    await _onFull();
                  }
                },
                onBackspace: () {
                  if (_pin.isNotEmpty) {
                    setState(() => _pin = _pin.substring(0, _pin.length - 1));
                  }
                },
              ),
            ] else
              Column(
                children: [
                  Icon(Icons.fingerprint_rounded, size: 72, color: c.accent),
                  const SizedBox(height: 12),
                  Text(t('pin.biometric_q'), style: NvType.body(c)),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(t('pin.enable')),
                    value: _biometric,
                    onChanged: (v) => setState(() => _biometric = v),
                  ),
                ],
              ),
            const Spacer(),
            if (_step == 2)
              Padding(
                padding: const EdgeInsets.all(16),
                child: NeonGradientButton(
                  label: t('common.done'),
                  onPressed: () async {
                    await ref
                        .read(pinRepositoryProvider)
                        .setBiometric(_biometric);
                    if (context.mounted) context.go('/settings');
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _onFull() async {
    final t = ref.read(tProvider);
    final repo = ref.read(pinRepositoryProvider);
    if (_step == 0) {
      final weak = PinSecurity.validate(_pin);
      if (weak != null) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
        setState(() {
          _error = t(weak);
          _pin = '';
        });
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 250));
      setState(() {
        _first = _pin;
        _pin = '';
        _step = 1;
      });
      return;
    }
    if (_step == 1) {
      if (_pin != _first) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
        // Несупадіння → назад до кроку 1 з повідомленням (§6.21 step 2).
        setState(() {
          _error = t('pin.mismatch');
          _pin = '';
          _step = 0;
          _first = '';
        });
        return;
      }
      final err = await repo.setupPin(_pin);
      if (err != null) {
        setState(() {
          _error = t(err);
          _pin = '';
          _step = 0;
        });
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 250));
      setState(() {
        _pin = '';
        _step = 2;
      });
    }
  }
}

/// 6.22 PIN Lock (§6.22): blur/dark overlay, logo, dots, keypad, biometric
/// button, forgot-PIN flow, error shake, ⛔ 5 fails → 30 s, 10 → sign out.
class PinLockScreen extends ConsumerStatefulWidget {
  const PinLockScreen({super.key});

  @override
  ConsumerState<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<PinLockScreen> {
  String _pin = '';
  String? _error;
  bool _locked = false;

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return Scaffold(
      backgroundColor: c.background.withOpacity(0.96),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: c.accent, width: 2),
              ),
              child: Icon(Icons.lock_outline_rounded, size: 32, color: c.accent),
            ),
            const SizedBox(height: 20),
            Text(t('pin.enter_title'), style: NvType.h2(c)),
            const SizedBox(height: 20),
            _PinDots(pin: _pin, error: _error != null, accent: c.accent),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(_error!,
                    style: NvType.caption(c).copyWith(color: c.danger)),
              ),
            _Keypad(
              accent: c.accent,
              onDigit: (d) async {
                if (_locked || _pin.length >= 6) return;
                setState(() {
                  _pin += d;
                  _error = null;
                });
                if (_pin.length == 4 || _pin.length == 6) {
                  await _verify();
                }
              },
              onBackspace: () {
                if (_pin.isNotEmpty) {
                  setState(() => _pin = _pin.substring(0, _pin.length - 1));
                }
              },
            ),
            // Біометрія (якщо ввімкнена, §6.22).
            FutureBuilder<bool>(
              future: _bioEnabled(),
              builder: (context, snap) {
                if (snap.data != true) return const SizedBox.shrink();
                return IconButton(
                  onPressed: () async {
                    final ok = await BiometricGate.authenticate(
                        ref.read(tProvider)('pin.biometric_prompt'));
                    if (ok && mounted) _unlock();
                  },
                  icon: Icon(Icons.fingerprint_rounded, size: 40, color: c.accent),
                );
              },
            ),
            TextButton(
              onPressed: () => _forgot(),
              child: Text(t('pin.forgot')),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Future<bool> _bioEnabled() async {
    final repo = ref.read(pinRepositoryProvider);
    if (!await repo.biometricEnabled()) return false;
    return BiometricGate.available();
  }

  Future<void> _verify() async {
    final t = ref.read(tProvider);
    final result = await ref
        .read(pinRepositoryProvider)
        .verify(_pin, isAuthed: false);
    switch (result) {
      case PinSuccess():
        _unlock();
      case PinFailure():
        setState(() {
          _error = t('pin.wrong');
          _pin = '';
        });
      case PinLockedOut():
        setState(() {
          _locked = true;
          _error = t('pin.locked_out');
          _pin = '';
        });
        // Auto-recover after the 30s block (⛔ §6.22).
        await Future<void>.delayed(const Duration(seconds: 30));
        if (mounted) setState(() => _locked = false);
      case PinSignOut():
        setState(() {
          _error = t('pin.too_many');
          _pin = '';
        });
        // 10 fails → вихід з акаунта (⛔ §6.22): guest = local wipe.
        await ref.read(goalRepositoryProvider).wipeLocalData();
        if (mounted) context.go('/');
    }
  }

  void _unlock() {
    // HOTFIX v0.9.0+9.2: clear the app-level gate (router redirect releases
    // /pin-lock) and land on the dashboard.
    ref.read(pinGateProvider.notifier).state = false;
    context.go('/dashboard');
  }

  Future<void> _forgot() async {
    final t = ref.read(tProvider);
    final stats = await ref.read(goalRepositoryProvider).rawStats();
    if (!mounted) return;
    if (stats.authed) {
      // Гость? ні — авторизований: відновлення через email (§6.22).
      context.toast(t('pin.forgot_sent'));
    } else {
      // Гостю — попередження про локальне скидання даних (⛔ §6.22).
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(t('pin.forgot')),
          content: Text(t('pin.forgot_guest_warn')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(t('common.cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(t('common.continue')),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        await ref.read(pinRepositoryProvider).clearPin();
        await ref.read(goalRepositoryProvider).wipeLocalData();
        if (!mounted) return;
        context.go('/');
      }
    }
  }
}

/// 6.23 Biometric Prompt — exposed as gate + fallback path (documented in
/// [showProtectedActionGate] and [PinLockScreen]).
