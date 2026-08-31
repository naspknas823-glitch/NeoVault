import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

/// NeoVault design language (spec §4, premium rework v0.9.1):
/// deep graphite + champagne gold + muted emerald — a "trust & wealth"
/// financial palette instead of the acid gamer-neon one.
abstract final class NvPalette {
  // Dark theme (base)
  static const Color bgDark = Color(0xFF121214); // deep graphite
  static const Color surfaceDark = Color(0xFF1B1B1F); // elevated graphite
  static const Color accentGold = Color(0xFFD4B26A); // champagne gold
  static const Color goldSoft = Color(0xFFEAD9AC); // pale champagne
  static const Color emerald = Color(0xFF4E9C72); // muted emerald
  static const Color rose = Color(0xFFD9707A); // muted danger
  static const Color textPrimary = Color(0xFFF2F1EC); // warm ivory
  static const Color textSecondary = Color(0xFF9A978D); // warm grey
  static const Color border = Color(0x2E9A978D); // rgba(154,151,141,0.18)

  // Light theme: warm paper + deep gold
  static const Color bgLight = Color(0xFFF7F6F2);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color goldDeep = Color(0xFF9C7A28);
  static const Color bronzeSoft = Color(0xFFB08D4A);
  static const Color emeraldLight = Color(0xFF3D7D5B);
  static const Color roseLight = Color(0xFFC2555E);
  static const Color textPrimaryLight = Color(0xFF201F1B);
  static const Color textSecondaryLight = Color(0xFF6E6B62);
  static const Color borderLight = Color(0x336E6B62);

  /// Subtle champagne shimmer for progress bars (replaces the acid
  /// cyan→green gradient).
  static const Gradient progressGradient = LinearGradient(
    colors: [accentGold, goldSoft],
  );
}

/// Theme ids for Theme Gallery (§6.12, §4.9).
enum NvThemeId {
  cyberpunkNeon('cyberpunk_neon'),
  lightMode('light_mode'),
  oceanBlue('ocean_blue'),
  sunsetPurple('sunset_purple'),
  mintFresh('mint_fresh');

  const NvThemeId(this.id);
  final String id;

  static NvThemeId fromId(String id) => NvThemeId.values.firstWhere(
        (t) => t.id == id,
        orElse: () => NvThemeId.cyberpunkNeon,
      );
}

/// XP required to unlock XP-gated themes (§4.9: 500 and 1200 XP).
const int kOceanBlueUnlockXp = 500;
const int kSunsetPurpleUnlockXp = 500;
const int kMintFreshUnlockXp = 1200;

/// Per-theme accent definitions (§4.9 presets).
class NvThemeData {
  const NvThemeData({
    required this.id,
    required this.brightness,
    required this.background,
    required this.surface,
    required this.accent,
    required this.accent2,
    required this.success,
    required this.danger,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
  });

  final NvThemeId id;
  final Brightness brightness;
  final Color background;
  final Color surface;
  final Color accent;
  final Color accent2;
  final Color success;
  final Color danger;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;

  // Default preset — «Graphite & Gold». NOTE: id stays 'cyberpunk_neon' for
  // backward compatibility with persisted settings (ThemeController.load).
  static const NvThemeData cyberpunkNeon = NvThemeData(
    id: NvThemeId.cyberpunkNeon,
    brightness: Brightness.dark,
    background: NvPalette.bgDark,
    surface: NvPalette.surfaceDark,
    accent: NvPalette.accentGold,
    accent2: NvPalette.goldSoft,
    success: NvPalette.emerald,
    danger: NvPalette.rose,
    textPrimary: NvPalette.textPrimary,
    textSecondary: NvPalette.textSecondary,
    borderColor: NvPalette.border,
  );

  static const NvThemeData lightMode = NvThemeData(
    id: NvThemeId.lightMode,
    brightness: Brightness.light,
    background: NvPalette.bgLight,
    surface: NvPalette.surfaceLight,
    accent: NvPalette.goldDeep,
    accent2: NvPalette.bronzeSoft,
    success: NvPalette.emeraldLight,
    danger: NvPalette.roseLight,
    textPrimary: NvPalette.textPrimaryLight,
    textSecondary: NvPalette.textSecondaryLight,
    borderColor: NvPalette.borderLight,
  );

  static const NvThemeData oceanBlue = NvThemeData(
    id: NvThemeId.oceanBlue,
    brightness: Brightness.dark,
    background: Color(0xFF0E141A),
    surface: Color(0xFF17202A),
    accent: Color(0xFF6FAECB),
    accent2: Color(0xFF8FA9C2),
    success: NvPalette.emerald,
    danger: NvPalette.rose,
    textPrimary: NvPalette.textPrimary,
    textSecondary: Color(0xFF8A97A3),
    borderColor: Color(0x2E8A97A3),
  );

  static const NvThemeData sunsetPurple = NvThemeData(
    id: NvThemeId.sunsetPurple,
    brightness: Brightness.dark,
    background: Color(0xFF15121A),
    surface: Color(0xFF201B28),
    accent: Color(0xFFB394C9),
    accent2: Color(0xFFC9A9B8),
    success: NvPalette.emerald,
    danger: NvPalette.rose,
    textPrimary: NvPalette.textPrimary,
    textSecondary: Color(0xFF9C93A8),
    borderColor: Color(0x2E9C93A8),
  );

  static const NvThemeData mintFresh = NvThemeData(
    id: NvThemeId.mintFresh,
    brightness: Brightness.dark,
    background: Color(0xFF101512),
    surface: Color(0xFF1A211D),
    accent: Color(0xFF8FBFA6),
    accent2: Color(0xFFB5C9A6),
    success: NvPalette.emerald,
    danger: NvPalette.rose,
    textPrimary: NvPalette.textPrimary,
    textSecondary: Color(0xFF93A398),
    borderColor: Color(0x2E93A398),
  );

  static const List<NvThemeData> all = [
    cyberpunkNeon,
    lightMode,
    oceanBlue,
    sunsetPurple,
    mintFresh,
  ];
}

/// Typography §4.3 (premium rework): Inter everywhere — headings and money
/// amounts included (Orbitron removed). Amounts use tabular figures (tnum),
/// so digits keep a fixed width and align like in banking apps
/// (Revolut / monobank style).
/// Scale: H1 28/32, H2 22/28, Body 15/20, Caption 12/16, Button 16/24 w600.
abstract final class NvType {
  static const String headingFont = 'Inter';
  static const String bodyFont = 'Inter';

  /// Tabular figures for money, counters and PIN digits.
  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  static TextStyle h1(AppColors c) => TextStyle(
        fontFamily: headingFont,
        fontSize: 28,
        height: 32 / 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: c.text,
      );

  static TextStyle h2(AppColors c) => TextStyle(
        fontFamily: headingFont,
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: c.text,
      );

  static TextStyle amount(AppColors c, {double size = 28}) => TextStyle(
        fontFamily: bodyFont,
        fontSize: size,
        height: 1.15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        fontFeatures: tabularFigures,
        color: c.text,
      );

  static TextStyle body(AppColors c) => TextStyle(
        fontFamily: bodyFont,
        fontSize: 15,
        height: 20 / 15,
        color: c.text,
      );

  static TextStyle bodySecondary(AppColors c) => TextStyle(
        fontFamily: bodyFont,
        fontSize: 15,
        height: 20 / 15,
        color: c.secondary,
      );

  static TextStyle caption(AppColors c) => TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        height: 16 / 12,
        color: c.secondary,
      );

  static TextStyle button(AppColors c) => TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
        color: c.text,
      );
}

/// Resolved color set for the active theme.
class AppColors {
  const AppColors({
    required this.background,
    required this.surface,
    required this.accent,
    required this.accent2,
    required this.success,
    required this.danger,
    required this.text,
    required this.secondary,
    required this.border,
    required this.brightness,
  });

  final Color background;
  final Color surface;
  final Color accent;
  final Color accent2;
  final Color success;
  final Color danger;
  final Color text;
  final Color secondary;
  final Color border;
  final Brightness brightness;

  static AppColors from(NvThemeData t) => AppColors(
        background: t.background,
        surface: t.surface,
        accent: t.accent,
        accent2: t.accent2,
        success: t.success,
        danger: t.danger,
        text: t.textPrimary,
        secondary: t.textSecondary,
        border: t.borderColor,
        brightness: t.brightness,
      );
}

/// Component style §4.4: radius cards 16dp, buttons 14dp, sheets 24dp top.
const double kCardRadius = 16;
const double kButtonRadius = 14;
const double kSheetRadius = 24;

/// UX mechanics §4.5 timings: interface 150–300ms, celebratory 400–800ms.
const Duration kAnimFast = Duration(milliseconds: 150);
const Duration kAnimNormal = Duration(milliseconds: 250);
const Duration kAnimSlow = Duration(milliseconds: 300);
const Duration kAnimCelebration = Duration(milliseconds: 600);
const Duration kBreathingCycle = Duration(seconds: 3);

ThemeData buildTheme(NvThemeData t) {
  final c = AppColors.from(t);
  final base =
      t.brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light();
  return base.copyWith(
    scaffoldBackgroundColor: c.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: c.accent,
      brightness: t.brightness,
      primary: c.accent,
      secondary: c.accent2,
      surface: c.surface,
      error: c.danger,
    ).copyWith(surface: c.surface, error: c.danger),
    appBarTheme: AppBarTheme(
      backgroundColor: c.background,
      foregroundColor: c.text,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: NvType.h2(c).copyWith(fontSize: 20),
    ),
    cardTheme: CardThemeData(
      color: c.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCardRadius),
        side: BorderSide(color: c.border),
      ),
    ),
    dividerTheme: DividerThemeData(color: c.border, thickness: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surface,
      hintStyle: NvType.bodySecondary(c),
      labelStyle: NvType.body(c),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kButtonRadius),
        borderSide: BorderSide(color: c.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kButtonRadius),
        borderSide: BorderSide(color: c.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kButtonRadius),
        borderSide: BorderSide(color: c.accent, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kButtonRadius),
        borderSide: BorderSide(color: c.danger),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: c.accent,
        foregroundColor: c.background,
        minimumSize: const Size(64, 48),
        textStyle: NvType.button(c).copyWith(color: c.background),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: c.accent,
        minimumSize: const Size(64, 48),
        side: BorderSide(color: c.accent),
        textStyle: NvType.button(c).copyWith(color: c.accent),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kButtonRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: c.accent,
        textStyle: NvType.button(c).copyWith(color: c.accent),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: c.surface,
      contentTextStyle: NvType.body(c),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kButtonRadius),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.surface,
      titleTextStyle: NvType.h2(c).copyWith(fontSize: 18),
      contentTextStyle: NvType.body(c),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCardRadius)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.surface,
      modalBackgroundColor: c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kSheetRadius)),
      ),
      showDragHandle: true,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected) ? c.background : c.secondary),
      trackColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected) ? c.accent : c.border),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: c.accent,
      thumbColor: c.accent,
      inactiveTrackColor: c.border,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: c.accent,
      unselectedLabelColor: c.secondary,
      indicatorColor: c.accent,
      dividerColor: c.border,
      labelStyle: NvType.button(c).copyWith(color: c.accent),
      unselectedLabelStyle: NvType.button(c).copyWith(color: c.secondary),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: c.accent),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? c.accent : Colors.transparent,
      ),
      side: BorderSide(color: c.secondary),
    ),
  );
}
