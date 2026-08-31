import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/retention_repositories.dart';
import '../../data/repositories/ui_providers.dart';
import '../../domain/chests/daily_drop.dart';
import '../../shared/widgets/widgets.dart';

/// 6.26 Quests (§10.2/§6.26): 3 daily cards (⭐ main always), progress,
/// Claim → Chips toast + mini-confetti; weekly chain; reset timer 00:00
/// Kyiv; Chips balance in header. ⛔ Claim gives Chips, NEVER XP.
class QuestsScreen extends ConsumerStatefulWidget {
  const QuestsScreen({super.key});

  @override
  ConsumerState<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends ConsumerState<QuestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('quests');
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final daily = ref.watch(questsDailyProvider);
    final weekly = ref.watch(questsWeeklyProvider);
    final chips = ref.watch(chipsWalletProvider).valueOrNull?.balance ?? 0;
    final tick = ref.watch(countdownTickProvider).valueOrNull ?? 0;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(t('quests.title')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(Icons.monetization_on_rounded,
                    color: c.accent2, size: 18),
                const SizedBox(width: 4),
                Text('$chips', style: NvType.button(c).copyWith(color: c.accent2)),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Reset timer (00:00 Києва, §10.2).
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 16, color: c.secondary),
              const SizedBox(width: 6),
              Text(
                t('quests.reset_in', {
                  't': formatCountdown(
                    nextKyivMidnight().difference(kyivNow()),
                  ),
                }),
                style: NvType.caption(c),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(t('quests.daily'), style: NvType.h2(c).copyWith(fontSize: 16)),
          const SizedBox(height: 8),
          AsyncValueView<List<QuestState>>(
            value: daily,
            content: (list) => Column(
              children: [
                for (var i = 0; i < list.length; i++)
                  _QuestCard(
                    state: list[i],
                    isMain: list[i].def.isMain,
                    onClaim: () => _claim(list[i]),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(t('quests.weekly'), style: NvType.h2(c).copyWith(fontSize: 16)),
          const SizedBox(height: 8),
          AsyncValueView<List<QuestState>>(
            value: weekly,
            content: (list) => Column(
              children: [
                for (final q in list)
                  _QuestCard(state: q, isMain: false, onClaim: () => _claim(q)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Daily Drop section (§10.3): chest button + chain + odds on
          // long-press (⛔ 1/day, day 7 = big chest).
          _DailyDropCard(onOpened: () {
            ref.read(chestDayTickProvider.notifier).state++;
            ref.read(chestOpenedTickProvider.notifier).state++;
          }),
          Text(
            'tick:$tick',
            style: const TextStyle(fontSize: 0),
          ),
        ],
      ),
    );
  }

  Future<void> _claim(QuestState q) async {
    final t = ref.read(tProvider);
    final messenger = ScaffoldMessenger.of(context);
    final chips = await ref.read(questRepositoryProvider).claim(q);
    ref.read(questTickProvider.notifier).state++;
    if (chips > 0) {
      messenger.showSnackBar(
        SnackBar(content: Text(t('quests.chips_toast', {'n': chips}))),
      );
    }
  }
}

class _QuestCard extends ConsumerWidget {
  const _QuestCard({
    required this.state,
    required this.isMain,
    required this.onClaim,
  });

  final QuestState state;
  final bool isMain;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: NeonCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        accentBorder: isMain,
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  state.isComplete
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked,
                  size: 20,
                  color: state.isComplete ? c.success : c.secondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${isMain ? '⭐ ' : ''}${t(state.def.titleL10nKey)}',
                    style: NvType.body(c),
                  ),
                ),
                if (!state.claimed)
                  Text(
                    t('quests.reward_chips', {'n': state.def.rewardChips}),
                    style: NvType.caption(c).copyWith(color: c.accent2),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: NeonProgressBar(value: state.progressFraction, height: 6),
                ),
                const SizedBox(width: 10),
                Text(
                  t('quests.progress',
                      {'a': state.progress, 'b': state.def.target}),
                  style: NvType.caption(c),
                ),
                const SizedBox(width: 10),
                if (state.claimed)
                  Icon(Icons.done_all_rounded, size: 18, color: c.success)
                else
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: state.isComplete ? onClaim : null,
                      child: Text(
                        t('quests.claim'),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Daily Drop card (§10.3): chest with shake animation, chain progress to
/// day-7 big chest, LONG-PRESS → odds screen (criterion 12.13).
class _DailyDropCard extends ConsumerWidget {
  const _DailyDropCard({required this.onOpened});
  final VoidCallback onOpened;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final chest = ref.watch(chestStateProvider).valueOrNull;
    final available = chest?.availableToday ?? false;
    final chain = chest?.chain ?? 0;

    return GestureDetector(
      onLongPress: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ChestOddsScreen()),
      ),
      child: NeonCard(
        accentBorder: available,
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.card_giftcard_rounded,
                    size: 28, color: available ? c.accent : c.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t('chest.title'), style: NvType.h2(c).copyWith(fontSize: 16)),
                      Text(
                        t('chest.chain', {'n': chain}),
                        style: NvType.caption(c),
                      ),
                      Text(
                        t('chest.next_big',
                            {'n': (7 - (chain % 7)) % 7 == 0 ? 7 : (7 - (chain % 7))}),
                        style: NvType.caption(c),
                      ),
                    ],
                  ),
                ),
                if (chest?.isBigChestDay ?? false)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: c.accent2.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(t('chest.chain_7'),
                        style: NvType.caption(c).copyWith(color: c.accent2)),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: !available
                    ? null
                    : () async {
                        try {
                          final reward = await ref.read(chestRepositoryProvider).open();
                          onOpened();
                          if (context.mounted) {
                            _showReward(context, ref, reward);
                          }
                        } on Exception {
                          if (context.mounted) {
                            context.toast(t('chest.already'));
                          }
                        }
                      },
                icon: Icon(available ? Icons.lock_open_rounded : Icons.lock_rounded,
                    size: 18),
                label: Text(
                  available ? t('chest.open') : t('chest.come_tomorrow'),
                ),
              ),
            ),
            Text(
              t('chest.long_press_hint'),
              style: NvType.caption(c),
            ),
          ],
        ),
      ),
    );
  }

  void _showReward(BuildContext context, WidgetRef ref, ChestReward reward) {
    final t = ref.read(tProvider);
    final label = switch (reward.kind) {
      ChestRewardKind.chips => t('chest.reward_chips', {'n': reward.chips}),
      ChestRewardKind.petFeed => t('chest.reward_feed'),
      ChestRewardKind.pack => t('chest.reward_pack'),
      ChestRewardKind.rareCard => t('chest.reward_rare'),
    };
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  const MiniConfetti(),
                  Icon(Icons.redeem_rounded, size: 72, color: questAccent(ref)),
                ],
              ),
              const SizedBox(height: 12),
              Text(t('chest.opened'), style: NvType.h2(ref.watch(appColorsProvider))),
              Text(label,
                  style: NvType.h2(ref.watch(appColorsProvider))
                      .copyWith(color: questAccent(ref), fontSize: 20)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(t('common.done')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Color questAccent(WidgetRef ref) => ref.watch(appColorsProvider).accent;
}

/// «Шанси» screen (§10.3): public odds, long-press target.
class ChestOddsScreen extends ConsumerWidget {
  const ChestOddsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('odds.title'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NeonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('chest.title'), style: NvType.button(c).copyWith(color: c.accent)),
                const SizedBox(height: 8),
                for (final o in DailyDropEngine.normalOdds)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Expanded(child: Text(t(o.labelKey), style: NvType.body(c))),
                        Text('${(o.chance * 100).toStringAsFixed(0)}%',
                            style: NvType.button(c).copyWith(color: c.accent)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          NeonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('chest.chain_7'), style: NvType.button(c).copyWith(color: c.accent2)),
                const SizedBox(height: 8),
                for (final o in DailyDropEngine.bigOdds)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Expanded(child: Text(t(o.labelKey), style: NvType.body(c))),
                        Text('${(o.chance * 100).toStringAsFixed(0)}%',
                            style: NvType.button(c).copyWith(color: c.accent2)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(t('odds.public'), style: NvType.caption(c)),
          const SizedBox(height: 4),
          Text(t('odds.no_money'), style: NvType.caption(c).copyWith(color: c.accent2)),
        ],
      ),
    );
  }
}
