import 'package:flutter/material.dart';
import '../dashboard/add_money_sheet.dart';
import '../dashboard/dashboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/scanner_repositories.dart';
import '../../data/repositories/tavily_repository.dart';
import '../../data/repositories/ui_providers.dart';
import '../../domain/prices/price_models.dart';
import '../../domain/trust/trust_score.dart';
import '../../shared/widgets/widgets.dart';

/// 6.7 Price Scanner (§6.7): two product cards (lowest/avg/change ±%),
/// «Вигідно зараз» badge, 14d/30d/3m chart, stores list with Trust Score,
/// ⛔ NO manual refresh (1 auto-scan/day at 08:00 Kyiv — button shows next
/// scan time), bundle CTA → 6.32, API status dots, offline note.
class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  int _rangeDays = 14;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final goals = ref.read(goalRepositoryProvider);
      await goals.trackScreenVisit('scanner');
      // P1–P3 achievement source + retention quest (§5.3/§10.2).
      await ref.read(scannerRepositoryProvider).recordCheck();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final ps5 = ref.watch(scanProvider('ps5'));
    final mon = ref.watch(scanProvider('monitor'));

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('scanner.title'))),
      floatingActionButton: FloatingAddMoneyButton(onTap: () async {
        final outcome = await showAddMoneySheet(context, ref);
        if (outcome != null &&
            outcome.result.goalCompleted &&
            context.mounted) {
          context.push('/victory');
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const DashboardBottomBar(currentIndex: 1),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(scanProvider('ps5'));
          ref.invalidate(scanProvider('monitor'));
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          children: [
            _NextScanHeader(),
            const SizedBox(height: 12),
            AsyncValueView<ProductScan?>(
              value: ps5,
              onRetry: () => ref.invalidate(scanProvider('ps5')),
              isEmpty: (s) => s == null || s.offers.isEmpty,
              empty: EmptyState(
                title: t('scanner.empty'),
                body: t('scanner.empty_body'),
                icon: Icons.schedule_rounded,
              ),
              content: (scan_) => _ProductCard(
                scan: scan_!,
                title: t('dashboard.ps5'),
                icon: Icons.sports_esports_rounded,
                rangeDays: _rangeDays,
                onRange: (d) => setState(() => _rangeDays = d),
              ),
            ),
            const SizedBox(height: 12),
            AsyncValueView<ProductScan?>(
              value: mon,
              onRetry: () => ref.invalidate(scanProvider('monitor')),
              isEmpty: (s) => s == null || s.offers.isEmpty,
              empty: const SizedBox.shrink(),
              content: (scan_) => _ProductCard(
                scan: scan_!,
                title: t('dashboard.monitor'),
                icon: Icons.desktop_windows_rounded,
                rangeDays: _rangeDays,
                onRange: (d) => setState(() => _rangeDays = d),
              ),
            ),
            const SizedBox(height: 12),
            // 🔍 Smart Search CTA (§7.1bis.14).
            OutlinedButton.icon(
              onPressed: () => context.push('/bundle-search'),
              icon: const Icon(Icons.travel_explore_rounded),
              label: Text(t('scanner.find_ps5_best')),
            ),
            const SizedBox(height: 8),
            // 🎮+🖥️ Bundle CTA (§6.7).
            NeonGradientButton(
              label: t('scanner.bundle_cta'),
              icon: Icons.add_shopping_cart_rounded,
              onPressed: () => context.push('/bundle-search'),
            ),
            const SizedBox(height: 16),
            _ApiStatusBlock(),
            const SizedBox(height: 12),
            const _StoresBlock(product: 'ps5'),
          ],
        ),
      ),
    );
  }
}

/// Header: last scan time + next auto-scan (⛔ no manual refresh).
class _NextScanHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final ps5 = ref.watch(scanProvider('ps5')).valueOrNull;
    final last = ps5?.scannedAt;
    final next = nextScanTime(kyivNow());
    // Live 1s tick → countdown re-renders every second (harness overrides
    // the tick with a single value so tests stay deterministic).
    ref.watch(countdownTickProvider);
    return NeonCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.radar_rounded, size: 18, color: c.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  last != null && last.millisecondsSinceEpoch > 0
                      ? t('scanner.scanned_at', {'t': formatDateTime(last)})
                      : t('scanner.empty'),
                  style: NvType.body(c),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 14, color: c.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${t('dashboard.next_scan')}: ${formatDateTime(next)} — ${t('scanner.no_refresh')}',
                  style: NvType.caption(c),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 13, color: c.accent),
              const SizedBox(width: 6),
              Text(
                t('scanner.next_scan_in',
                    {'d': formatCountdown(next.difference(kyivNow()))}),
                style: NvType.caption(c).copyWith(color: c.accent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Product card: lowest/avg/change, good-deal badge, mini chart, offers.
class _ProductCard extends ConsumerWidget {
  const _ProductCard({
    required this.scan,
    required this.title,
    required this.icon,
    required this.rangeDays,
    required this.onRange,
  });

  final ProductScan scan;
  final String title;
  final IconData icon;
  final int rangeDays;
  final ValueChanged<int> onRange;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final changeColor = switch (scan.changeDir) {
      PriceChangeDir.down => c.success,
      PriceChangeDir.up => c.danger,
      PriceChangeDir.flat => c.secondary,
    };
    final changeArrow = switch (scan.changeDir) {
      PriceChangeDir.down => '▼',
      PriceChangeDir.up => '▲',
      PriceChangeDir.flat => '➔',
    };
    // Best offer in the list + saving vs the 30d average (real math).
    final cheapest = scan.offers.isEmpty
        ? null
        : scan.offers.reduce((a, b) => a.price <= b.price ? a : b);
    final saving30d = scan.avg30dPrice - scan.lowestPrice;

    return NeonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: c.accent),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: NvType.h2(c).copyWith(fontSize: 17))),
              if (scan.isGoodDealNow)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: c.success),
                  ),
                  child: Text(
                    t('scanner.badge_good'),
                    style: NvType.caption(c).copyWith(color: c.success),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t('scanner.lowest'), style: NvType.caption(c)),
                  Text(
                    formatMoneyShort(scan.lowestPrice),
                    style: NvType.amount(c, size: 24).copyWith(color: c.accent),
                  ),
                  if (saving30d > 0)
                    Text(
                      t('scanner.vs_avg30d', {'a': formatMoneyShort(saving30d)}),
                      style: NvType.caption(c).copyWith(color: c.success),
                    ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t('scanner.average'), style: NvType.caption(c)),
                  Text(formatMoneyShort(scan.averagePrice), style: NvType.body(c)),
                ],
              ),
              const Spacer(),
              Text(
                '$changeArrow ${scan.changePercent.toStringAsFixed(1)}%',
                style: NvType.button(c).copyWith(color: changeColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _HistoryPreview(product: scan.product, days: rangeDays),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final d in [14, 30, 90])
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(d == 90
                        ? t('scanner.range_3m')
                        : d == 30
                            ? t('scanner.range_30d')
                            : t('scanner.range_14d')),
                    selected: rangeDays == d,
                    onSelected: (_) => onRange(d),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ...scan.offers.take(3).map(
                (o) => _OfferRow(offer: o, isCheapest: identical(o, cheapest)),
              ),
          if (scan.offers.any((o) => o.isStale))
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  const StatusDot(level: TrustDotLevel.yellow),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(t('scanner.price_stale'), style: NvType.caption(c)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HistoryPreview extends ConsumerWidget {
  const _HistoryPreview({required this.product, required this.days});
  final String product;
  final int days;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    return FutureBuilder<List<PricePoint>>(
      future: ref.watch(scannerRepositoryProvider).history(product, days: days),
      builder: (context, snap) {
        final points = snap.data ?? const [];
        if (points.length < 2) return const SizedBox(height: 8);
        final values = points.map((p) => p.price.toDouble()).toList();
        return SizedBox(
          height: 48,
          width: double.infinity,
          child: CustomPaint(
            painter: _SparkPainter(
              values: values,
              color: c.accent,
              color2: c.accent2,
            ),
          ),
        );
      },
    );
  }
}

class _SparkPainter extends CustomPainter {
  _SparkPainter({required this.values, required this.color, required this.color2});
  final List<double> values;
  final Color color;
  final Color color2;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final dy = maxV == minV ? 1.0 : maxV - minV;
    final dx = (values.length - 1).toDouble();
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = i / dx * size.width;
      final y = size.height - ((values[i] - minV) / dy) * (size.height - 6) - 3;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final paint = Paint()
      ..shader = LinearGradient(colors: [color, color2]).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparkPainter old) => old.values != values;
}

/// Store row: name, price, availability, Trust Score dot, «Перейти» (URL ⛔
/// verified-only), 🟡 needs-verification tag for seed rows.
class _OfferRow extends ConsumerWidget {
  const _OfferRow({required this.offer, this.isCheapest = false});
  final PriceOffer offer;
  final bool isCheapest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final trust = TrustCalculator.fromOffer(offer);
    final dot = switch (trust.level) {
      TrustLevel.high => TrustDotLevel.green,
      TrustLevel.medium => TrustDotLevel.yellow,
      TrustLevel.low => TrustDotLevel.red,
    };
    final availLabel = switch (offer.availability) {
      Availability.inStock => t('scanner.in_stock'),
      Availability.onOrder => t('scanner.on_order'),
      Availability.outOfStock => t('scanner.out_of_stock'),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          StatusDot(level: dot),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        offer.storeName,
                        style: NvType.body(c),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCheapest) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: c.accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          t('scanner.best_offer'),
                          style: NvType.caption(c).copyWith(color: c.accent),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  offer.isStale
                      ? t('scanner.price_stale')
                      : offer.urlVerified
                          ? t('scanner.verified')
                          : t('scanner.source_unverified'),
                  style: NvType.caption(c),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatMoneyShort(offer.price), style: NvType.button(c)),
              Text(availLabel, style: NvType.caption(c)),
            ],
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: offer.urlVerified ? () => _open(context, offer.url) : null,
            child: Text(t('scanner.go')),
          ),
        ],
      ),
    );
  }

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// API status block (§7.1quin.6): 🟢 Rozetka | 🟢 Foxtrot | …
class _ApiStatusBlock extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final hasTavily = ref.watch(tavilyHasKeyProvider).valueOrNull ?? false;
    const stores = ['rozetka', 'foxtrot', 'compx', 'citrus', 'eldorado'];
    return NeonCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t('scanner.api_status'), style: NvType.button(c).copyWith(fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              for (final s in stores)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const StatusDot(level: TrustDotLevel.yellow),
                    const SizedBox(width: 5),
                    Text(
                      '${s[0].toUpperCase()}${s.substring(1)}',
                      style: NvType.caption(c),
                    ),
                  ],
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusDot(level:
                      hasTavily ? TrustDotLevel.green : TrustDotLevel.grey),
                  const SizedBox(width: 5),
                  Text('Tavily', style: NvType.caption(c)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoresBlock extends ConsumerWidget {
  const _StoresBlock({required this.product});
  final String product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scan = ref.watch(scanProvider(product)).valueOrNull;
    if (scan == null) return const SizedBox.shrink();
    final cheapest = scan.offers.isEmpty
        ? null
        : scan.offers.reduce((a, b) => a.price <= b.price ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final o in scan.offers)
          _OfferRow(offer: o, isCheapest: identical(o, cheapest)),
      ],
    );
  }
}
