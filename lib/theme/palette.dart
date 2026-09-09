import 'package:flutter/material.dart';
import '../core/common/utils/app_settings.dart';

/// ============================================================================
/// FILE: palette.dart
/// MODULE: Theme & Styling (Dynamic App Color Palette)
/// PROJECT: Constructa App - College Project
/// DESCRIPTION:
///   Provides brand colors and dynamic adaptive getters that automatically switch
///   between Light and Dark Theme colors based on global [AppSettings].
/// ============================================================================

abstract class AppColors {
  // Brand Core Colors
  static const Color primary = Color(0xFF003178);
  static const Color primaryContainer = Color(0xFF0D47A1);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFFA1BBFF);

  static const Color secondary = Color(0xFF006972);
  static const Color secondaryContainer = Color(0xFF8FEEFC);
  static const Color onSecondaryContainer = Color(0xFF006D77);

  static const Color tertiary = Color(0xFF602100);
  static const Color tertiaryFixed = Color(0xFFFFDBCD);
  static const Color onTertiaryFixed = Color(0xFF360F00);
  static const Color onTertiaryFixedVariant = Color(0xFF7D2D00);

  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentSky = Color(0xFF0284C7);

  // Raw Static Light & Dark Colors
  static const Color lightBackground = Color(0xFFF9F9FF);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF111C2D);
  static const Color lightTextSecondary = Color(0xFF737783);
  static const Color lightBorderLight = Color(0xFFC3C6D4);
  static const Color lightSurfaceLight = Color(0xFFF0F3FF);

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCardBackground = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorderLight = Color(0xFF334155);
  static const Color darkSurfaceLight = Color(0xFF26334D);

  // Dynamic Adaptive Getters (Auto-switch based on AppSettings().isDarkMode)
  static Color get background => AppSettings().isDarkMode ? darkBackground : lightBackground;
  static Color get surface => AppSettings().isDarkMode ? darkBackground : lightBackground;
  static Color get surfaceLight => AppSettings().isDarkMode ? darkSurfaceLight : lightSurfaceLight;
  static Color get surfaceContainerLow => AppSettings().isDarkMode ? darkCardBackground : lightSurfaceLight;
  static Color get surfaceContainerHigh => AppSettings().isDarkMode ? darkBorderLight : const Color(0xFFDEE8FF);
  static Color get surfaceContainer => AppSettings().isDarkMode ? darkCardBackground : const Color(0xFFE7EEFF);
  static Color get surfaceContainerHighest => AppSettings().isDarkMode ? darkBorderLight : const Color(0xFFD8E3FB);
  static Color get surfaceVariant => AppSettings().isDarkMode ? darkBorderLight : const Color(0xFFD8E3FB);

  static Color get cardBackground => AppSettings().isDarkMode ? darkCardBackground : lightCardBackground;
  static Color get surfaceDark => darkCardBackground;
  static const Color shadowColor = Color(0x1F000000);

  // Typography & Text Colors
  static Color get textPrimary => AppSettings().isDarkMode ? darkTextPrimary : lightTextPrimary;
  static Color get textSecondary => AppSettings().isDarkMode ? darkTextSecondary : lightTextSecondary;
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF94A3B8);

  // Borders & Dividers
  static Color get borderLight => AppSettings().isDarkMode ? darkBorderLight : lightBorderLight;
  static const Color outline = Color(0xFF737783);
  static const Color outlineVariant = Color(0xFFC3C6D4);

  // Semantic & Status Badges
  static const Color statusSuccess = Color(0xFF059669);
  static const Color statusPending = Color(0xFFD97706);
  static const Color statusDanger = Color(0xFFDC2626);
  static const Color error = Color(0xFFBA1A1A);
  static const Color starRating = Color(0xFFF59E0B);
  static const Color tagBestseller = Color(0xFF7C3AED);
  static const Color tagTrending = Color(0xFF0284C7);
  static const Color tagNew = Color(0xFF059669);

  // Context-Aware Theme Methods
  static Color getBackground(BuildContext context) => Theme.of(context).scaffoldBackgroundColor;
  static Color getCardBackground(BuildContext context) => Theme.of(context).cardColor;
  static Color getTextPrimary(BuildContext context) => Theme.of(context).colorScheme.onSurface;
  static Color getTextSecondary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkTextSecondary : lightTextSecondary;
  }
  static Color getBorderLight(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkBorderLight : lightBorderLight;
  }
  static Color getSurfaceLight(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkSurfaceLight : lightSurfaceLight;
  }
}
