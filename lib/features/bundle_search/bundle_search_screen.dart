import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/ui_providers.dart';
import '../../domain/bundle/bundle_models.dart';
import '../../domain/prices/price_models.dart';
import '../../shared/widgets/widgets.dart';

/// 6.32 Bundle Search (§7.1ter.16 — ONE SCREEN INTERFACE ⛔): ALL core
/// info on one screen — budget, recommendation w/ status, PS5 + monitor
/// cards, compatibility, cost breakdown, 3 variants (collapsible), why,
/// decision, previous-result comparison, store buttons.
class BundleSearchScreen extends ConsumerStatefulWidget {
  const BundleSearchScreen({super.key});

  @override
  ConsumerState<BundleSearchScreen> createState() => _BundleSearchScreenState();
}

class _BundleSearchScreenState extends ConsumerState<BundleSearchScreen> {
  int _stage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('bundle_search');
      // Loader stages (§7.1ter.15): анімовані етапи пошуку.
      _runStages();
    });
  }

  Future<void> _runStages() async {
    for (var i = 1; i <= 5; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 420));
      if (!mounted) return;
      setState(() => _stage = i);
    }
    ref.invalidate(bundleResultProvider);
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final result = ref.watch(bundleResultProvider).valueOrNull;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(t('bundle.title')),
        actions: [
          IconButton(
            onPressed: () => _filtersDialog(context),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: _stage < 5
          ? _SearchStages(stage: _stage)
          : result == null
              ? EmptyState(
                  title: t('bundle.empty'),
                  body: t('bundle.empty_body'),
                  icon: Icons.inventory_2_outlined,
                )
              : _OneScreenResult(result: result),
    );
  }

  void _filtersDialog(BuildContext context) {
    final t = ref.read(tProvider);
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(t('bundle.filters')),
        children: [
          for (final key in ['bundle.priority_120', 'bundle.priority_budget', 'bundle.priority_quality'])
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text(t(key)),
            ),
        ],
      ),
    );
  }
}

/// Loader stages 1–5 (§7.1ter.16.5).
class _SearchStages extends ConsumerWidget {
  const _SearchStages({required this.stage});
  final int stage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final stages = [
      'bundle.stage1',
      'bundle.stage2',
      'bundle.stage3',
      'bundle.stage4',
      'bundle.stage5',
    ];
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: c.accent),
          const SizedBox(height: 20),
          Text(t('bundle.searching'), style: NvType.h2(c)),
          const SizedBox(height: 16),
          for (var i = 0; i < stages.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    i < stage
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked,
                    size: 16,
                    color: i < stage ? c.success : c.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(t(stages[i]), style: NvType.bodySecondary(c)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// THE ONE SCREEN (§7.1ter.16): every required element visible here.
class _OneScreenResult extends ConsumerWidget {
  const _OneScreenResult({required this.result});
  final BundleResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final b = result.recommended;
    final compat = b.compatibility;
    final statusColor = switch (b.status) {
      BundleStatus.green => c.success,
      BundleStatus.yellow => const Color(0xFFFFD23F),
      BundleStatus.orange => const Color(0xFFFF9F43),
      BundleStatus.red => c.danger,
    };
    final statusLabel = switch (b.status) {
      BundleStatus.green => t('bundle.status_green'),
      BundleStatus.yellow => t('bundle.status_yellow'),
      BundleStatus.orange => t('bundle.status_orange'),
      BundleStatus.red => t('bundle.status_red'),
    };
    final left = result.leftover;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Заголовок + бюджет (§7.1ter.16.1) ──
        NeonCard(
          child: Row(
            children: [
              const Text('🎮+🖥️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(t('bundle.title'), style: NvType.h2(c).copyWith(fontSize: 16)),
              ),
              Text(
                '${t('bundle.budget')}: ${formatMoneyShort(result.budget)}',
                style: NvType.button(c).copyWith(color: c.accent, fontSize: 13),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── РЕКОМЕНДАЦІЯ — завжди видима (§7.1ter.16.1) ──
        NeonCard(
          accentBorder: true,
          breathing: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🏆 ${t('bundle.recommendation')}',
                  style: NvType.caption(c).copyWith(color: c.accent)),
              const SizedBox(height: 6),
              Text(b.name, style: NvType.h2(c).copyWith(fontSize: 18)),
              const SizedBox(height: 6),
              Text(
                '${t('bundle.full_price')}: ${formatMoneyShort(b.totalPrice)}',
                style: NvType.amount(c, size: 22).copyWith(color: c.accent),
              ),
              Text(
                left >= 0
                    ? '${t('bundle.left')}: ${formatMoneyShort(left)}'
                    : '${t('bundle.shortage')}: ${formatMoneyShort(-left)}',
                style: NvType.body(c).copyWith(
                  color: left >= 0 ? c.success : c.danger,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  '🎯 $statusLabel',
                  style: NvType.button(c).copyWith(color: statusColor, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── PS5 + Монітор картки (§7.1ter.16.1) ──
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _Ps5Card(ps5: b.ps5)),
            const SizedBox(width: 10),
            Expanded(child: _MonitorCard(monitor: b.monitor)),
          ],
        ),
        const SizedBox(height: 10),

        // ── СУМІСНІСТЬ (§7.1ter.16.1) ──
        NeonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔍 ${t('bundle.compat')}: ${compat.score}/100',
                style: NvType.button(c).copyWith(color: c.accent),
              ),
              const SizedBox(height: 6),
              Text(
                '${t('bundle.hdmi21')}: ${_yesNo(compat.hdmi21)}   '
                '${t('bundle.hz')}: ${_hzMark(compat.hz120Supported)}',
                style: NvType.bodySecondary(c),
              ),
              Text(
                'VRR: ${_yesNo(compat.vrr)}   HDR: ${_yesNo(compat.hdr)}   '
                '${t('bundle.hz_4k60')}: ${_yesNo(compat.hz4k60)}   ALLM: ${_yesNo(compat.allm)}',
                style: NvType.bodySecondary(c),
              ),
              Text(
                '${t('bundle.compat_score')}: ${compat.realModeLabel}',
                style: NvType.caption(c).copyWith(color: c.accent2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── ВАРТІСТЬ КОМПЛЕКТУ (§7.1ter.16.1) ──
        NeonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('💰 ${t('bundle.cost')}', style: NvType.button(c).copyWith(color: c.accent)),
              const SizedBox(height: 6),
              _costRow(c, t('dashboard.ps5'), formatMoneyShort(b.ps5.base.fullCost)),
              _costRow(c, t('dashboard.monitor'), formatMoneyShort(b.monitor.base.fullCost)),
              _costRow(c, t('bundle.delivery_ps5'), formatMoneyShort(b.ps5.base.deliveryCost)),
              _costRow(c, t('bundle.delivery_mon'), formatMoneyShort(b.monitor.base.deliveryCost)),
              const Divider(height: 12),
              _costRow(c, t('common.total'), formatMoneyShort(b.totalPrice), bold: true),
              _costRow(c, t('bundle.budget_line'), formatMoneyShort(result.budget)),
              _costRow(
                c,
                left >= 0 ? t('bundle.left_ok') : t('bundle.shortage'),
                formatMoneyShort(left.abs()),
                bold: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── 3 ВАРІАНТИ (collapsible, §7.1ter.16) ──
        _VariantsSection(result: result),
        const SizedBox(height: 10),

        // ── ПОЯСНЕННЯ (§7.1ter.16.1) ──
        NeonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📝 ${t('bundle.why')}', style: NvType.button(c).copyWith(color: c.accent)),
              const SizedBox(height: 6),
              Text(result.decisionBuy
                      ? '${t('bundle.decision')}: ${t('bundle.decision_buy')}'
                      : '${t('bundle.decision')}: ${t('bundle.decision_wait')}',
                  style: NvType.body(c).copyWith(
                    color: result.decisionBuy ? c.success : c.danger,
                  )),
              const SizedBox(height: 4),
              Text(result.explanation, style: NvType.bodySecondary(c)),
              if (result.whyNotReasons.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t('bundle.why_not_title'),
                          style: NvType.caption(c).copyWith(color: c.danger)),
                      for (final r in result.whyNotReasons)
                        Text('• $r', style: NvType.caption(c)),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // ── ПОПЕРЕДНІЙ РЕЗУЛЬТАТ (§7.1sept) ──
        if (result.previous != null)
          NeonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('📊 ${t('bundle.prev_result')}',
                    style: NvType.button(c).copyWith(color: c.accent)),
                const SizedBox(height: 6),
                _costRow(c, t('bundle.prev_best'),
                    formatMoneyShort(result.previous!.totalPrice)),
                _costRow(c, t('bundle.new_best'), formatMoneyShort(b.totalPrice)),
                if (result.savings != null)
                  _costRow(
                    c,
                    t('bundle.savings'),
                    formatMoneyShort(result.savings!),
                  ),
                Text(
                  '${t('bundle.rec_changed')}: ${result.recommendationChanged ? t('bundle.rec_yes') : t('bundle.rec_no')}',
                  style: NvType.caption(c),
                ),
              ],
            ),
          ),

        const SizedBox(height: 12),

        // ── Кнопки магазинів (§7.1ter.17.4) ──
        Row(
          children: [
            Expanded(
              child: _StoreButton(
                label: t('bundle.open_ps5'),
                url: b.ps5.base.url,
                verified: b.ps5.base.urlVerified,
                fallback: t('scanner.source_unverified'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StoreButton(
                label: t('bundle.open_monitor'),
                url: b.monitor.base.url,
                verified: b.monitor.base.urlVerified,
                fallback: t('scanner.source_unverified'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _costRow(AppColors c, String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: NvType.bodySecondary(c))),
          Text(
            value,
            style: bold
                ? NvType.button(c).copyWith(color: c.accent)
                : NvType.body(c),
          ),
        ],
      ),
    );
  }

  String _yesNo(bool v) => v ? '✅' : '❌';

  String _hzMark(Hz120Support s) => switch (s) {
        Hz120Support.full => '✅',
        Hz120Support.partial => '⚠️',
        Hz120Support.no => '❌',
      };
}

class _Ps5Card extends ConsumerWidget {
  const _Ps5Card({required this.ps5});
  final Ps5Offer ps5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return NeonCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🎮 ${t('bundle.ps5_section')}',
              style: NvType.button(c).copyWith(color: c.accent, fontSize: 12)),
          const SizedBox(height: 6),
          _line(c, '${t('bundle.type')}: ${ps5.consoleType == ConsoleType.digital ? t('bundle.digital') : t('bundle.disc')}'),
          _line(c, '1 TB • ${t('bundle.state')}: ${t('bundle.state_new')}'),
          _line(c, '📍 ${ps5.base.storeName}'),
          _line(c, formatMoneyShort(ps5.base.price)),
          _line(c, '🛡️ ${t('trust.warranty')}: ${ps5.base.warrantyMonths} ${t('trust.warranty')}'),
          _line(
            c,
            '✅ ${ps5.base.availability == Availability.inStock ? t('scanner.in_stock') : t('scanner.on_order')}',
          ),
          _line(
            c,
            '⏰ ${formatDateTime(ps5.base.checkedAt)}',
          ),
        ],
      ),
    );
  }

  Widget _line(AppColors c, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Text(text, style: NvType.caption(c), maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

class _MonitorCard extends ConsumerWidget {
  const _MonitorCard({required this.monitor});
  final MonitorOffer monitor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final compat = checkCompatibility(monitor);
    return NeonCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🖥️ ${monitor.model}',
              style: NvType.button(c).copyWith(color: c.accent, fontSize: 11)),
          const SizedBox(height: 6),
          _line(c, '📐 ${monitor.diagonalInches.toStringAsFixed(0)}" • ${_res(monitor.resolution)}'),
          _line(c, '🔄 ${monitor.refreshHz} ${t('common.hrz')} • 🔌 HDMI ${_hdmi(monitor.hdmiVersion)}'),
          _line(c, '🎮 120Hz: ${_hz(compat.hz120Supported)}'),
          _line(c, '⚡ VRR: ${monitor.hasVrr ? '✅' : '❌'} • 🌈 HDR: ${monitor.hdr != HdrSupport.none ? '✅' : '❌'}'),
          _line(c, '📍 ${monitor.base.storeName}'),
          _line(c, formatMoneyShort(monitor.base.price)),
          _line(c, '🛡️ ${monitor.base.warrantyMonths} міс'),
        ],
      ),
    );
  }

  String _res(MonitorResolution r) => switch (r) {
        MonitorResolution.r4k => '4K',
        MonitorResolution.r1440p => '1440p',
        MonitorResolution.r1080p => '1080p',
      };

  String _hdmi(int v) => v >= 21 ? '2.1' : v >= 20 ? '2.0' : '1.4';

  String _hz(Hz120Support s) => switch (s) {
        Hz120Support.full => '✅',
        Hz120Support.partial => '⚠️',
        Hz120Support.no => '❌',
      };

  Widget _line(AppColors c, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Text(text, style: NvType.caption(c), maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

/// 3 variants — collapsible sections (allowed ⛔-safe pattern §7.1ter.16.4).
class _VariantsSection extends ConsumerWidget {
  const _VariantsSection({required this.result});
  final BundleResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return NeonCard(
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(
          '📊 ${t('bundle.variants')}',
          style: NvType.button(c).copyWith(fontSize: 14),
        ),
        subtitle: Text(
          '${t('bundle.variant_cheap')} • ${t('bundle.variant_optimal')} • ${t('bundle.variant_best')}',
          style: NvType.caption(c),
        ),
        children: [
          _variantTile(c, t('bundle.variant_cheap'), result.variants.cheapest, t),
          _variantTile(c, t('bundle.variant_optimal'), result.variants.optimal, t),
          _variantTile(c, t('bundle.variant_best'), result.variants.best, t),
        ],
      ),
    );
  }

  Widget _variantTile(AppColors c, String label, Bundle b, String Function(String, [Map<String, Object?>]) t) {
    return ListTile(
      dense: true,
      title: Text('$label — ${b.name}', style: NvType.body(c), maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${formatMoneyShort(b.totalPrice)} • ${t('bundle.score')} ${b.score}/100',
        style: NvType.caption(c),
      ),
      trailing: Text(
        switch (b.status) {
          BundleStatus.green => '🟢',
          BundleStatus.yellow => '🟡',
          BundleStatus.orange => '🟠',
          BundleStatus.red => '🔴',
        },
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class _StoreButton extends ConsumerWidget {
  const _StoreButton({
    required this.label,
    required this.url,
    required this.verified,
    required this.fallback,
  });
  final String label;
  final String url;
  final bool verified;
  final String fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return OutlinedButton(
      onPressed: !verified || url.isEmpty
          ? () => context.toast(t('scanner.source_unverified'))
          : () async {
              final uri = Uri.tryParse(url);
              if (uri != null) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
      style: OutlinedButton.styleFrom(
        foregroundColor: verified ? c.accent : c.secondary,
        side: BorderSide(color: verified ? c.accent : c.border),
      ),
      child: Text(
        verified ? label : t('scanner.source_unverified'),
        style: const TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
        maxLines: 2,
      ),
    );
  }
}
