import 'package:flutter/material.dart';
import '../../shared/widgets/motion.dart';
import '../../core/utils/format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/social_repositories.dart';
import '../../data/repositories/ui_providers.dart';
import '../../shared/widgets/widgets.dart';

/// 6.28 Live Progress Card (§10.5/§6.28): enable toggle, field toggles
/// (rank/streak/% — amount OFF by default ⛔), link + copy + QR, rotate
/// token, view counter; themed empty state when disabled.
class ProgressCardScreen extends ConsumerStatefulWidget {
  const ProgressCardScreen({super.key});

  @override
  ConsumerState<ProgressCardScreen> createState() =>
      _ProgressCardScreenState();
}

class _ProgressCardScreenState extends ConsumerState<ProgressCardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('progress_card');
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final card = ref.watch(progressCardProvider).valueOrNull;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('progress_card.title'))),
      body: card == null
          ? const SizedBox.shrink()
          : !card.enabled
              ? EmptyState(
                  title: t('progress_card.empty'),
                  body: t('progress_card.empty_body'),
                  ctaLabel: t('progress_card.enable'),
                  onCta: () async {
                    await ref.read(progressCardRepositoryProvider).setEnabled(true);
                    if (context.mounted) context.toast(t('progress_card.created'));
                  },
                  icon: Icons.share_rounded,
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Preview (§6.28 превю сторінки).
                    NeonCard(
                      accentBorder: true,
                      child: Column(
                        children: [
                          _ProgressRing(percent: ref.watch(goalProvider).valueOrNull?.percent ?? 0),
                          const SizedBox(height: 8),
                          Text(
                            t('progress_card.updated_ago', {'n': 1}),
                            style: NvType.caption(c),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: Text(t('progress_card.enable'), style: NvType.body(c)),
                      value: card.enabled,
                      onChanged: (v) async {
                        await ref.read(progressCardRepositoryProvider).setEnabled(v);
                      },
                    ),
                    _fieldToggle(c, t('progress_card.field_rank'), 'rank', card.showRank),
                    _fieldToggle(c, t('progress_card.field_streak'), 'streak', card.showStreak),
                    _fieldToggle(c, t('progress_card.field_percent'), 'percent', card.showPercent),
                    _fieldToggle(
                        c, t('progress_card.field_amount'), 'amount', card.showAmount),
                    const SizedBox(height: 12),
                    // Link + copy + QR (§6.28).
                    if (card.token != null) ...[
                      NeonCard(
                        child: Column(
                          children: [
                            Text(
                              ref.read(progressCardRepositoryProvider).publicUrl(card.token!),
                              style: NvType.caption(c).copyWith(color: c.accent),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    context.toast(t('common.copied'));
                                  },
                                  child: Text(t('progress_card.copy')),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () => showDialog<void>(
                                    context: context,
                                    builder: (ctx) => Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: QrImageView(
                                          data: ref
                                              .read(progressCardRepositoryProvider)
                                              .publicUrl(card.token!),
                                          backgroundColor: Colors.white,
                                          size: 220,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Text(t('progress_card.qr')),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(t('progress_card.rotate')),
                              content: Text(t('progress_card.rotate_confirm')),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: Text(t('common.cancel')),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: Text(t('common.confirm')),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await ref
                                .read(progressCardRepositoryProvider)
                                .rotateToken();
                            if (context.mounted) {
                              context.toast(t('progress_card.revoked'));
                            }
                          }
                        },
                        child: Text(t('progress_card.rotate')),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t('progress_card.views', {'n': card.views}),
                        style: NvType.caption(c),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
    );
  }

  Widget _fieldToggle(AppColors c, String label, String field, bool value) {
    return SwitchListTile(
      dense: true,
      title: Text(label, style: NvType.body(c)),
      value: value,
      onChanged: (v) =>
          ref.read(progressCardRepositoryProvider).setField(field: field, value: v),
    );
  }
}

/// Неонове кільце прогресу (same as public web page, §10.5).
class _ProgressRing extends ConsumerWidget {
  const _ProgressRing({required this.percent});
  final double percent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final reduced = ref.watch(reduceMotionProvider);
    final frac = (percent / 100).clamp(0.0, 1.0);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: frac),
      duration: reduced ? Duration.zero : NvMotion.slow,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => SizedBox(
        width: 120,
        height: 120,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: v,
                strokeWidth: 8,
                color: c.accent,
                backgroundColor: c.border,
              ),
            ),
            Text(
              '${(v * 100).toStringAsFixed(1)}%',
              style: NvType.h2(c).copyWith(color: c.accent),
            ),
          ],
        ),
      ),
    );
  }
}
