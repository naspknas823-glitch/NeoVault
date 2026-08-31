import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/goal_repository.dart';
import '../../shared/widgets/widgets.dart';
import '../../core/utils/format.dart';
import '../../core/theme/app_theme.dart';

/// (12) Water level — анімований рівень води показує відсоток прогресу.
/// (13) Collectible puzzle — пазл розблоковується по частинах з прогресом.
/// (14) Savings tree — дерево росте з рівнем заощаджень.
/// (15) Pixel art evolution — піксельна еволюція піксельного артс на основі рівня.
/// (23) Savings curve — графік fl_chart у часі.
/// (37) Daily Fortune — щоденне "монетне" прогнозування.
/// (38) Mini-game for top-up — мінімалістична гра для мотивації.
class GamificationScreen extends ConsumerStatefulWidget {
  const GamificationScreen({super.key});

  @override
  ConsumerState<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends ConsumerState<GamificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _treeController;
  String? _fortuneText;
  bool _miniGameActive = false;
  int _miniGameScore = 0;

  static const _fortunes = [
    '🌟 Сьогоднішній внесок — твій крок до мрії!',
    '💎 Маленькі кроки щодня ведуть до великих перемог.',
    '🚀 Ти ближче до PS5, ніж вчора!',
    '🎯 Фокус на ціль — і успіх неминучий.',
    '💰 Гроші люблять тих, хто їх рахує.',
    '🏆 Наполегливість перемагає таланта — зберігай!',
    '⚡ Сьогодні відкладаєш — завтра святкуєш.',
    '🌈 Кожна гривня наближає твою мрію.',
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    _treeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _pickFortune();
  }

  void _pickFortune() {
    final idx = DateTime.now().day % _fortunes.length;
    _fortuneText = _fortunes[idx];
  }

  @override
  void dispose() {
    _waveController.dispose();
    _treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final goalAsync = ref.watch(goalProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: const Text('Visual Progress'),
        backgroundColor: c.background,
      ),
      body: goalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (goal) {
          if (goal == null) {
            return Center(
              child: Text('No goal set. Create a goal first!',
                  style: TextStyle(color: c.secondary)),
            );
          }
          final percent = (goal.percent / 100).clamp(0.0, 1.0);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // (12) Water Level
                _sectionTitle('(12) Water Level', c),
                NeonCard(
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    height: 160,
                    child: _WaterLevelWidget(percent: percent, c: c, controller: _waveController),
                  ),
                ),
                const SizedBox(height: 16),

                // (14) Savings Tree
                _sectionTitle('(14) Savings Tree', c),
                NeonCard(
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    height: 160,
                    child: _SavingsTree(percent: percent, c: c, animation: _treeController),
                  ),
                ),
                const SizedBox(height: 16),

                // (15) Pixel Art Evolution
                _sectionTitle('(15) Pixel Art Evolution', c),
                NeonCard(
                  padding: const EdgeInsets.all(16),
                  child: _PixelArtEvolution(percent: percent, c: c),
                ),
                const SizedBox(height: 16),

                // (13) Collectible Puzzle
                _sectionTitle('(13) Collectible Puzzle', c),
                NeonCard(
                  padding: const EdgeInsets.all(16),
                  child: _CollectiblePuzzle(percent: percent, c: c),
                ),
                const SizedBox(height: 16),

                // (37) Daily Fortune
                _sectionTitle('(37) Daily Fortune', c),
                NeonCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('🔮 Fortune of the Day',
                          style: TextStyle(color: c.secondary, fontSize: 13)),
                      const SizedBox(height: 8),
                      Text(
                        _fortuneText ?? '',
                        style: TextStyle(
                            color: c.accent, fontSize: 16, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // (38) Mini-game for top-up
                _sectionTitle('(38) Mini-game: Tap to Save!', c),
                NeonCard(
                  padding: const EdgeInsets.all(16),
                  child: _MiniGame(c: c, percent: percent, ref: ref),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title, AppColors c) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(title,
            style: TextStyle(
                color: c.secondary, fontWeight: FontWeight.bold, fontSize: 13)),
      );
}

// ── Water Level (12) ─────────────────────────────────────────────────────────
class _WaterLevelWidget extends StatelessWidget {
  const _WaterLevelWidget(
      {required this.percent, required this.c, required this.controller});
  final double percent;
  final AppColors c;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _WavePainter(
              percent: percent,
              waveOffset: controller.value,
              color: c.accent,
            ),
            child: Center(
              child: Text(
                '${(percent * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 8, color: c.accent)],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter(
      {required this.percent, required this.waveOffset, required this.color});
  final double percent;
  final double waveOffset;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final waterHeight = size.height * (1 - percent);
    final paint = Paint()..color = color.withValues(alpha: 0.7);
    final path = Path();
    path.moveTo(0, waterHeight);
    for (double x = 0; x <= size.width; x++) {
      final y = waterHeight +
          math.sin((x / size.width * 2 * math.pi) + (waveOffset * 2 * math.pi)) *
              8.0;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // second wave
    final paint2 = Paint()..color = color.withValues(alpha: 0.4);
    final path2 = Path();
    path2.moveTo(0, waterHeight + 4);
    for (double x = 0; x <= size.width; x++) {
      final y = waterHeight +
          4 +
          math.sin((x / size.width * 2 * math.pi) +
                  (waveOffset * 2 * math.pi) +
                  math.pi / 2) *
              6.0;
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(_WavePainter old) => true;
}

// ── Savings Tree (14) ─────────────────────────────────────────────────────────
class _SavingsTree extends StatelessWidget {
  const _SavingsTree(
      {required this.percent, required this.c, required this.animation});
  final double percent;
  final AppColors c;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final stage = (percent * 5).floor().clamp(0, 4);
    final stages = ['🌱', '🪴', '🌿', '🌳', '🌲'];
    final labels = ['Seed', 'Sprout', 'Sapling', 'Tree', 'Forest'];

    return AnimatedBuilder(
      animation: animation,
      builder: (ctx, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  c.surface,
                  c.accent.withValues(alpha: 0.08 + percent * 0.15),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: animation.value * (0.8 + percent * 0.5),
                  child: Text(stages[stage],
                      style: TextStyle(fontSize: 56 + percent * 20)),
                ),
                const SizedBox(height: 8),
                Text(labels[stage],
                    style: TextStyle(
                        color: c.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                Text('${(percent * 100).toInt()}% complete',
                    style: TextStyle(color: c.secondary, fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Pixel Art Evolution (15) ──────────────────────────────────────────────────
class _PixelArtEvolution extends StatelessWidget {
  const _PixelArtEvolution({required this.percent, required this.c});
  final double percent;
  final AppColors c;

  static const _stages = [
    ['🐣', 'Egg', 'Just started!'],
    ['🐥', 'Chick', 'Growing fast!'],
    ['🦅', 'Eagle', 'Soaring high!'],
    ['🦄', 'Unicorn', 'Legendary saver!'],
    ['🐉', 'Dragon', 'Ultimate form!'],
  ];

  @override
  Widget build(BuildContext context) {
    final stage = (percent * 5).floor().clamp(0, 4);
    final info = _stages[stage];
    return Row(
      children: [
        Text(info[0], style: const TextStyle(fontSize: 64)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(info[1],
                  style: TextStyle(
                      color: c.text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Text(info[2],
                  style: TextStyle(color: c.secondary, fontSize: 13)),
              const SizedBox(height: 8),
              NeonProgressBar(value: percent, height: 8),
              const SizedBox(height: 4),
              Text(
                stage < 4
                    ? 'Next: ${_stages[stage + 1][1]} at ${((stage + 1) * 20)}%'
                    : 'Max level reached! 🎉',
                style: TextStyle(color: c.accent, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Collectible Puzzle (13) ───────────────────────────────────────────────────
class _CollectiblePuzzle extends StatelessWidget {
  const _CollectiblePuzzle({required this.percent, required this.c});
  final double percent;
  final AppColors c;

  @override
  Widget build(BuildContext context) {
    const pieces = 9;
    final unlocked = (percent * pieces).floor().clamp(0, pieces);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$unlocked / $pieces pieces unlocked',
            style: TextStyle(color: c.secondary, fontSize: 13)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: pieces,
          itemBuilder: (ctx, i) {
            final isUnlocked = i < unlocked;
            final emojis = ['🎮', '📺', '🎯', '⚡', '💎', '🏆', '🌟', '🚀', '✨'];
            return Container(
              decoration: BoxDecoration(
                color: isUnlocked
                    ? c.accent.withValues(alpha: 0.2)
                    : c.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isUnlocked ? c.accent : c.border,
                  width: isUnlocked ? 2 : 1,
                ),
              ),
              child: Center(
                child: isUnlocked
                    ? Text(emojis[i], style: const TextStyle(fontSize: 24))
                    : Icon(Icons.lock_rounded, color: c.secondary, size: 20),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ── Mini-game for top-up (38) ─────────────────────────────────────────────────
class _MiniGame extends StatefulWidget {
  const _MiniGame({required this.c, required this.percent, required this.ref});
  final AppColors c;
  final double percent;
  final WidgetRef ref;

  @override
  State<_MiniGame> createState() => _MiniGameState();
}

class _MiniGameState extends State<_MiniGame> {
  int _taps = 0;
  bool _awarded = false;
  static const _tapGoal = 10;

  Future<void> _onTap() async {
    if (_awarded) return;
    setState(() => _taps++);
    if (_taps >= _tapGoal && !_awarded) {
      setState(() => _awarded = true);
      // Award 50₴ bonus contribution
      await widget.ref.read(goalRepositoryProvider).addContribution(
            amount: 50,
            comment: 'Mini-game bonus! 🎮',
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('🎮 Mini-game complete! +50 ₴ deposited!'),
            backgroundColor: widget.c.success,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_taps / _tapGoal).clamp(0.0, 1.0);
    return Column(
      children: [
        Text(
          _awarded
              ? '🎉 Completed! +50₴ deposited!'
              : 'Tap ${_tapGoal - _taps} more times to earn a 50₴ bonus!',
          style: TextStyle(
              color: _awarded ? widget.c.success : widget.c.text,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        NeonProgressBar(value: progress, height: 10),
        const SizedBox(height: 16),
        if (!_awarded)
          GestureDetector(
            onTap: _onTap,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.c.accent,
                boxShadow: [
                  BoxShadow(
                      color: widget.c.accent.withValues(alpha: 0.5),
                      blurRadius: 16,
                      spreadRadius: 2),
                ],
              ),
              child: const Center(
                child: Text('💰', style: TextStyle(fontSize: 36)),
              ),
            ),
          ),
      ],
    );
  }
}
