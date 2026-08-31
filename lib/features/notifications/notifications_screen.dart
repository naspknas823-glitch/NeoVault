import 'dart:convert';
import '../../core/db/app_database.dart';
import '../../core/utils/format.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/system_repositories.dart';
import '../../data/repositories/ui_providers.dart';
import '../../shared/widgets/widgets.dart';

/// 6.10 Notification Center (§6.10): full-screen list, type icons (neon
/// vectors — no emoji), filter tabs, swipe read/delete, mark-all-read,
/// tap → deep link.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _tab = 'all';

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final items = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(t('notifications.title')),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(notificationsRepositoryProvider).markAllRead();
            },
            child: Text(t('notifications.mark_all_read')),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
          TabBar(
            tabs: [
              Tab(text: t('notifications.tab_all')),
              Tab(text: t('notifications.tab_prices')),
              Tab(text: t('notifications.tab_achievements')),
              Tab(text: t('notifications.tab_system')),
            ],
            onTap: (i) => setState(() {
              _tab = switch (i) {
                1 => 'prices',
                2 => 'achievements',
                3 => 'system',
                _ => 'all',
              };
            }),
          ),
            Expanded(
              child: AsyncValueView<List<NotificationsCacheData>>(
                value: items,
                isEmpty: (list) => _filtered(list).isEmpty,
                empty: EmptyState(
                  title: t('notifications.empty'),
                  body: '',
                  icon: Icons.notifications_none_rounded,
                ),
                content: (list) => ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: _filtered(list).length,
                  itemBuilder: (context, i) =>
                      _NotifTile(item: _filtered(list)[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<NotificationsCacheData> _filtered(List<NotificationsCacheData> all) {
    if (_tab == 'all') return all;
    if (_tab == 'prices') return all.where((n) => n.type == 'prices').toList();
    if (_tab == 'achievements') {
      return all
          .where((n) => n.type == 'achievements' || n.type == 'levels')
          .toList();
    }
    return all.where((n) => n.type == 'system').toList();
  }
}

class _NotifTile extends ConsumerWidget {
  const _NotifTile({required this.item});
  final NotificationsCacheData item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    final repo = ref.read(notificationsRepositoryProvider);
    final icon = switch (item.type) {
      'prices' => Icons.trending_down_rounded,
      'achievements' => Icons.emoji_events_rounded,
      'levels' => Icons.trending_up_rounded,
      'contrib' => Icons.savings_rounded,
      _ => Icons.settings_rounded,
    };
    Map<String, Object?> parsed = const {};
    try {
      parsed = (jsonDecode(item.bodyParamsJson) as Map<String, dynamic>?)
              ?.cast<String, Object?>() ??
          const {};
    } on FormatException {
      parsed = const {};
    }
    final body = t(item.bodyKey, parsed);

    return Dismissible(
      key: ValueKey(item.id),
      background: _swipeBg(c.accent, t('notifications.swipe_read')),
      secondaryBackground: _swipeBg(c.danger, t('notifications.swipe_delete')),
      onDismissed: (_) => repo.delete(item.id),
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) {
          await repo.markRead(item.id);
          return false; // swipe → read only, keep the row
        }
        return true; // swipe end → delete
      },
      child: ListTile(
        leading: Icon(icon, color: item.read ? c.secondary : c.accent),
        title: Text(
          t(item.titleKey),
          style: NvType.button(c).copyWith(
            fontWeight: item.read ? FontWeight.w400 : FontWeight.w600,
          ),
        ),
        subtitle: Text(body, style: NvType.caption(c)),
        trailing: item.read
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: c.accent, shape: BoxShape.circle),
              ),
        onTap: () => repo.markRead(item.id),
      ),
    );
  }

  Widget _swipeBg(Color color, String label) {
    return Container(
      color: color.withOpacity(0.15),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      child: Text(label),
    );
  }
}
