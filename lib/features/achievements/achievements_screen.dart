import 'package:flutter/material.dart';
import '../dashboard/add_money_sheet.dart';
import '../dashboard/dashboard_screen.dart';
import '../../core/utils/format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/ui_providers.dart';
import '../../domain/gamification/achievements.dart';
import '../collection/collection_screen.dart' show CollectionView;
import '../leaderboard/leaderboard_screen.dart' show LeaderboardView;
import '../../shared/widgets/widgets.dart';

/// 6.9 Achievements (§6.9) with segment switcher «Досягнення | Колекція |
/// Лідери» (§10.9 Retention-в'їзди — no new tabs ⛔).
class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key, this.initialSegment = 0});
  final int initialSegment;

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  late int _segment = widget.initialSegment;
  AchievementCategory? _filter;
  final Set<String> _celebrated = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('achievements');
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          _segment == 0
              ? t('achievements.title')
              : _segment == 1
                  ? t('collection.title')
                  : t('leaderboard.title'),
        ),
        bottom: TabBar(
          onTap: (i) => setState(() => _segment = i),
          tabs: [
            Tab(text: t('achievements.segment_achievements')),
            Tab(text: t('achievements.segment_collection')),
            Tab(text: t('achievements.segment_leaders')),
          ],
        ),
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
      bottomNavigationBar: const DashboardBottomBar(currentIndex: 2),
      body: Builder(
        builder: (context) {
          // Lazy segments: the leaderboard opt-in dialog (§10.4) must only
          // appear when the Leaders segment is actually opened.
          return switch (_segment) {
            1 => const _CollectionSegment(),
            2 => const _LeadersSegment(),
            _ => _AchievementsGrid(
                filter: _filter,
                onFilter: (f) => setState(() => _filter = f),
                celebrated: _celebrated,
              ),
          };
        },
      ),
      ),
    );
  }
}

/// ── Achievements grid (§6.9): 3 columns, unlocked neon / locked greyed /
/// secret «???», progress, category filters, unboxing celebration. ────────
class _AchievementsGrid extends ConsumerWidget {
  const _AchievementsGrid({
    required this.filter,
    required this.onFilter,
    required this.celebrated,
  });
  final AchievementCategory? filter;
  final ValueChanged<AchievementCategory?> onFilter;
  final Set<String> celebrated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final list = ref.watch(achievementsProvider);

    return AsyncValueView<List<(AchievementDef, DateTime?)>>(
      value: list,
      content: (items) {
        final filtered = filter == null
            ? items
            : items.where((e) => e.$1.category == filter).toList();
        final unlockedCount = items.where((e) => e.$2 != null).length;
        // Total bonus XP earned from unlocked achievements (§5.3, real sum).
        final bonusTotal = items
            .where((e) => e.$2 != null)
            .fold<int>(0, (sum, e) => sum + e.$1.bonusXp);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '$unlockedCount / ${items.length}',
                    style: NvType.button(c).copyWith(color: c.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: NeonProgressBar(
                        value: items.isEmpty
                            ? 0
                            : unlockedCount / items.length,
                        height: 6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    t('achievements.bonus_total', {'n': bonusTotal}),
                    style: NvType.caption(c).copyWith(color: c.accent2),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ChoiceChip(
                    label: Text(t('achievements.filter_all')),
                    selected: filter == null,
                    onSelected: (_) => onFilter(null),
                  ),
                  const SizedBox(width: 8),
                  for (final cat in AchievementCategory.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(t('achievements.${cat.l10nKey}')),
                        selected: filter == cat,
                        onSelected: (_) => onFilter(cat),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.78,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final (def, unlockedAt) = filtered[i];
                  return _AchTile(
                    def: def,
                    unlockedAt: unlockedAt,
                    celebrate: def.id == _lastUnlocked(context, ref, filtered),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Returns the most-recently unlocked achievement id for the unboxing
  /// moment (§6.9) — fires once per celebration set.
  String? _lastUnlocked(
    BuildContext context,
    WidgetRef ref,
    List<(AchievementDef, DateTime?)> items,
  ) {
    final recent = items
        .where((e) => e.$2 != null && !celebrated.contains(e.$1.id))
        .toList()
      ..sort((a, b) => b.$2!.compareTo(a.$2!));
    if (recent.isEmpty) return null;
    return recent.first.$1.id;
  }
}

class _AchTile extends ConsumerWidget {
  const _AchTile({
    required this.def,
    required this.unlockedAt,
    required this.celebrate,
  });

  final AchievementDef def;
  final DateTime? unlockedAt;
  final bool celebrate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final isUnlocked = unlockedAt != null;
    final label = isUnlocked || !def.secret ? def.name : t('achievements.secret_hint');

    final tile = NeonCard(
      onTap: isUnlocked ? () => _share(context, ref) : null,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Icon(
                isUnlocked ? Icons.workspace_premium_rounded : Icons.lock_outline_rounded,
                size: 34,
                color: isUnlocked ? c.accent : c.secondary,
              ),
              if (celebrate && isUnlocked)
                const Positioned.fill(child: MiniConfetti()),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: NvType.caption(c).copyWith(
              color: isUnlocked ? c.text : c.secondary,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          if (isUnlocked)
            Text(
              '+${def.bonusXp} XP',
              style: NvType.caption(c).copyWith(color: c.accent2),
            )
          else
            Text(t('achievements.locked'), style: NvType.caption(c)),
        ],
      ),
    );

    if (isUnlocked) return tile;
    return Opacity(opacity: 0.45, child: tile);
  }

  void _share(BuildContext context, WidgetRef ref) {
    final t = ref.read(tProvider);
    context.toast(
      t('achievements.share_text', {'name': def.name, 'xp': def.bonusXp}),
    );
  }
}

/// Collection & Leaders segments delegate to their screens.
class _CollectionSegment extends StatelessWidget {
  const _CollectionSegment();
  @override
  Widget build(BuildContext context) {
    return const CollectionView();
  }
}

class _LeadersSegment extends StatelessWidget {
  const _LeadersSegment();
  @override
  Widget build(BuildContext context) {
    return const LeaderboardView();
  }
}
