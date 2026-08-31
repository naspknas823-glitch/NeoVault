import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/repositories/goal_repository.dart';
import '../../core/db/app_database.dart' show EventQuest;
import '../../data/repositories/retention_repositories.dart';
import '../../data/repositories/ui_providers.dart';
import '../../shared/widgets/widgets.dart';

/// 6.30 Event Hub (§10.7/§6.30): hero banner with countdown, event quest
/// line (3–5) with progress, rewards with claimed states, rules, finale
/// reminder; summary after the end; empty state when no event active.
class EventScreen extends ConsumerStatefulWidget {
  const EventScreen({super.key});

  @override
  ConsumerState<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalRepositoryProvider).trackScreenVisit('events');
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final event = ref.watch(activeEventProvider).valueOrNull;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(title: Text(t('events.title'))),
      body: event == null
          ? EmptyState(
              title: t('events.no_event'),
              body: t('events.no_event_body'),
              icon: Icons.celebration_outlined,
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Hero banner with countdown (§6.30).
                NeonCard(
                  accentBorder: true,
                  breathing: true,
                  child: Column(
                    children: [
                      Icon(Icons.ac_unit_rounded, size: 44, color: c.accent),
                      const SizedBox(height: 8),
                      Text(t(event.titleKey), style: NvType.h1(c).copyWith(fontSize: 24)),
                      const SizedBox(height: 6),
                      // Чесний countdown (§10.7 FOMO without dark patterns).
                      Builder(builder: (context) {
                        ref.watch(countdownTickProvider);
                        return Text(
                          t('events.ends_in', {
                            't': formatCountdown(
                              DateTime.fromMillisecondsSinceEpoch(event.endsAt)
                                  .difference(DateTime.now()),
                            ),
                          }),
                          style: NvType.h2(c).copyWith(color: c.accent, fontSize: 16),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(t('events.quests'), style: NvType.h2(c).copyWith(fontSize: 16)),
                const SizedBox(height: 8),
                _EventQuests(eventId: event.id),
                const SizedBox(height: 12),
                Text(t('events.rewards'), style: NvType.h2(c).copyWith(fontSize: 16)),
                const SizedBox(height: 8),
                NeonCard(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.pets_rounded, color: c.accent),
                        title: Text(t('events.reward_skin'), style: NvType.body(c)),
                      ),
                      ListTile(
                        leading: Icon(Icons.style_rounded, color: c.accent),
                        title: Text(t('events.reward_card'), style: NvType.body(c)),
                      ),
                      ListTile(
                        leading: Icon(Icons.military_tech_rounded, color: c.accent2),
                        title: Text(t('events.reward_badge'), style: NvType.body(c)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(t('events.rules'), style: NvType.h2(c).copyWith(fontSize: 16)),
                const SizedBox(height: 8),
                NeonCard(
                  child: Text(t('odds.no_money'), style: NvType.bodySecondary(c)),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () async {
                    await ref
                        .read(eventsRepositoryProvider)
                        .markReminderSet(event.id);
                    if (context.mounted) context.toast(t('events.remind_set'));
                  },
                  child: Text(t('events.remind_final')),
                ),
              ],
            ),
    );
  }
}

class _EventQuests extends ConsumerWidget {
  const _EventQuests({required this.eventId});
  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return FutureBuilder<List<EventQuest>>(
      future: ref.read(eventsRepositoryProvider).eventQuests(eventId),
      builder: (context, snap) {
        final quests = snap.data ?? const [];
        return Column(
          children: [
            for (final q in quests)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: NeonCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            q.claimed
                                ? Icons.verified_rounded
                                : Icons.emoji_events_outlined,
                            size: 20,
                            color: q.claimed ? c.success : c.accent,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(t(q.titleKey), style: NvType.body(c)),
                          ),
                          Text('${q.progress}/${q.target}',
                              style: NvType.caption(c)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      NeonProgressBar(
                          value: q.target <= 0 ? 0 : q.progress / q.target,
                          height: 6),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: q.claimed
                            ? Text(t('events.claimed'),
                                style: NvType.caption(c).copyWith(color: c.success))
                            : ElevatedButton(
                                onPressed: q.progress >= q.target
                                    ? () async {
                                        await ref
                                            .read(eventsRepositoryProvider)
                                            .claimEventQuest(q);
                                        if (context.mounted) {
                                          context.toast(t('events.claimed'));
                                        }
                                      }
                                    : null,
                                child: Text(t('events.claim'),
                                    style: const TextStyle(fontSize: 12)),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
