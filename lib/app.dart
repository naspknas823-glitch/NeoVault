import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/utils/format.dart' show stringsProvider, tProvider;
import 'core/router/app_router.dart';
import 'core/security/pin_gate.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'data/repositories/system_repositories.dart'
    show pinRepositoryProvider;
import 'data/repositories/ui_providers.dart';
import 'shared/widgets/widgets.dart';

/// NeoVault app widget (§4 design language applied globally).
///
/// HOTFIX v0.9.0+9.2: the router is created ONCE per app lifetime (previously
/// a new GoRouter was built on every rebuild — theme switch reset navigation)
/// and is wired to the PIN gate (§6.22): splash sets the lock when a PIN
/// exists, the autolock observer re-locks after a long background stay, and
/// [PinLockScreen] clears it after a successful verify.
class NeoVaultApp extends ConsumerStatefulWidget {
  const NeoVaultApp({super.key, this.router});

  final GoRouter? router;

  @override
  ConsumerState<NeoVaultApp> createState() => _NeoVaultAppState();
}

class _NeoVaultAppState extends ConsumerState<NeoVaultApp>
    with WidgetsBindingObserver {
  GoRouter? _router;
  bool _gateLocked = false;
  DateTime? _hiddenAt;
  late final _RouterRefresh _refresh = _RouterRefresh();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.router == null) {
      _gateLocked = ref.read(pinGateProvider);
      // Keep the router redirect in sync with the PIN gate (§6.22).
      ref.listenManual(pinGateProvider, (prev, next) {
        _gateLocked = next;
        _refresh.refresh();
      });
      _router = buildRouter(
        refreshListenable: _refresh,
        isLocked: () => _gateLocked,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Autolock (§6.22): backgrounded for ≥ the configured interval with a PIN
  /// set → re-lock; next user-visible frame is the PIN screen.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _hiddenAt ??= DateTime.now();
      return;
    }
    if (state == AppLifecycleState.resumed && _hiddenAt != null) {
      final hiddenAt = _hiddenAt!;
      _hiddenAt = null;
      _relockIfNeeded(hiddenAt);
    }
  }

  Future<void> _relockIfNeeded(DateTime hiddenAt) async {
    try {
      final pin = ref.read(pinRepositoryProvider);
      if (!await pin.hasPin()) return;
      final limitMinutes = await pin.autolockMinutes();
      final elapsed = DateTime.now().difference(hiddenAt);
      if (elapsed.inMinutes >= limitMinutes) {
        ref.read(pinGateProvider.notifier).state = true;
      }
    } catch (e) {
      debugPrint('NV autolock re-lock failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeControllerProvider);
    final tAsync = ref.watch(stringsProvider);

    // ⚠️ GlobalMaterialLocalizations is MANDATORY here: the app forces the
    // UA locale (§2), and DefaultMaterialLocalizations ships English only —
    // with it, MaterialLocalizations resolves to null under locale 'uk' and
    // the first TextField throws "No MaterialLocalizations found" on device.
    const delegates = [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
    const locales = [Locale('uk'), Locale('en')];

    return tAsync.when(
      loading: () => MaterialApp(
        theme: buildTheme(theme),
        localizationsDelegates: delegates,
        supportedLocales: locales,
        locale: const Locale('uk'),
        home: const Scaffold(body: SizedBox.shrink()),
      ),
      error: (e, st) => MaterialApp(
        theme: buildTheme(theme),
        localizationsDelegates: delegates,
        supportedLocales: locales,
        locale: const Locale('uk'),
        home: const Scaffold(body: SizedBox.shrink()),
      ),
      data: (strings) {
        final router = widget.router ?? _router ?? buildRouter();
        return MaterialApp.router(
          title: 'NeoVault',
          theme: buildTheme(theme),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: delegates,
          supportedLocales: locales,
          locale: const Locale('uk'),
          routerConfig: router,
          builder: (context, child) {
            // ONLINE-ONLY: a global honest banner when the device has no
            // internet — no offline data substitution anywhere (⛔ v0.9.2).
            final online = ref.watch(onlineProvider).valueOrNull ?? true;
            return Column(
              children: [
                if (!online) const _OfflineBanner(),
                Expanded(child: child ?? const SizedBox.shrink()),
              ],
            );
          },
        );
      },
    );
  }
}

/// Bridges the Riverpod PIN-gate changes into go_router's
/// `refreshListenable` so the redirect re-evaluates on lock/unlock.
class _RouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}

/// Honest global offline banner (ONLINE-ONLY app, ⛔ no offline mode):
/// shown on every screen while the device has no internet connection.
class _OfflineBanner extends ConsumerWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(appColorsProvider);
    final t = ref.watch(tProvider);
    return Material(
      color: c.danger,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              const Icon(Icons.wifi_off_rounded, size: 15, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  t('common.offline_banner'),
                  style: NvType.caption(c).copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
