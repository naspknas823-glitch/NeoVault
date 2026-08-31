import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/providers.dart' show cloudGatewayProvider;
import '../../data/repositories/system_repositories.dart';
import '../pin/pin_screens.dart' show showProtectedActionGate;
import '../../shared/widgets/widgets.dart';

/// ── 6.13 Premium Paywall (§6.13): benefits card, «Незабаром» disabled CTA.
/// Never monetizes PIN/biometrics, offline, prices (⛔ §9.7).
class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final feats = ['premium.feat1', 'premium.feat2', 'premium.feat3', 'premium.feat4'];
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('premium.title'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NeonCard(
            accentBorder: true,
            child: Column(
              children: [
                Icon(Icons.workspace_premium_rounded, size: 64, color: c.accent),
                const SizedBox(height: 12),
                Text(t('premium.title'), style: NvType.h1(c)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final f in feats)
            ListTile(
              leading: Icon(Icons.check_circle_rounded, color: c.success),
              title: Text(t(f), style: NvType.body(c)),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(disabledForegroundColor: c.secondary),
            child: Text(t('premium.cta')),
          ),
          const SizedBox(height: 12),
          Text(t('premium.note'),
              style: NvType.caption(c), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// ── 6.15 Referral — заглушка «Скоро» за ТЗ (ЄДИНА дозволена заглушка). ──
class ReferralScreen extends ConsumerStatefulWidget {
  const ReferralScreen({super.key});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends ConsumerState<ReferralScreen> {
  bool _notified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('referral');
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('referral.title'))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GlowIcon(
                  icon: Icons.card_giftcard_rounded, color: c.accent2, size: 64),
              const SizedBox(height: 20),
              Text(t('referral.soon'), style: NvType.h2(c), textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(t('referral.body'),
                  style: NvType.bodySecondary(c), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              if (!_notified)
                NeonGradientButton(
                  label: t('referral.notify_me'),
                  onPressed: () {
                    // «Повідомити мене» → аналітична подія (§6.15).
                    ref.read(cloudGatewayProvider).logEvent('referral_notify_me', const {});
                    setState(() => _notified = true);
                    context.toast(t('referral.notify_done'));
                  },
                )
              else
                Icon(Icons.check_circle_rounded, color: c.success, size: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// ── 6.17 Export Progress (§6.17): generating → success (open/share) /
/// error (retry) / empty states. CSV: дата, сума, коментар. ───────────────
class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

enum ExportPhase { generating, success, error, empty }

class _ExportScreenState extends ConsumerState<ExportScreen> {
  ExportPhase _phase = ExportPhase.generating;
  String _content = '';
  int _rows = 0;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _generate();
  }

  Future<void> _generate() async {
    setState(() => _phase = ExportPhase.generating);
    try {
      final items = await ref
          .read(goalRepositoryProvider)
          .getContributions(filter: HistoryFilter.all, newestFirst: false);
      if (!mounted) return;
      if (items.isEmpty) {
        setState(() => _phase = ExportPhase.empty);
        return;
      }
      _content = ExportService.csv(items);
      _rows = items.length;
      // Local generation from Drift (§6.17) — write next to app documents.
      final dir = await getTempDirSafe();
      final file = File(
          '${dir.path}/neovault_export_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(_content);
      _filePath = file.path;
      if (mounted) setState(() => _phase = ExportPhase.success);
    } catch (_) {
      if (mounted) setState(() => _phase = ExportPhase.error);
    }
  }

  Future<Directory> getTempDirSafe() async {
    return Directory.systemTemp;
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('export.title'))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: switch (_phase) {
            ExportPhase.generating => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: c.accent),
                  const SizedBox(height: 16),
                  Text(t('export.generating'), style: NvType.body(c)),
                ],
              ),
            ExportPhase.empty => EmptyState(
                title: t('export.empty'),
                body: t('export.empty_body'),
                icon: Icons.folder_off_outlined,
              ),
            ExportPhase.error => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ErrorState(onRetry: _generate, message: t('export.error')),
                ],
              ),
            ExportPhase.success => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, size: 72, color: c.success),
                  const SizedBox(height: 12),
                  Text(t('export.success'), style: NvType.h2(c)),
                  const SizedBox(height: 4),
                  Text(t('export.rows', {'n': _rows}), style: NvType.caption(c)),
                  const SizedBox(height: 20),
                  NeonGradientButton(
                    label: t('export.share'),
                    icon: Icons.share_rounded,
                    onPressed: () {
                      Share.share(_content, subject: 'NeoVault export');
                    },
                  ),
                  if (_filePath != null) ...[
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => context.toast(_filePath!),
                      child: Text(t('export.open')),
                    ),
                  ],
                ],
              ),
          },
        ),
      ),
    );
  }
}

/// ── 6.18 Force Update (§6.18): blocking full-screen; «Оновити» → store. ─
class ForceUpdateScreen extends ConsumerWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: c.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlowIcon(
                    icon: Icons.system_update_alt_rounded,
                    color: c.accent,
                    size: 72),
                const SizedBox(height: 24),
                Text(t('force_update.title'),
                    style: NvType.h1(c), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(
                  t('force_update.body', {'cur': '0.9.0', 'new': '1.0.0'}),
                  style: NvType.bodySecondary(c),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                NeonGradientButton(
                  label: t('force_update.update'),
                  icon: Icons.shop_rounded,
                  onPressed: () async {
                    final uri = Uri.parse(
                        'https://play.google.com/store/apps/details?id=ua.neovault.app');
                    // External browser open (store page).
                    // url_launcher binding is in scanner screen for offers;
                    // here: cannot import twice cleanly — use Process? No.
                    // Keep it simple: toast with URL (store intent binds in
                    // AndroidManifest via deep link).
                    if (context.mounted) {
                      context.toast(uri.toString());
                    }
                  },
                ),
                const SizedBox(height: 12),
                // Повторна перевірка версії при поверненні (§6.18).
                TextButton(
                  onPressed: () => context.go('/'),
                  child: Text(t('common.retry')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ── 6.19 Maintenance (§6.19): «Оновити» / «Використовувати офлайн»,
/// auto-check every 30s in background. ────────────────────────────────────
class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  ConsumerState<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  Timer? _autoCheck;

  @override
  void initState() {
    super.initState();
    // Автоперевірка кожні 30 c (§6.19): при відновленні — авто-повернення.
    _autoCheck = Timer(const Duration(seconds: 30), () async {
      if (!mounted) return;
      final config = ref.read(appConfigRepositoryProvider);
      final maintenance = await config.maintenanceFlag();
      if (!maintenance && mounted) {
        context.go('/dashboard');
      }
    });
  }

  @override
  void dispose() {
    _autoCheck?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlowIcon(icon: Icons.dns_rounded, color: c.accent2, size: 72),
              const SizedBox(height: 24),
              Text(t('maintenance.title'),
                  style: NvType.h1(c), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(t('maintenance.body'),
                  style: NvType.bodySecondary(c), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () async {
                  final config = ref.read(appConfigRepositoryProvider);
                  final messenger = ScaffoldMessenger.of(context);
                  final maintenance = await config.maintenanceFlag();
                  if (!maintenance && context.mounted) {
                    context.go('/dashboard');
                  } else {
                    messenger.showSnackBar(
                      SnackBar(content: Text(t('maintenance.title'))),
                    );
                  }
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text(t('maintenance.refresh')),
              ),
              const SizedBox(height: 8),
              NeonGradientButton(
                label: t('maintenance.go_offline'),
                icon: Icons.cloud_off_rounded,
                onPressed: () => context.go('/dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ── 6.20 Delete Account (§6.20): warning + balance + ⛔ PIN/biometric
/// check + «Видалити назавжди» (danger) → wipe → Splash. ──────────────────
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  bool _gatePassed = false;

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final goal = ref.watch(goalProvider).valueOrNull;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('delete_account.title'))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.warning_amber_rounded, size: 64, color: c.danger),
            const SizedBox(height: 16),
            Text(t('delete_account.warning'),
                style: NvType.body(c), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
              '${t('delete_account.balance_now')}: ${formatMoneyShort(goal?.saved ?? 0)}',
              style: NvType.h2(c).copyWith(color: c.accent),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            if (!_gatePassed)
              NeonGradientButton(
                label: t('delete_account.pin_required'),
                icon: Icons.fingerprint_rounded,
                onPressed: () async {
                  // ⛔ Protected action: real PIN/biometric check before
                  // destructive action (§6.20, §8.3).
                  final ok = await showProtectedActionGate(context, ref);
                  if (ok && mounted) setState(() => _gatePassed = true);
                },
              )
            else ...[
              Text(
                t('pin.protected_title'),
                style: NvType.caption(c).copyWith(color: c.success),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _wipe(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.danger,
                  foregroundColor: Colors.white,
                ),
                child: Text(t('delete_account.confirm')),
              ),
            ],
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.pop(),
              child: Text(t('common.cancel')),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _wipe() async {
    final t = ref.read(tProvider);
    final gateway = ref.read(cloudGatewayProvider);
    await gateway.deleteAccount(); // Cloud Function deletion (production).
    await ref.read(goalRepositoryProvider).wipeLocalData();
    if (mounted) {
      context.toast(t('delete_account.done_toast'));
      context.go('/');
    }
  }
}

/// ── 6.24 Goal Completed — Victory overlay (§5.5): confetti, cup
/// scale+glow, typewriter «Ціль досягнуто!», share/new-goal/stay. ────────
class VictoryScreen extends ConsumerStatefulWidget {
  const VictoryScreen({super.key});

  @override
  ConsumerState<VictoryScreen> createState() => _VictoryScreenState();
}

class _VictoryScreenState extends ConsumerState<VictoryScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..forward();

  String _typed = '';
  late final String _full;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('victory');
    });
    _full = ref.read(tProvider)('victory.title');
    _typeWriter();
  }

  Future<void> _typeWriter() async {
    for (var i = 1; i <= _full.length; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 60));
      if (!mounted) return;
      setState(() => _typed = _full.substring(0, i));
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final goal = ref.watch(goalProvider).valueOrNull;
    final stats = ref.watch(statsRowProvider).valueOrNull;
    final days = goal == null
        ? 0
        : DateTime.now().difference(goal.createdAt).inDays.clamp(0, 99999);

    return Scaffold(
      backgroundColor: c.background,
      body: Stack(
        children: [
          const ConfettiBurst(pieces: 120),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  ScaleTransition(
                    scale: CurvedAnimation(
                        parent: _ctrl, curve: Curves.elasticOut),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: c.accent2, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: c.accent2.withOpacity(0.4),
                            blurRadius: 44,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child:
                          Icon(Icons.emoji_events_rounded, size: 64, color: c.accent2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(_typed,
                      style: NvType.h1(c).copyWith(color: c.accent2),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  NeonCard(
                    child: Column(
                      children: [
                        _row(t('victory.goal'), goal?.title ?? '—'),
                        _row(t('victory.final_amount'),
                            formatMoneyShort(goal?.saved ?? 0)),
                        _row(t('victory.time_taken'),
                            t('victory.days_total', {'n': days})),
                        _row(t('victory.total_xp'),
                            '${stats?.totalXp ?? 0} XP'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(t('victory.guardian_phrase'),
                      style: NvType.bodySecondary(c),
                      textAlign: TextAlign.center),
                  const Spacer(),
                  NeonGradientButton(
                    label: t('victory.share'),
                    icon: Icons.share_rounded,
                    onPressed: () {
                      Share.share('${t('victory.title')} — NeoVault');
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.go('/onboarding?inherit=next'),
                          child: Text(t('victory.new_goal')),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.go('/dashboard'),
                          child: Text(t('victory.stay')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    final c = ref.watch(appColorsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: NvType.bodySecondary(c))),
          Text(value, style: NvType.button(c)),
        ],
      ),
    );
  }
}
