import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../shared/widgets/widgets.dart';

class ToolsScreen extends ConsumerStatefulWidget {
  const ToolsScreen({super.key});

  @override
  ConsumerState<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends ConsumerState<ToolsScreen> {
  final _priceCtrl = TextEditingController(text: '10000');
  double _inflationRate = 1.0; // % per month

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: const Text('Tools & Utilities')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionTitle('Cost of Waiting Calculator (21)', c),
            NeonCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('See how much you lose by delaying your purchase due to inflation/price hikes.'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Current Price (₴)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  Text('Expected Monthly Price Growth: ${_inflationRate.toStringAsFixed(1)}%'),
                  Slider(
                    value: _inflationRate,
                    min: 0,
                    max: 10,
                    activeColor: c.accent,
                    onChanged: (v) => setState(() => _inflationRate = v),
                  ),
                  const SizedBox(height: 16),
                  _buildCostRow('Wait 3 months', 3, c),
                  _buildCostRow('Wait 6 months', 6, c),
                  _buildCostRow('Wait 12 months', 12, c),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle('Comparison with Median (22)', c),
            NeonCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Compare your saving habits with the community.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<num>(
                    future: _getSavingsPace(),
                    builder: (context, snapshot) {
                      final pace = snapshot.data ?? 0;
                      const medianPace = 2500; // Mock median pace
                      final percentile = pace > medianPace ? 85 : 40;
                      final color = pace >= medianPace ? c.success : c.accent;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Your Pace:', style: NvType.body(c)),
                              Text('${formatMoneyShort(pace)} / mo', style: NvType.button(c)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Community Median:', style: NvType.body(c)),
                              Text('${formatMoneyShort(medianPace)} / mo', style: NvType.button(c)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: color.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.insights_rounded, color: color),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'You save faster than $percentile% of users!',
                                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, AppColors c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        title,
        style: TextStyle(color: c.secondary, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildCostRow(String label, int months, AppColors c) {
    final price = int.tryParse(_priceCtrl.text) ?? 0;
    if (price <= 0) return const SizedBox();

    double futurePrice = price * 1.0;
    for (int i = 0; i < months; i++) {
      futurePrice += futurePrice * (_inflationRate / 100);
    }
    final diff = futurePrice - price;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: NvType.body(c)),
          Text('+ ${formatMoneyShort(diff)} ₴', style: TextStyle(color: c.danger, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<num> _getSavingsPace() async {
    final repo = ref.read(goalRepositoryProvider);
    final goal = await repo.getGoal();
    if (goal == null) return 0;
    final stats = await repo.rawStats();
    if (stats.contributionsCount == 0) return 0;
    return (goal.saved / stats.contributionsCount) * 30;
  }
}
