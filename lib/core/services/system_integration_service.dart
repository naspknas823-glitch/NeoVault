import 'package:flutter/foundation.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/system_repositories.dart';

/// (7) App Shortcuts — registered on startup, handled in app.dart lifecycle.
const _quickActionAddMoney = 'action_add_money';
const _quickActionViewProgress = 'action_view_progress';

/// (6) Interactive Notification — wrapper around flutter_local_notifications.
///
/// Supports:
/// - Scheduled savings reminders with "Add Now" action.
/// - Post-salary deposit prompt (Module 3 integration point).
///
/// (4) Home Screen Widget / (5) Lock Screen Widget — powered by home_widget.
/// Updates are pushed from [updateHomeWidget] after any contribution.

class SystemIntegrationService {
  SystemIntegrationService(this._ref);
  final Ref _ref;

  static final _fln = FlutterLocalNotificationsPlugin();
  static var _flnInitialized = false;

  // ── Initialization ─────────────────────────────────────────────────────────

  /// Standalone bootstrap — call from main() before ProviderScope is ready.
  /// Does NOT need a Ref (no DB access).
  static Future<void> initStandalone() async {
    try {
      await _initNotificationsStatic();
      await _initHomeWidgetStatic();
      await _setupQuickActionsStatic();
    } catch (e) {
      debugPrint('NV SystemIntegrationService.initStandalone failed: $e');
    }
  }

  static Future<void> _initNotificationsStatic() async {
    if (_flnInitialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: darwin, macOS: darwin);
    await _fln.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationAction,
      onDidReceiveBackgroundNotificationResponse: _bgNotificationAction,
    );
    _flnInitialized = true;
  }

  static Future<void> _initHomeWidgetStatic() async {
    try {
      await HomeWidget.setAppGroupId('group.ua.neovault');
      await HomeWidget.registerInteractivityCallback(_homeWidgetCallback);
    } catch (e) {
      debugPrint('NV home_widget init failed: $e');
    }
  }

  static Future<void> _setupQuickActionsStatic() async {
    try {
      const qa = QuickActions();
      await qa.initialize((type) {
        _pendingRoute = type == _quickActionAddMoney
            ? '/dashboard?action=add_money'
            : '/dashboard';
      });
      await qa.setShortcutItems([
        const ShortcutItem(
          type: _quickActionAddMoney,
          localizedTitle: 'Додати гроші',
          icon: 'ic_add_money',
        ),
        const ShortcutItem(
          type: _quickActionViewProgress,
          localizedTitle: 'Мій прогрес',
          icon: 'ic_progress',
        ),
      ]);
    } catch (e) {
      debugPrint('NV quick_actions setup failed: $e');
    }
  }

  /// Call from main() / app bootstrap once.
  Future<void> initialize() async {
    await _initNotificationsStatic();
    await _initHomeWidgetStatic();
  }

  // ── (7) App Shortcuts ──────────────────────────────────────────────────────

  /// Register quick-action shortcuts. Returns the shortcut that was tapped
  /// when the app was cold-launched via a shortcut, or null.
  Future<String?> setupQuickActions() async {
    String? launchShortcut;
    try {
      const qa = QuickActions();
      await qa.initialize((type) {
        launchShortcut = type;
      });
      await qa.setShortcutItems([
        const ShortcutItem(
          type: _quickActionAddMoney,
          localizedTitle: 'Додати гроші',
          icon: 'ic_add_money',
        ),
        const ShortcutItem(
          type: _quickActionViewProgress,
          localizedTitle: 'Мій прогрес',
          icon: 'ic_progress',
        ),
      ]);
    } catch (e) {
      debugPrint('NV quick_actions setup failed: $e');
    }
    return launchShortcut;
  }

  // ── (6) Interactive Notification ───────────────────────────────────────────

  static const _channelId = 'nv_savings_reminder';
  static const _channelName = 'Нагадування про заощадження';
  static const _actionAddNow = 'add_money_now';
  static const _actionLater = 'later';

  /// Request notification permission (call on first launch / post-setup-wizard).
  Future<bool> requestNotificationPermission() async {
    try {
      final android = _fln.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }
      final ios = _fln.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        final result = await ios.requestPermissions(alert: true, badge: true, sound: true);
        return result ?? false;
      }
    } catch (e) {
      debugPrint('NV notification permission failed: $e');
    }
    return false;
  }

  /// Show an interactive savings reminder notification.
  ///
  /// Android: shows action buttons "Додати зараз" / "Пізніше".
  /// iOS: shows standard alert (action buttons require notification categories,
  ///      which can be registered via DarwinInitializationSettings if needed).
  Future<void> showSavingsReminder({
    required String title,
    required String body,
    int id = 1,
  }) async {
    if (!_flnInitialized) return;
    final android = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Нагадування про заощадження в NeoVault',
      importance: Importance.high,
      priority: Priority.high,
      actions: [
        const AndroidNotificationAction(
          _actionAddNow,
          'Додати зараз',
          showsUserInterface: true,
        ),
        const AndroidNotificationAction(
          _actionLater,
          'Пізніше',
          cancelNotification: true,
        ),
      ],
    );
    const darwin = DarwinNotificationDetails();
    final details = NotificationDetails(android: android, iOS: darwin);
    try {
      await _fln.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: _actionAddNow,
      );
    } catch (e) {
      debugPrint('NV showSavingsReminder failed: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _fln.cancel(id: id);
    } catch (e) {
      debugPrint('NV cancelNotification($id) failed: $e');
    }
  }

  // ── (4) Home Screen Widget / (5) Lock Screen Widget ───────────────────────

  /// Push current savings progress to the home/lock screen widget.
  ///
  /// Requires platform-side widget implementation (Android AppWidget XML /
  /// iOS WidgetKit Extension). This service writes the data; the widget
  /// reads it via shared app group / shared preferences.
  Future<void> updateHomeWidget() async {
    try {
      final goals = _ref.read(goalRepositoryProvider);
      final stats = await goals.rawStats();
      final goal = await goals.getGoal();
      final totalTarget = (goal?.ps5Target ?? 0) + (goal?.monitorTarget ?? 0);
      final saved = goal?.saved ?? 0;
      final percent = totalTarget > 0 ? (saved / totalTarget).clamp(0.0, 1.0) : 0.0;

      await HomeWidget.saveWidgetData<int>('nv_saved', saved);
      await HomeWidget.saveWidgetData<int>('nv_target', totalTarget);
      await HomeWidget.saveWidgetData<int>('nv_percent', (percent * 100).round());
      await HomeWidget.saveWidgetData<String>(
        'nv_title', goal?.title ?? 'NeoVault',
      );
      await HomeWidget.updateWidget(
        androidName: 'NeoVaultWidget',
        iOSName: 'NeoVaultWidget',
        qualifiedAndroidName: 'ua.neovault.NeoVaultWidget',
      );
    } catch (e) {
      debugPrint('NV updateHomeWidget failed: $e');
    }
  }

  // ── (24) Dynamic Icon ──────────────────────────────────────────────────────
  
  /// Update the app icon based on the user's level or rank.
  Future<void> updateDynamicIcon(int level) async {
    try {
      final supported = await FlutterDynamicIconPlus.supportsAlternateIcons;
      if (!supported) return;

      String iconName;
      if (level >= 10) {
        iconName = 'diamond';
      } else if (level >= 7) {
        iconName = 'platinum';
      } else if (level >= 5) {
        iconName = 'gold';
      } else if (level >= 3) {
        iconName = 'silver';
      } else {
        iconName = 'bronze'; // Or default icon
      }

      await FlutterDynamicIconPlus.setAlternateIconName(iconName: iconName);
    } catch (e) {
      debugPrint('NV updateDynamicIcon failed: $e');
    }
  }

  // ── Handlers (static — needed for background isolate) ─────────────────────

  static void _onNotificationAction(NotificationResponse r) {
    if (r.actionId == _actionAddNow || r.payload == _actionAddNow) {
      // Deep-link handled by go_router via notificationLaunchRouteProvider.
      _pendingRoute = '/dashboard?action=add_money';
    }
  }

  /// Stored pending deep-link from notification tap (consumed in NeoVaultApp).
  static String? _pendingRoute;
  static String? consumePendingRoute() {
    final r = _pendingRoute;
    _pendingRoute = null;
    return r;
  }
}

/// Background notification handler (must be top-level).
@pragma('vm:entry-point')
void _bgNotificationAction(NotificationResponse r) {
  SystemIntegrationService._pendingRoute =
      '/dashboard?action=add_money';
}

/// Background home_widget callback (must be top-level).
@pragma('vm:entry-point')
Future<void> _homeWidgetCallback(Uri? uri) async {
  debugPrint('NV home_widget tapped: $uri');
}

/// Riverpod provider for [SystemIntegrationService].
final systemIntegrationProvider = Provider<SystemIntegrationService>(
  (ref) => SystemIntegrationService(ref),
);
