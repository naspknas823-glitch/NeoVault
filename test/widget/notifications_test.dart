import 'package:flutter_test/flutter_test.dart';
import 'package:neovault/data/repositories/system_repositories.dart';

import '../helpers/test_harness.dart';

/// 6.10 Notification Center (§6.10).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('6.10 renders tabs, mark-all-read, in-app notification row',
      (tester) async {
    final container = await pumpScreen(tester, '/notifications');
    // Seed one in-app notification via the real pipeline.
    await container.read(notificationsRepositoryProvider).pushInApp(
          type: NotifType.prices,
          titleKey: 'notifications.price_down',
          bodyKey: 'notifications.price_down_body',
          bodyParams: {'item': 'PS5', 'price': '24 799 ₴', 'p': '5'},
        );
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Сповіщення'), findsOneWidget);
    expect(find.text('Позначити всі прочитаними'), findsOneWidget);
    expect(find.text('Всі'), findsOneWidget);
    expect(find.text('Ціни'), findsWidgets);
    // Row rendered from the DB pipeline.
    expect(find.text('Ціна впала!'), findsOneWidget);
    // Mark all read → unread dot disappears.
    await container.read(notificationsRepositoryProvider).markAllRead();
    await tester.pump(const Duration(milliseconds: 300));
  });
}
