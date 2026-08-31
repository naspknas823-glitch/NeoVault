import 'package:flutter/material.dart';
import '../../shared/widgets/motion.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/social_repositories.dart';
import '../../data/repositories/ui_providers.dart';
import '../../domain/leaderboard/leaderboard_engine.dart';
import '../../shared/widgets/widgets.dart';

/// 6.27 Ghost Leaderboard (§10.4): opt-in dialog on first entry, two tabs
/// (Темп | XP тижня), weekly ghost race track (2 ghosts), top list (nick,
/// %, XP, rank, streak ONLY — ⛔ no money), beat-a-ghost reward, own row
/// highlighted, empty state «Ще мало гравців у бета».
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  LeaderboardTab _tab = LeaderboardTab.tempo;
  bool _optInChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(goalRepositoryProvider).trackScreenVisit('leaderboard');
      if (!mounted || _optInChecked) return;
      final optIn = await ref.read(leaderboardRepositoryProvider).optInState();
      _optInChecked = true;
      if (!optIn.optedIn && mounted) {
        await _showOptInDialog();
      }
    });
  }

  Future<void> _showOptInDialog() async {
    final t = ref.read(tProvider);
    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(t('leaderboard.optin_title')),
        content: Text(t('leaderboard.optin_body')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t('leaderboard.optin_decline')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t('leaderboard.optin_accept')),
          ),
        ],
      ),
    );
    await ref.read(leaderboardRepositoryProvider).setOptIn(accepted ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final optIn = ref.watch(leaderboardOptInProvider).valueOrNull;
    final pair = ref.watch(ghostPairProvider).valueOrNull;

    final body = DefaultTabController(
      length: 2,
      child: Column(
        children: [
        // Tabs: Темп | XP тижня.
        TabBar(
          tabs: [
            Tab(text: t('leaderboard.tab_tempo')),
            Tab(text: t('leaderboard.tab_xp')),
          ],
          onTap: (i) => setState(
              () => _tab = i == 0 ? LeaderboardTab.tempo : LeaderboardTab.weeklyXp),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            _tab == LeaderboardTab.tempo
                ? t('leaderboard.tempo_desc')
                : t('leaderboard.xp_desc'),
            style: NvType.caption(c),
          ),
        ),
        Expanded(
          child: !(optIn?.optedIn ?? false)
              ? EmptyState(
                  title: t('leaderboard.title'),
                  body: t('leaderboard.optin_body'),
                  ctaLabel: t('leaderboard.optin_accept'),
                  onCta: _showOptInDialog,
                  icon: Icons.leaderboard_rounded,
                )
                : pair == null
                    ? const SizedBox.shrink()
                    : _RaceAndTable(pair: pair, tab: _tab),
        ),
        ],
      ),
    );

    if (widget.embedded) return body;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(t('leaderboard.title')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(t('leaderboard.week_reset'), style: NvType.caption(c)),
            ),
          ),
        ],
      ),
      body: body,
    );
  }
}

/// Ghost race track: 3 runners (self + 2 ghosts) + beat-ghost reward.
class _RaceAndTable extends ConsumerWidget {
  const _RaceAndTable({required this.pair, required this.tab});
  final GhostPair pair;
  final LeaderboardTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final selfMetric =
        tab == LeaderboardTab.tempo ? pair.self.percent : pair.self.weeklyXp.toDouble();
    final ghostMetrics = pair.ghosts
        .map((g) => tab == LeaderboardTab.tempo ? g.percent : g.weeklyXp.toDouble())
        .toList();
    final maxMetric = [
      selfMetric,
      ...ghostMetrics,
    ].fold<double>(1, (a, b) => a > b ? a : b);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        NeonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t('leaderboard.ghost_race'), style: NvType.button(c).copyWith(color: c.accent)),
              const SizedBox(height: 12),
              _RaceRow(
                label: t('leaderboard.you'),
                metric: selfMetric,
                max: maxMetric,
                color: c.accent,
                ghost: false,
              ),
              for (var i = 0; i < pair.ghosts.length; i++)
                _RaceRow(
                  label: pair.ghosts[i].nick,
                  metric: ghostMetrics[i],
                  max: maxMetric,
                  color: c.secondary,
                  ghost: true,
                ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () async {
                  final ok =
                      await ref.read(leaderboardRepositoryProvider).claimGhostReward();
                  if (context.mounted) {
                    context.toast(ok
                        ? t('leaderboard.beat_ghost')
                        : t('leaderboard.beat_ghost_hint'));
                  }
                },
                child: Text(t('leaderboard.beat_ghost')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        NeonCard(
          child: Column(
            children: [
              for (final g in pair.ghosts) _row(g, false, c, t),
              _row(pair.self, true, c, t),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(LeaderboardRow r, bool self, AppColors c,
      String Function(String, [Map<String, Object?>]) t) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: self ? c.accent.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: self ? Border.all(color: c.accent) : null,
      ),
      child: Row(
        children: [
          // ⛔ Only nick / % / XP / rank / streak — never money amounts.
          Expanded(
            flex: 3,
            child: Text(
              self ? '${r.nick} • ${t('leaderboard.you')}' : r.nick,
              style: NvType.body(c),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              tab == LeaderboardTab.tempo
                  ? formatPercent(r.percent, digits: 1)
                  : '${r.weeklyXp} XP',
              style: NvType.button(c).copyWith(
                fontSize: 13,
                color: self ? c.accent : c.text,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(r.rankLabel, style: NvType.caption(c)),
          ),
          Text('🔥 ${r.streakDays}', style: NvType.caption(c)),
        ],
      ),
    );
  }
}

class _RaceRow extends ConsumerWidget {
  const _RaceRow({
    required this.label,
    required this.metric,
    required this.max,
    required this.color,
    required this.ghost,
  });

  final String label;
  final double metric;
  final double max;
  final Color color;
  final bool ghost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final reduced = ref.watch(reduceMotionProvider);
    final frac = (metric / max).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            ghost ? Icons.visibility_off_outlined : Icons.person_rounded,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: frac),
              duration: reduced ? Duration.zero : NvMotion.slow,
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: v,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: color.withOpacity(ghost ? 0.4 : 0.9),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: NvType.caption(c),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

/// Wrapper used inside the Achievements segment switcher (§10.9).
class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});
  @override
  Widget build(BuildContext context) => const LeaderboardScreen(embedded: true);
}
