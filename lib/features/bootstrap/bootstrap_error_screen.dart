import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart' show SnackX;

/// Zero-white-screen guarantee: if the pre-`runApp` bootstrap throws
/// (DB open, Keystore, prefs…), the user still gets a themed, localized
/// screen with the reason and a real Retry action — never a dead white
/// surface. Colors are static constants on purpose: Riverpod/theme engine
/// may be the failing subsystem, so no providers are trusted here.
class BootstrapErrorApp extends StatelessWidget {
  const BootstrapErrorApp({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeoVault',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(NvThemeData.cyberpunkNeon),
      // Forced UA locale → Global delegates (Default* is English-only and
      // leaves MaterialLocalizations null for 'uk').
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('uk'), Locale('en')],
      locale: const Locale('uk'),
      home: BootstrapErrorScreen(error: error, onRetry: onRetry),
    );
  }
}

class BootstrapErrorScreen extends StatelessWidget {
  const BootstrapErrorScreen({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    // Static palette: providers are not trusted during a bootstrap failure.
    final c = AppColors.from(NvThemeData.cyberpunkNeon);
    // l10n is a bundled asset — independent of the failed DB/bootstrap. If
    // even that read fails, raw keys keep the screen functional.
    return FutureBuilder<NvStrings>(
      future: NvStrings.load(NvStrings.ua),
      builder: (context, snap) {
        String t(String key) {
          final s = snap.data;
          return s == null ? key : s.t(key);
        }

        final errorText = error.toString();

        return Scaffold(
          backgroundColor: c.background,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: c.danger, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: c.danger.withOpacity(0.25),
                              blurRadius: 28,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(Icons.error_outline_rounded,
                            size: 42, color: c.danger),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      t('bootstrap.error_title'),
                      textAlign: TextAlign.center,
                      style: NvType.h1(c).copyWith(color: c.text),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      t('bootstrap.error_hint'),
                      textAlign: TextAlign.center,
                      style: NvType.bodySecondary(c),
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      key: const Key('bootstrap_retry'),
                      onPressed: onRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.accent,
                        foregroundColor: c.background,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(
                        t('common.retry'),
                        style: NvType.button(c),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        key: const Key('bootstrap_details_tile'),
                        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                        childrenPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        collapsedIconColor: c.secondary,
                        iconColor: c.secondary,
                        title: Text(
                          t('bootstrap.error_details'),
                          style:
                              NvType.body(c).copyWith(color: c.secondary),
                        ),
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: c.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: c.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  errorText,
                                  style: NvType.body(c).copyWith(
                                    color: c.danger,
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: errorText));
                                    if (context.mounted) {
                                      context.toast(t('common.copied'));
                                    }
                                  },
                                  icon: Icon(Icons.copy_rounded,
                                      size: 16, color: c.accent),
                                  label: Text(
                                    t('common.copy'),
                                    style: NvType.body(c)
                                        .copyWith(color: c.accent),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
