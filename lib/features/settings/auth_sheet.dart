import 'package:flutter/material.dart';
import '../../core/utils/format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/providers.dart';
import '../../shared/widgets/widgets.dart';

/// 6.14 Auth (§6.14): modal bottom sheet — Login/Register tabs + Google
/// OAuth button + forgot password. ⛔ Guest migration: Local-First Merge —
/// local rows are ADDED to the cloud profile with original timestamps;
/// overwriting cloud data is forbidden; local data loss = critical bug.
Future<void> showAuthSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(kSheetRadius)),
    ),
    builder: (_) => const _AuthSheet(),
  );
}

class _AuthSheet extends ConsumerStatefulWidget {
  const _AuthSheet();

  @override
  ConsumerState<_AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends ConsumerState<_AuthSheet> {
  bool _register = false;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nickCtrl = TextEditingController();
  bool _agree = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nickCtrl.dispose();
    super.dispose();
  }

  String? _validate(String Function(String, [Map<String, Object?>]) translate) {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return translate('auth.error_email');
    }
    if (pass.length < 6) return translate('auth.error_password');
    if (_register) {
      final nick = _nickCtrl.text.trim();
      if (nick.length < 2 || nick.length > 24) return translate('auth.error_nickname');
      if (!_agree) return translate('auth.error_agree');
    }
    return null;
  }

  Future<void> _submit() async {
    final t = ref.read(tProvider);
    final err = _validate(t);
    if (err != null) {
      setState(() => _error = err);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });

    // ⛔ Before switching accounts: enqueue local data for migration
    // (Local-First Merge — nothing is overwritten, nothing lost).
    final goals = ref.read(goalRepositoryProvider);
    final migrated = await goals.prepareGuestMigration();

    final gateway = ref.read(cloudGatewayProvider);
    final result = _register
        ? await gateway.register(
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text,
            nickname: _nickCtrl.text.trim(),
          )
        : await gateway.signIn(
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text,
          );

    if (!mounted) return;
    if (!result.success) {
      setState(() {
        _busy = false;
        _error = t('auth.${result.error ?? 'offline_reg'}');
      });
      return;
    }
    await goals.setAccount(email: _emailCtrl.text.trim(), authed: true);
    if (_register) await goals.setNickname(_nickCtrl.text.trim());
    if (mounted) {
      context.toast(
        '${t('auth.welcome', {'nick': _nickCtrl.text.trim()})}'
        ' • ${t('auth.merged', {'n': migrated})}',
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _forgot() async {
    final t = ref.read(tProvider);
    final gateway = ref.read(cloudGatewayProvider);
    await gateway.sendPasswordReset(_emailCtrl.text.trim());
    if (mounted) {
      context.toast(t('auth.forgot_sent', {'email': _emailCtrl.text.trim()}));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        // ⛔ TabBar inside a modal bottom sheet needs its OWN
        // DefaultTabController: the sheet lives on a different route, so no
        // controller from the page behind is visible here (crashed on device
        // with «No TabController for TabBar» — HOTFIX v0.9.0+9.2).
        child: DefaultTabController(
          length: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TabBar(
                tabs: [
                  Tab(text: t('auth.tab_login')),
                  Tab(text: t('auth.tab_register')),
                ],
                onTap: (i) => setState(() => _register = i == 1),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: t('auth.email')),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: InputDecoration(labelText: t('auth.password')),
              ),
              if (_register) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _nickCtrl,
                  decoration: InputDecoration(labelText: t('auth.nickname')),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(t('auth.agree'), style: NvType.caption(c)),
                  value: _agree,
                  onChanged: (v) => setState(() => _agree = v ?? false),
                ),
              ],
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _forgot,
                  child: Text(t('auth.forgot')),
                ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_error!,
                      style: NvType.caption(c).copyWith(color: c.danger)),
                ),
              NeonGradientButton(
                label: _busy
                    ? t('common.loading')
                    : _register
                        ? t('auth.register')
                        : t('auth.login'),
                onPressed: _busy ? null : _submit,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.toast(t('auth.google')),
                icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                label: Text(t('auth.google')),
              ),
              const SizedBox(height: 8),
              Text(t('auth.migrate_note'), style: NvType.caption(c),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
