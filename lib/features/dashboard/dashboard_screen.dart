import 'dart:async';
import '../dashboard/add_money_sheet.dart';
import '../../data/repositories/system_repositories.dart';
import '../../data/repositories/ui_providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/app_database.dart' show UserStatsTableData;
import '../../core/services/system_integration_service.dart';
import '../../core/services/context_trigger_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/retention_repositories.dart';
import '../../domain/gamification/xp_engine.dart';
import '../../domain/prices/price_models.dart';
import '../../shared/widgets/widgets.dart';

/// 6.3 Dashboard (§6.3): glanceable hierarchy — big amount, %, remaining,
/// PS5/Monitor sub-cards, Buy-status, ETA, header (avatar/nick/rank/XP/
/// notifications with unread badge), Live strip (§10.9), FAB «Додати
/// гроші» (§8.1 — 4 tabs + FAB, no new tabs).
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Timer? _petVisitTimer;

  @override
  void initState() {
    super.initState();
    // Schedule context triggers after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(contextTriggerProvider).runAllTriggers());
    });
    // Screen-visit tracking (O2) + pet open-day bookkeeping.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final goals = ref.read(goalRepositoryProvider);
      await goals.trackScreenVisit('dashboard');
      await ref.read(petRepositoryProvider).stateNow();
      await ref.read(questRepositoryProvider).syncWeeklyFromStats();
      // Rate App trigger (§6.16): 3rd contribution AND 5+ days, ≥30d gap.
      final rate = ref.read(rateAppRepositoryProvider);
      if (await rate.shouldPrompt()) {
        if (mounted) showRateAppDialog(context, ref);
      }
    });
  }

  @override
  void dispose() {
    _petVisitTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final goalAsync = ref.watch(goalProvider);
    final statsAsync = ref.watch(statsRowProvider);
    final unreadAsync = ref.watch(unreadCountProvider);
    final ps5Scan = ref.watch(scanProvider('ps5'));
    final monScan = ref.watch(scanProvider('monitor'));

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: _Header(stats: statsAsync, t: t),
        actions: [
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: Badge(
              isLabelVisible: (unreadAsync.valueOrNull ?? 0) > 0,
              label: Text('${unreadAsync.valueOrNull ?? 0}'),
              child: const Icon(Icons.notifications_none_rounded),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingAddMoneyButton(onTap: () async {
        final outcome = await showAddMoneySheet(context, ref);
        if (outcome != null && context.mounted) {
          // (4/5) Update home/lock screen widget after every deposit.
          unawaited(ref.read(systemIntegrationProvider).updateHomeWidget());
          // (24) Dynamic Icon update if leveled up.
          if (outcome.result.leveledUp) {
            unawaited(ref.read(systemIntegrationProvider).updateDynamicIcon(outcome.result.newLevel));
          }
          final settings = ref.read(settingsRepositoryProvider);
          final shown = await settings.firstDepositSurpriseShown();
          final stats = await ref.read(goalRepositoryProvider).rawStats();
          if (stats.contributionsCount == 1 && !shown) {
            await settings.setFirstDepositSurpriseShown(true);
            if (context.mounted) {
              await showDialog(
                context: context,
                builder: (_) => const _FirstDepositSurpriseDialog(),
              );
            }
          }
          if (outcome.result.goalCompleted && context.mounted) {
            context.push('/victory');
          }
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const DashboardBottomBar(currentIndex: 0),
      body: AsyncValueView<GoalView?>(
        value: goalAsync,
        isEmpty: (g) => g == null,
        empty: EmptyState(
          title: t('dashboard.no_goal'),
          body: t('common.tagline'),
          ctaLabel: t('dashboard.go_setup'),
          onCta: () => context.go('/onboarding'),
        ),
        content: (goal_) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(scanProvider('ps5'));
            ref.invalidate(scanProvider('monitor'));
            ref.invalidate(unreadCountProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _BigAmountCard(goal: goal_!, c: c, t: t),
                const SizedBox(height: 12),
                const _DashboardMotivationBanner(),
                const SizedBox(height: 12),
                const _TutorialQuestCard(),
                const SizedBox(height: 12),
                _SubGoalsRow(goal: goal_, ps5: ps5Scan, mon: monScan, t: t),
                const SizedBox(height: 12),
                _BuyStatusBlock(ps5: ps5Scan, mon: monScan, t: t),
                const SizedBox(height: 12),
                _EtaBlock(goal: goal_, c: c, t: t),
                const SizedBox(height: 12),
                const _LastContributionBlock(),
                const SizedBox(height: 12),
                _LiveStrip(c: c, t: t),
                const SizedBox(height: 12),
                _StreakRiskBanner(c: c, t: t),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ── Header: avatar, nick, rank + XP ────────────────────────────────────
class _Header extends ConsumerWidget {
  const _Header({required this.stats, required this.t});
  final AsyncValue<UserStatsTableData> stats;
  final String Function(String, [Map<String, Object?>]) t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final row = stats.valueOrNull;
    final xp = row?.totalXp ?? 0;
    final level = row?.level ?? 1;
    final rank = Gamification.rankForLevel(level);
    final nick = (row?.nickname.isNotEmpty ?? false)
        ? row!.nickname
        : t('dashboard.guest');
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: c.surface,
          child: Text(
            nick.isEmpty ? 'G' : nick[0].toUpperCase(),
            style: NvType.button(c).copyWith(color: c.accent),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nick, style: NvType.button(c), overflow: TextOverflow.ellipsis),
              Text(
                '${t('dashboard.rank')}: ${rank.name.toUpperCase()} • ${Gamification.levelForXp(xp)} LVL • $xp XP',
                style: NvType.caption(c),
              ),
              const SizedBox(height: 6),
              // XP progress to the next level (§5.1, real data only).
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: Gamification.levelProgress(xp),
                        minHeight: 3,
                        backgroundColor: c.border,
                        color: c.accent,
                      ),
                    ),
                  ),
                  if (Gamification.levelForXp(xp) < 20) ...[
                    const SizedBox(width: 8),
                    Text(
                      t('dashboard.to_level',
                          {'n': Gamification.levelForXp(xp) + 1}),
                      style: NvType.caption(c).copyWith(fontSize: 10),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ── Big amount + % + remaining (hierarchy level 1 §6.3) ────────────────
class _BigAmountCard extends ConsumerWidget {
  const _BigAmountCard({required this.goal, required this.c, required this.t});
  final GoalView goal;
  final AppColors c;
  final String Function(String, [Map<String, Object?>]) t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pct = goal.percent;
    final streak = ref.watch(statsRowProvider).valueOrNull?.streakDays ?? 0;
    // Next 25%-step milestone (real math on the goal, no fake targets).
    const milestones = [25.0, 50.0, 75.0, 100.0];
    final nextMs = milestones.firstWhere((m) => m > pct, orElse: () => 100);
    final msNeed = ((goal.target * nextMs / 100).round() - goal.saved)
        .clamp(0, goal.remaining)
        .toInt();
    return NeonCard(
      breathing: true,
      accentBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(t('dashboard.saved'), style: NvType.caption(c)),
              const Spacer(),
              if (streak >= 2)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: c.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_fire_department_rounded,
                          size: 12, color: c.accent),
                      const SizedBox(width: 3),
                      Text(
                        t('dashboard.streak_chip', {'n': streak}),
                        style: NvType.caption(c)
                            .copyWith(color: c.accent, fontSize: 11),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          AnimatedCounter(
            value: goal.saved,
            // Ivory digits (Revolut-style); accent stays for interactive
            // elements only — no acid-colored numbers on the dashboard.
            style: NvType.amount(c, size: 40).copyWith(color: c.text),
            suffix: ' ₴',
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                t('dashboard.percent_reached', {'p': pct.toStringAsFixed(1)}),
                style: NvType.body(c).copyWith(color: c.success),
              ),
              const Spacer(),
              Text(
                '${t('dashboard.remaining')} ${formatMoneyShort(goal.remaining)}',
                style: NvType.bodySecondary(c),
              ),
            ],
          ),
          const SizedBox(height: 10),
          NeonProgressBar(value: pct / 100),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                t('dashboard.target', {'a': formatMoneyShort(goal.target)}),
                style: NvType.caption(c),
              ),
              const Spacer(),
              if (msNeed > 0)
                Text(
                  t('dashboard.next_milestone',
                      {'p': nextMs.toInt(), 'a': formatMoneyShort(msNeed)}),
                  style: NvType.caption(c).copyWith(color: c.accent),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ── PS5 + Monitor sub-cards (level 2 §6.3) ─────────────────────────────
class _SubGoalsRow extends ConsumerWidget {
  const _SubGoalsRow({
    required this.goal,
    required this.ps5,
    required this.mon,
    required this.t,
  });

  final GoalView goal;
  final AsyncValue<ProductScan?> ps5;
  final AsyncValue<ProductScan?> mon;
  final String Function(String, [Map<String, Object?>]) t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _SubGoalCard(
            title: t('dashboard.ps5'),
            icon: Icons.sports_esports_rounded,
            target: goal.ps5Target,
            progress: goal.percent / 100,
            savedAmount: goal.saved / 2,
            marketPrice: ps5.valueOrNull?.lowestPrice,
            changeDir: ps5.valueOrNull?.changeDir,
            changePercent: ps5.valueOrNull?.changePercent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SubGoalCard(
            title: t('dashboard.monitor'),
            icon: Icons.desktop_windows_rounded,
            target: goal.monitorTarget,
            progress: goal.percent / 100,
            savedAmount: goal.saved / 2,
            marketPrice: mon.valueOrNull?.lowestPrice,
            changeDir: mon.valueOrNull?.changeDir,
            changePercent: mon.valueOrNull?.changePercent,
          ),
        ),
      ],
    );
  }
}

class _SubGoalCard extends ConsumerWidget {
  const _SubGoalCard({
    required this.title,
    required this.icon,
    required this.target,
    required this.progress,
    required this.savedAmount,
    required this.marketPrice,
    this.changeDir,
    this.changePercent,
  });

  final String title;
  final IconData icon;
  final int target;
  final double progress;
  final double savedAmount;
  final num? marketPrice;
  final PriceChangeDir? changeDir;
  final double? changePercent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final trendColor = switch (changeDir) {
      PriceChangeDir.down => c.success, // price dropped — good for us
      PriceChangeDir.up => c.danger,
      _ => c.secondary,
    };
    final effectivePrice = (marketPrice != null && marketPrice! > 0)
        ? marketPrice!.toDouble()
        : target.toDouble();
    final enough = effectivePrice > 0 && savedAmount >= effectivePrice;
    return NeonCard(
      onTap: () => context.go('/scanner'),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 16, color: c.accent),
            const SizedBox(width: 6),
            Expanded(child: Text(title, style: NvType.button(c))),
          ]),
          const SizedBox(height: 8),
          NeonProgressBar(value: progress, height: 6),
          const SizedBox(height: 8),
          Text(
            '${formatMoneyShort(savedAmount)} / ${formatMoneyShort(target)}',
            style: NvType.caption(c),
          ),
          if (marketPrice != null && marketPrice! > 0) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${t('dashboard.market_price')}: ${formatMoneyShort(marketPrice!)}',
                    style: NvType.caption(c).copyWith(color: c.secondary),
                  ),
                ),
                if (changeDir != null && changePercent != null) ...[
                  Icon(
                    switch (changeDir!) {
                      PriceChangeDir.down => Icons.trending_down_rounded,
                      PriceChangeDir.up => Icons.trending_up_rounded,
                      PriceChangeDir.flat => Icons.trending_flat_rounded,
                    },
                    size: 12,
                    color: trendColor,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    formatPercent(changePercent!.abs(), digits: 1),
                    style: NvType.caption(c).copyWith(color: trendColor),
                  ),
                ],
              ],
            ),
          ],
          if (enough) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: c.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_rounded, size: 11, color: c.accent),
                  const SizedBox(width: 3),
                  Text(
                    t('dashboard.enough'),
                    style: NvType.caption(c).copyWith(color: c.accent),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ── Buy status block (level 4 §6.3) ────────────────────────────────────
class _BuyStatusBlock extends ConsumerWidget {
  const _BuyStatusBlock({required this.ps5, required this.mon, required this.t});
  final AsyncValue<ProductScan?> ps5;
  final AsyncValue<ProductScan?> mon;
  final String Function(String, [Map<String, Object?>]) t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final good = (ps5.valueOrNull?.isGoodDealNow ?? false) ||
        (mon.valueOrNull?.isGoodDealNow ?? false);
    final lastScan = ps5.valueOrNull?.scannedAt;
    return NeonCard(
      onTap: () => context.go('/scanner'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          StatusDot(level: good ? TrustDotLevel.green : TrustDotLevel.yellow),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              good ? t('dashboard.buy_status_good') : t('dashboard.buy_status_watch'),
              style: NvType.button(c).copyWith(
                    color: good ? c.success : c.secondary,
                  ),
            ),
          ),
          if (lastScan != null && lastScan.millisecondsSinceEpoch > 0)
            Text(
              '${t('dashboard.last_scan')} ${formatDateTime(lastScan)}',
              style: NvType.caption(c),
            ),
        ],
      ),
    );
  }
}

/// ── ETA forecast (level 5 §6.3): conservative / optimistic ─────────────
class _EtaBlock extends ConsumerWidget {
  const _EtaBlock({required this.goal, required this.c, required this.t});
  final GoalView goal;
  final AppColors c;
  final String Function(String, [Map<String, Object?>]) t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remaining = goal.remaining;
    final first = goal.createdAt;
    final now = DateTime.now();
    final daysActive = now.difference(first).inDays.clamp(1, 100000);
    final perDayCons = goal.saved / daysActive; // conservative
    final perDayOpt = perDayCons * 1.35; // optimistic scenario

    String etaText(num perDay) {
      if (goal.saved <= 0 || perDay <= 0) return t('dashboard.eta_never');
      final days = (remaining / perDay).ceil();
      final eta = now.add(Duration(days: days));
      return '${formatDate(eta)} • $days ${t('common.days')}';
    }

    return NeonCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _etaRow(t('dashboard.eta_conservative'), etaText(perDayCons)),
          const Divider(height: 14),
          _etaRow(t('dashboard.eta_optimistic'), etaText(perDayOpt)),
          const Divider(height: 14),
          _etaRow('Required Pace (3 months)', '${formatMoneyShort(remaining / 90)} / ${t('common.day')}'),
        ],
      ),
    );
  }

  Widget _etaRow(String label, String value) {
    return Row(
      children: [
        Expanded(child: Text(label, style: NvType.bodySecondary(c))),
        Text(value, style: NvType.button(c).copyWith(fontSize: 14, color: c.accent)),
      ],
    );
  }
}

/// ── Live strip (§10.9): [Скринька][Пет][Кільце квестів][Чіп події] ─────
class _LiveStrip extends ConsumerWidget {
  const _LiveStrip({required this.c, required this.t});
  final AppColors c;
  final String Function(String, [Map<String, Object?>]) t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chest = ref.watch(chestStateProvider).valueOrNull;
    final pet = ref.watch(petStateProvider).valueOrNull;
    final quests = ref.watch(questsDailyProvider).valueOrNull ?? const [];
    final event = ref.watch(activeEventProvider).valueOrNull;
    final chips = ref.watch(chipsWalletProvider).valueOrNull?.balance ?? 0;

    return Row(
      children: [
        _StripChip(
          icon: Icons.card_giftcard_rounded,
          label: t('chest.title'),
          highlight: chest?.availableToday ?? false,
          onTap: () => context.push('/quests'),
        ),
        const SizedBox(width: 8),
        _StripChip(
          icon: Icons.egg_alt_rounded,
          label: pet == null ? '🐾' : _formLabel(t, pet.form.name),
          onTap: () => context.push('/pet'),
        ),
        const SizedBox(width: 8),
        _StripChip(
          icon: Icons.check_circle_outline_rounded,
          label: '${quests.where((q) => q.isComplete).length}/${quests.length}',
          onTap: () => context.push('/quests'),
        ),
        const SizedBox(width: 8),
        if (event != null)
          _StripChip(
            icon: Icons.celebration_rounded,
            label: t('dashboard.event_chip'),
            highlight: true,
            onTap: () => context.push('/event'),
          )
        else
          _StripChip(
            icon: Icons.monetization_on_outlined,
            label: '$chips',
            onTap: () => context.push('/collection'),
          ),
      ],
    );
  }

  String _formLabel(String Function(String, [Map<String, Object?>]) t, String form) {
    return t('pet.form_$form');
  }
}

class _StripChip extends ConsumerWidget {
  const _StripChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlight = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    return Expanded(
      child: Material(
        color: highlight ? c.accent.withOpacity(0.12) : c.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 15, color: highlight ? c.accent : c.secondary),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    label,
                    style: NvType.caption(c).copyWith(
                      color: highlight ? c.accent : c.secondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StreakRiskBanner extends ConsumerWidget {
  const _StreakRiskBanner({required this.c, required this.t});
  final AppColors c;
  final String Function(String, [Map<String, Object?>]) t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsRowProvider).valueOrNull;
    final atRisk = StreakEngine.isAtRisk(
      stats?.lastContributionDay,
      kyivDateKey(),
    );
    if (!atRisk || (stats?.streakDays ?? 0) < 2) return const SizedBox.shrink();
    return NeonCard(
      accentBorder: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.local_fire_department_rounded, color: c.accent2, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(t('dashboard.streak_at_risk'), style: NvType.body(c)),
          ),
        ],
      ),
    );
  }
}

/// Bottom Navigation Bar 4 таби + FAB (§8.1) — shared across shell tabs.
class DashboardBottomBar extends ConsumerWidget {
  const DashboardBottomBar({super.key, required this.currentIndex});
  final int currentIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: c.surface,
        indicatorColor: c.accent.withOpacity(0.15),
        labelTextStyle: WidgetStatePropertyAll(NvType.caption(c)),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        height: 64,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.shield_outlined),
            selectedIcon: const Icon(Icons.shield_rounded),
            label: t('nav.dashboard'),
            enabled: currentIndex != 0,
          ),
          NavigationDestination(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            label: t('scanner.title'),
            enabled: currentIndex != 1,
          ),
          NavigationDestination(
            icon: const Icon(Icons.emoji_events_outlined),
            label: t('achievements.title'),
            enabled: currentIndex != 2,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            label: t('settings.title'),
            enabled: currentIndex != 3,
          ),
        ],
        onDestinationSelected: (i) => _tap(context, i),
      ),
    );
  }

  void _tap(BuildContext context, int i) {
    switch (i) {
      case 0:
        context.go('/dashboard');
      case 1:
        context.go('/scanner');
      case 2:
        context.go('/achievements');
      case 3:
        context.go('/settings');
    }
  }
}

/// ── Останнє поповнення (glanceable entry to §6.5 History) ───────────────
/// Hidden entirely when there are no contributions yet — no fake rows.
class _LastContributionBlock extends ConsumerWidget {
  const _LastContributionBlock();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final history = ref.watch(historyProvider).valueOrNull;
    if (history == null || history.isEmpty) return const SizedBox.shrink();
    final last = history.first; // newestFirst = true by default (§6.5)
    return NeonCard(
      onTap: () => context.push('/history'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: c.success.withOpacity(0.4)),
            ),
            child: Icon(Icons.add_rounded, color: c.success, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('dashboard.last_contribution'),
                    style: NvType.caption(c)),
                const SizedBox(height: 2),
                Text(
                  '+${formatMoneyShort(last.amount)} • ${formatDate(last.occurredAt)}',
                  style: NvType.button(c).copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 18, color: c.secondary),
        ],
      ),
    );
  }
}

/// FAB floating above bottom bar (§4.4/§8.1).
class FloatingAddMoneyButton extends ConsumerWidget {
  const FloatingAddMoneyButton({super.key, required this.onTap});
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(tProvider);
    final c = ref.watch(appColorsProvider);
    final reduced = ref.watch(reduceMotionProvider);
    return Semantics(
      button: true,
      label: t('dashboard.add_money'),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 150,
          height: 52,
          decoration: BoxDecoration(
            color: c.accent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: reduced
                ? null
                : [
                    const BoxShadow(
                      // Soft black lift instead of the neon glow.
                      color: Color(0x59000000),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded,
                  color: ref.watch(appColorsProvider).background),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  t('dashboard.add_money'),
                  style: NvType.button(ref.watch(appColorsProvider))
                      .copyWith(color: ref.watch(appColorsProvider).background),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rate App dialog (§6.16) — In-App Review API binding point.
Future<void> showRateAppDialog(BuildContext context, WidgetRef ref) async {
  final t = ref.read(tProvider);
  final rate = ref.read(rateAppRepositoryProvider);
  final ignore = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(t('settings.rate_app')),
      content: Text(t('common.app_name')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(t('onboarding.notification_later')),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(t('settings.rate_app')),
        ),
      ],
    ),
  );
  await rate.onPromptShown(ignored: ignore ?? true);
}

extension _L10nKeys on String {
  // Named keys kept short in the dashboard file.
}

/// ── First Deposit Surprise Dialog ─────────────────────────────────────────
class _FirstDepositSurpriseDialog extends ConsumerWidget {
  const _FirstDepositSurpriseDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: NeonCard(
        padding: const EdgeInsets.all(32),
        accentBorder: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.redeem_rounded, size: 80, color: c.accent),
            const SizedBox(height: 24),
            Text(
              t('dashboard.first_deposit_title', {'default': 'First Deposit!'}),
              style: NvType.h1(c),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              t('dashboard.first_deposit_body', {'default': 'You just started your journey to your dream setup. Keep it going!'}),
              style: NvType.body(c),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            NeonGradientButton(
              label: t('common.done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

/// ── Tutorial Quest Card ───────────────────────────────────────────────────
class _TutorialQuestCard extends ConsumerWidget {
  const _TutorialQuestCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final stats = ref.watch(statsRowProvider).valueOrNull;
    final hasFirstDeposit = (stats?.contributionsCount ?? 0) > 0;

    if (hasFirstDeposit) return const SizedBox.shrink();

    return NeonCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school_rounded, color: c.accent2, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t('dashboard.tutorial_title', {'default': 'Welcome to NeoVault'}),
                  style: NvType.button(c),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _QuestRow(
            label: t('dashboard.tutorial_goal', {'default': 'Set up your goal'}),
            isDone: true,
          ),
          const SizedBox(height: 8),
          _QuestRow(
            label: t('dashboard.tutorial_deposit', {'default': 'Make your first deposit'}),
            isDone: hasFirstDeposit,
          ),
        ],
      ),
    );
  }
}

class _QuestRow extends ConsumerWidget {
  const _QuestRow({required this.label, required this.isDone});
  final String label;
  final bool isDone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    return Row(
      children: [
        Icon(
          isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          color: isDone ? c.success : c.secondary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: NvType.bodySecondary(c).copyWith(
              decoration: isDone ? TextDecoration.lineThrough : null,
              color: isDone ? c.secondary : c.text,
            ),
          ),
        ),
      ],
    );
  }
}

/// (27)/(30) Dashboard motivation strip: when vacation mode is on, show an
/// honest banner; otherwise show ONE of the user's quick phrases (a new one
/// each day — deterministic by Kyiv date).
class _DashboardMotivationBanner extends ConsumerWidget {
  const _DashboardMotivationBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final vacation = ref.watch(vacationModeProvider).valueOrNull ?? false;
    if (vacation) {
      return _BannerLine(
        icon: Icons.luggage_rounded,
        text: t('settings.vacation_banner'),
        color: c.accent2,
      );
    }
    final phrases =
        ref.watch(quickPhrasesProvider).valueOrNull ?? const <String>[];
    if (phrases.isEmpty) return const SizedBox.shrink();
    final idx = kyivDateKey().hashCode.abs() % phrases.length;
    return _BannerLine(
      icon: Icons.format_quote_rounded,
      text: phrases[idx],
      color: c.accent,
    );
  }
}

class _BannerLine extends ConsumerWidget {
  const _BannerLine(
      {required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: NvType.caption(c).copyWith(color: c.text)),
          ),
        ],
      ),
    );
  }
}
