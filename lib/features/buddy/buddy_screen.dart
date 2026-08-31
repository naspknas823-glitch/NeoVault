import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart' show BuddyCacheData;
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/social_repositories.dart';
import '../../data/repositories/ui_providers.dart';
import '../../domain/buddy/buddy_engine.dart';
import '../../shared/widgets/motion.dart';
import '../../shared/widgets/widgets.dart';

/// 6.31 Buddy (§10.8/§6.31): two progress rings, race bar, streaks,
/// 3 ping presets with ⛔ 3/day limit, buddy-week challenge (+30 Chips both),
/// unlink (danger + confirm), empty state = create invite (code + join).
class BuddyScreen extends ConsumerStatefulWidget {
  const BuddyScreen({super.key});

  @override
  ConsumerState<BuddyScreen> createState() => _BuddyScreenState();
}

class _BuddyScreenState extends ConsumerState<BuddyScreen> {
  final _codeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('buddy');
    });
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final buddyRow = ref.watch(buddyProvider).valueOrNull;
    final linked = buddyRow?.buddyId != null;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('buddy.title'))),
      body: !linked
          ? _EmptyBuddy(t: t, c: c, codeCtrl: _codeCtrl)
          : _LinkedBuddyView(buddy: buddyRow!),
    );
  }
}

class _LinkedBuddyView extends ConsumerWidget {
  const _LinkedBuddyView({required this.buddy});
  final BuddyCacheData buddy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final pingsUsed = buddy.pingsDay == kyivDateKey() ? buddy.pingsToday : 0;
    final pingsLeft = BuddyEngine.maxPingsPerDay - pingsUsed;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Два прогрес-кільця поруч (§6.31).
        NeonCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Consumer(builder: (context, ref, _) {
                final goal = ref.watch(goalProvider).valueOrNull;
                return _Ring(
                  label: t('buddy.you'),
                  percent: goal?.percent ?? 0,
                  accent: c.accent,
                );
              }),
              _Ring(
                label: buddy.buddyNick ?? t('buddy.buddy'),
                percent: buddy.buddyGoalPercent,
                accent: c.accent2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Бар «Хто швидше цього тижня» (§6.31).
        NeonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t('buddy.race_bar'), style: NvType.button(c)),
              const SizedBox(height: 10),
              _RaceBar(
                selfPercent: buddy.buddyWeeklyPercent * 0.5 + 1,
                buddyPercent: buddy.buddyWeeklyPercent,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(t('buddy.streaks'), style: NvType.caption(c)),
                  const Spacer(),
                  Text('🔥 ${buddy.buddyStreak}',
                      style: NvType.caption(c).copyWith(color: c.accent2)),
                ],
              ),
              Text(
                t('buddy.percent_visible'),
                style: NvType.caption(c),
              ),
            ],
          ),
        ),
const SizedBox(height: 12),
        // (29) Shared vault — чесний комбінований аналог: середній % пари.
        Consumer(builder: (context, ref, _) {
          final goal = ref.watch(goalProvider).valueOrNull;
          final selfPercent = goal?.percent ?? 0;
          final combined = ((selfPercent + buddy.buddyGoalPercent) / 2);
          return NeonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.handshake_rounded, color: c.accent, size: 20),
                    const SizedBox(width: 8),
                    Text(t('buddy.shared_title'), style: NvType.button(c)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  t('buddy.shared_percent', {'n': combined.round()}),
                  style: NvType.h2(c).copyWith(color: c.accent2),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: (combined / 100).clamp(0.0, 1.0),
                  backgroundColor: c.surface,
                  color: c.accent2,
                ),
                const SizedBox(height: 8),
                Text(t('buddy.shared_body'), style: NvType.caption(c)),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
        const SizedBox(height: 12),
        // Пінги (3 пресети, ⛔ max 3/день).
        NeonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child:
                          Text(t('buddy.ping_title'), style: NvType.button(c))),
                  Text(
                    t('buddy.ping_left', {'n': pingsLeft}),
                    style: NvType.caption(c).copyWith(
                      color: pingsLeft > 0 ? c.accent : c.danger,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (var i = 1; i <= 3; i++)
                    ActionChip(
                      label: Text(t('buddy.ping$i')),
                      onPressed: pingsLeft <= 0
                          ? () => context.toast(t('buddy.ping_blocked'))
                          : () async {
                              final ok = await ref
                                  .read(buddyRepositoryProvider)
                                  .sendPing(i);
                              if (context.mounted) {
                                context.toast(ok
                                    ? t('buddy.ping_sent')
                                    : t('buddy.ping_blocked'));
                              }
                            },
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Бадді-тиждень (§10.8): обидва 3+ → +30 Chips обом.
        NeonCard(
          accentBorder: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t('buddy.week_challenge'),
                  style: NvType.button(c).copyWith(color: c.accent2)),
              const SizedBox(height: 6),
              Text(t('buddy.week_desc'), style: NvType.bodySecondary(c)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: buddy.weekRewardClaimed
                    ? null
                    : () async {
                        final ok = await ref
                            .read(buddyRepositoryProvider)
                            .claimBuddyWeek();
                        if (context.mounted) {
                          context.toast(ok
                              ? t('buddy.week_done')
                              : t('buddy.week_desc'));
                        }
                      },
                child: Text(buddy.weekRewardClaimed
                    ? t('buddy.week_done')
                    : t('events.claim')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(t('buddy.unlink')),
                content: Text(t('buddy.unlink_confirm')),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(t('common.cancel')),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(t('common.delete')),
                  ),
                ],
              ),
            );
            if (confirmed == true) {
              await ref.read(buddyRepositoryProvider).unlink();
              if (context.mounted) context.toast(t('buddy.unlinked'));
            }
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: c.danger,
            side: BorderSide(color: c.danger),
          ),
          child: Text(t('buddy.unlink')),
        ),
      ],
    );
  }
}

class _EmptyBuddy extends ConsumerStatefulWidget {
  const _EmptyBuddy({required this.t, required this.c, required this.codeCtrl});
  final String Function(String, [Map<String, Object?>]) t;
  final AppColors c;
  final TextEditingController codeCtrl;

  @override
  ConsumerState<_EmptyBuddy> createState() => _EmptyBuddyState();
}

class _EmptyBuddyState extends ConsumerState<_EmptyBuddy> {
  String? _createdCode;

  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    final t = widget.t;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GlowIcon(icon: Icons.handshake_rounded, color: c.accent, size: 56),
            const SizedBox(height: 12),
            Text(t('buddy.empty'), style: NvType.h2(c), textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(t('buddy.empty_body'),
                style: NvType.bodySecondary(c), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            if (_createdCode == null)
              NeonGradientButton(
                label: t('buddy.create_invite'),
                onPressed: () async {
                  final (code, _) =
                      await ref.read(buddyRepositoryProvider).createInvite();
                  setState(() => _createdCode = code);
                },
              )
            else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: c.accent),
                ),
                child: Text(
                  _createdCode!,
                  style: NvType.amount(c, size: 32)
                      .copyWith(color: c.accent, letterSpacing: 6),
                ),
              ),
              const SizedBox(height: 8),
              Text(t('buddy.invite_code'), style: NvType.caption(c)),
            ],
            const SizedBox(height: 16),
            TextField(
              controller: widget.codeCtrl,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: t('buddy.join_hint'),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () async {
                try {
                  await ref
                      .read(buddyRepositoryProvider)
                      .acceptCode(widget.codeCtrl.text);
                  if (context.mounted) {
                    context.toast(t('buddy.connected_toast'));
                  }
                } on BuddyInvalidCode {
                  if (context.mounted) context.toast(t('buddy.join_invalid'));
                }
              },
              child: Text(t('buddy.join')),
            ),
          ],
        ),
      ),
    );
  }
}

class _Ring extends ConsumerWidget {
  const _Ring({required this.label, required this.percent, required this.accent});
  final String label;
  final double percent;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduced = ref.watch(reduceMotionProvider);
    final frac = (percent / 100).clamp(0.0, 1.0);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: frac),
      duration: reduced ? Duration.zero : NvMotion.slow,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Column(
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 84,
                  height: 84,
                  child: CircularProgressIndicator(
                    value: v,
                    strokeWidth: 6,
                    color: accent,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Text('${(v * 100).toStringAsFixed(0)}%',
                    style: NvType.button(ref.watch(appColorsProvider))),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: NvType.caption(ref.watch(appColorsProvider))),
        ],
      ),
    );
  }
}

class _RaceBar extends ConsumerWidget {
  const _RaceBar({required this.selfPercent, required this.buddyPercent});
  final double selfPercent;
  final double buddyPercent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final frac = buddyRaceProgress(selfPercent, buddyPercent);
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 14,
        child: Row(
          children: [
            Expanded(
              flex: (frac * 100).round().clamp(1, 99),
              child: ColoredBox(color: c.accent, child: const SizedBox.expand()),
            ),
            Expanded(
              flex: ((1 - frac) * 100).round().clamp(1, 99),
              child: ColoredBox(
                  color: c.accent2, child: const SizedBox.expand()),
            ),
          ],
        ),
      ),
    );
  }
}
