import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';

/// One dark/light lookup per build — keeps community widgets free of
/// isDark branching.
class CommunityPalette {
  final Color background;
  final Color surface;
  final Color border;
  final Color divider;
  final Color textPrimary;
  final Color textBody;
  final Color textMuted;
  final Color textSubtle;

  const CommunityPalette._({
    required this.background,
    required this.surface,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textBody,
    required this.textMuted,
    required this.textSubtle,
  });

  static const _light = CommunityPalette._(
    background: AppColors.background,
    surface: AppColors.surface,
    border: AppColors.border,
    divider: AppColors.divider,
    textPrimary: AppColors.textPrimary,
    textBody: AppColors.textBody,
    textMuted: AppColors.textMuted,
    textSubtle: AppColors.textSubtle,
  );

  static const _dark = CommunityPalette._(
    background: AppColors.backgroundDark,
    surface: AppColors.surfaceDark,
    border: AppColors.borderDark,
    divider: AppColors.dividerDark,
    textPrimary: Color(0xFFF3F4F6),
    textBody: Color(0xFFC7CDDB),
    textMuted: Color(0xFF8B94A9),
    textSubtle: Color(0xFF6B7488),
  );

  static CommunityPalette of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? _dark : _light;
  }
}
