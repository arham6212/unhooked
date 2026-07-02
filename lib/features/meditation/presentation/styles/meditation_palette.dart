import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';

/// One dark/light lookup per build — keeps meditation widgets free of
/// isDark branching.
class MeditationPalette {
  final Color background;
  final Color surface;
  final Color surfaceSunken;
  final Color border;
  final Color divider;
  final Color textPrimary;
  final Color textBody;
  final Color textMuted;
  final Color textSubtle;

  const MeditationPalette._({
    required this.background,
    required this.surface,
    required this.surfaceSunken,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textBody,
    required this.textMuted,
    required this.textSubtle,
  });

  static const _light = MeditationPalette._(
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceSunken: AppColors.surfaceSunken,
    border: AppColors.border,
    divider: AppColors.divider,
    textPrimary: AppColors.textPrimary,
    textBody: AppColors.textBody,
    textMuted: AppColors.textMuted,
    textSubtle: AppColors.textSubtle,
  );

  static const _dark = MeditationPalette._(
    background: AppColors.backgroundDark,
    surface: AppColors.surfaceDark,
    surfaceSunken: Color(0xFF1D2433),
    border: AppColors.borderDark,
    divider: AppColors.dividerDark,
    textPrimary: Color(0xFFF3F4F6),
    textBody: Color(0xFFC7CDDB),
    textMuted: Color(0xFF8B94A9),
    textSubtle: Color(0xFF6B7488),
  );

  static MeditationPalette of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? _dark : _light;
  }
}
