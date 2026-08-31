import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/goal_repository.dart';
import '../../shared/widgets/widgets.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';

/// (23) Savings curve — cumulative chart (fl_chart-free version via CustomPaint).
class SavingsCurveScreen extends ConsumerWidget {
  const SavingsCurveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: const Text('Savings Curve (23)')),
      body: FutureBuilder<List<(DateTime, int)>>(
        future: ref.read(goalRepositoryProvider).cumulativeCurve(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return Center(
              child: Text('No contributions yet.',
                  style: TextStyle(color: c.secondary)),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: NeonCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Savings Over Time',
                      style: TextStyle(
                          color: c.text,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    'Total: ${formatMoneyShort(data.last.$2)} ₴',
                    style: TextStyle(color: c.accent, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: CustomPaint(
                      size: const Size(double.infinity, 200),
                      painter: _CurvePainter(data: data, color: c.accent),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDate(data.first.$1),
                          style: TextStyle(color: c.secondary, fontSize: 11)),
                      Text(formatDate(data.last.$1),
                          style: TextStyle(color: c.secondary, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  const _CurvePainter({required this.data, required this.color});
  final List<(DateTime, int)> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = data.last.$2.toDouble();
    if (maxVal <= 0) return;

    final firstMs = data.first.$1.millisecondsSinceEpoch.toDouble();
    final lastMs = data.last.$1.millisecondsSinceEpoch.toDouble();
    final timeRange = (lastMs - firstMs).clamp(1.0, double.infinity);

    // Gradient fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.4), color.withValues(alpha: 0.02)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset toOffset((DateTime, int) point) {
      final xFrac = (point.$1.millisecondsSinceEpoch - firstMs) / timeRange;
      final yFrac = point.$2 / maxVal;
      return Offset(xFrac * size.width, (1 - yFrac) * size.height);
    }

    final linePath = Path();
    final fillPath = Path();

    final first = toOffset(data.first);
    linePath.moveTo(first.dx, first.dy);
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(first.dx, first.dy);

    for (int i = 1; i < data.length; i++) {
      final pt = toOffset(data[i]);
      linePath.lineTo(pt.dx, pt.dy);
      fillPath.lineTo(pt.dx, pt.dy);
    }

    final last = toOffset(data.last);
    fillPath.lineTo(last.dx, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);

    // Dots at each point
    final dotPaint = Paint()..color = color;
    for (final point in data) {
      canvas.drawCircle(toOffset(point), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_CurvePainter old) => data != old.data;
}
