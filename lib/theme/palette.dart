import 'package:flutter/material.dart';

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

  // Background & Surface Colors
  static const Color background = Color(0xFFF9F9FF);
  static const Color surface = Color(0xFFF9F9FF);
  static const Color surfaceLight = Color(0xFFF0F3FF);
  static const Color surfaceContainer = Color(0xFFE7EEFF);
  static const Color surfaceContainerLow = Color(0xFFF0F3FF);
  static const Color surfaceContainerHigh = Color(0xFFDEE8FF);
  static const Color surfaceContainerHighest = Color(0xFFD8E3FB);
  static const Color surfaceVariant = Color(0xFFD8E3FB);
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color shadowColor = Color(0x0D000000);

  // Typography & Text Colors
  static const Color textPrimary = Color(0xFF111C2D);
  static const Color textSecondary = Color(0xFF737783);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF94A3B8);

  // Borders & Dividers
  static const Color borderLight = Color(0xFFC3C6D4);
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
}
