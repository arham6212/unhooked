import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const String fontFamily = 'Inter';

  // Display — hero numbers, big streak count
  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 56,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    height: 0.92,
    letterSpacing: -2.5,
  );

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.1,
    letterSpacing: -0.8,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.15,
    letterSpacing: -0.5,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.3,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.55,
    letterSpacing: -0.1,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textBody,
    height: 1.55,
    letterSpacing: -0.1,
  );

  // Small
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
    letterSpacing: 0,
  );

  // Section label — UPPERCASE micro label
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textMuted,
    height: 1.2,
    letterSpacing: 1.1,
  );

  // Button
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
  );

  // Serif — the app's emotional voice (intro/onboarding only).
  // Inter operates the interface; Fraunces speaks to the person.
  static const String serifFamily = 'Fraunces';

  static const TextStyle serifDisplay = TextStyle(
    fontFamily: serifFamily,
    fontSize: 34,
    fontWeight: FontWeight.w400,
    color: AppColors.introText,
    height: 1.18,
    letterSpacing: -0.4,
  );

  static const TextStyle serifTitle = TextStyle(
    fontFamily: serifFamily,
    fontSize: 26,
    fontWeight: FontWeight.w500,
    color: AppColors.introText,
    height: 1.25,
    letterSpacing: -0.2,
  );

  // Mono — for timer digits
  static const TextStyle mono = TextStyle(
    fontFamily: 'Courier',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
