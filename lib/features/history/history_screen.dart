import 'package:flutter/material.dart';
import '../dashboard/add_money_sheet.dart';
import '../dashboard/dashboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/ui_providers.dart';
import '../../shared/widgets/widgets.dart';
import 'detail_sheet.dart';

/// 6.5 History (§6.5): day-grouped list, filters, search, sort, neon
/// cumulative chart, menu (CSV export), Kinetic Lists stagger (§4.5.7).
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('history');
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final query = ref.watch(historyQueryProvider);
    final items = ref.watch(historyProvider);
    final curve = ref.watch(cumulativeCurveProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(t('history.title')),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'csv') context.push('/export');
              if (v == 'sort') {
                ref.read(historyQueryProvider.notifier).state =
                    query.copyWith(newestFirst: !query.newestFirst);
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(value: 'csv', child: Text(t('history.export_csv'))),
              PopupMenuItem(
                value: 'sort',
                child: Text(query.newestFirst
                    ? t('history.sort_oldest')
                    : t('history.sort_newest')),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingAddMoneyButton(onTap: () async {
        final outcome = await showAddMoneySheet(context, ref);
        if (outcome != null &&
            outcome.result.goalCompleted &&
            context.mounted) {
          context.push('/victory');
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const DashboardBottomBar(currentIndex: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                for (final f in HistoryFilter.values) ...[
                  ChoiceChip(
                    label: Text(t('history.filter_${f.name}')),
                    selected: query.filter == f,
                    onSelected: (_) =>
                        ref.read(historyQueryProvider.notifier).state =
                            query.copyWith(filter: f),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              onChanged: (v) =>
                  ref.read(historyQueryProvider.notifier).state =
                      query.copyWith(search: v),
              decoration: InputDecoration(
                hintText: t('history.search_hint'),
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
          ),
          // Кінематографічний графік динаміки (§6.5).
          SizedBox(
            height: 120,
            child: curve.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: SkeletonBox(height: 80, width: double.infinity),
              ),
              error: (e, st) => ErrorState(onRetry: () {}),
              data: (points) => points.length < 2
                  ? const SizedBox.shrink()
                  : _NeonChart(points: points),
            ),
          ),
          Expanded(
            child: AsyncValueView<List<ContributionView>>(
              value: items,
              isEmpty: (list) => list.isEmpty,
              empty: EmptyState(
                title: t('history.empty'),
                body: t('history.empty_cta'),
                icon: Icons.inbox_rounded,
              ),
              content: (list) => ListView.builder(
                padding: const EdgeInsets.only(bottom: 96),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final item = list[i];
                  final showDayHeader = i == 0 ||
                      kyivDateKey(list[i - 1].occurredAt) !=
                          kyivDateKey(item.occurredAt);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDayHeader)
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16, 14, 16, 6),
                          child: Text(
                            _dayLabel(item.occurredAt, t),
                            style: NvType.button(c).copyWith(
                                  fontSize: 13,
                                  color: c.accent,
                                ),
                          ),
                        ),
                      _ContributionTile(item: item, index: i),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _dayLabel(DateTime d, String Function(String, [Map<String, Object?>]) t) {
    final today = kyivDateKey();
    if (kyivDateKey(d) == today) return t('common.today');
    if (kyivDateKey(d) ==
        kyivDateKey(DateTime.now().subtract(const Duration(days: 1)))) {
      return t('common.yesterday');
    }
    return formatDate(d);
  }
}

class _ContributionTile extends ConsumerWidget {
  const _ContributionTile({required this.item, required this.index});
  final ContributionView item;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final hh = item.occurredAt.hour.toString().padLeft(2, '0');
    final mm = item.occurredAt.minute.toString().padLeft(2, '0');
    // Kinetic Lists: stagger 30ms (§4.5.7), reduced-motion safe.
    final reduced = ref.watch(reduceMotionProvider);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: reduced ? Duration.zero : Duration(milliseconds: 220 + index * 30),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Transform.translate(
        offset: Offset(0, reduced ? 0 : 12 * (1 - v)),
        child: Opacity(opacity: v, child: child),
      ),
      child: ListTile(
        onTap: () => showTransactionDetailSheet(context, ref, item.id),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: c.success.withOpacity(0.5)),
          ),
          child: Icon(Icons.add_rounded, color: c.success, size: 18),
        ),
        title: Text(
          '+${formatMoney(item.amount.toDouble())}',
          style: NvType.button(c).copyWith(color: c.success),
        ),
        subtitle: Text(
          item.comment == null ? '$hh:$mm' : '$hh:$mm • ${item.comment}',
          style: NvType.caption(c),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          '+${item.xpEarned} ${t('history.xp_short')}',
          style: NvType.caption(c).copyWith(color: c.accent),
        ),
      ),
    );
  }
}

/// Neon gradient line chart (fl_chart) — savings curve.
class _NeonChart extends ConsumerWidget {
  const _NeonChart({required this.points});
  final List<(DateTime, int)> points;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpotFactory.at(i.toDouble(), points[i].$2.toDouble()),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: CustomPaint(
        size: Size.infinite,
        painter: _NeonLinePainter(
          values: spots.map((s) => s.y).toList(),
          color: c.accent,
          color2: c.accent2,
          border: c.border,
        ),
      ),
    );
  }
}

abstract final class FlSpotFactory {
  static FlSpotLike at(double x, double y) => FlSpotLike(x, y);
}

class FlSpotLike {
  const FlSpotLike(this.x, this.y);
  final double x;
  final double y;
}

/// Lightweight neon line painter (no external chart dep needed here).
class _NeonLinePainter extends CustomPainter {
  _NeonLinePainter({
    required this.values,
    required this.color,
    required this.color2,
    required this.border,
  });

  final List<double> values;
  final Color color;
  final Color color2;
  final Color border;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    const minX = 0.0;
    final maxX = (values.length - 1).toDouble();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final dx = maxX == minX ? 1.0 : maxX - minX;
    final dy = maxY == minY ? 1.0 : maxY - minY;

    Offset map(int i) => Offset(
          (i / dx) * size.width,
          size.height - ((values[i] - minY) / dy) * (size.height - 8) - 4,
        );

    final path = Path()..moveTo(map(0).dx, map(0).dy);
    for (var i = 1; i < values.length; i++) {
      path.lineTo(map(i).dx, map(i).dy);
    }

    final gradient = Paint()
      ..shader = LinearGradient(colors: [color, color2]).createShader(
        Offset.zero & size,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Glow pass.
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawPath(path, gradient);
  }

  @override
  bool shouldRepaint(covariant _NeonLinePainter old) => old.values != values;
}
