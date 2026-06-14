import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';

class EditorialQuoteSection extends StatelessWidget {
  const EditorialQuoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Reflection',
            style: AppTypography.heading3.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '"The man who moves a mountain begins by carrying away small stones."',
            style: TextStyle(
              fontFamily: AppTypography.heading2.fontFamily,
              fontSize: 24,
              height: 1.4,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.white.withValues(alpha: 0.9) : AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '— Confucius',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? Colors.white54 : AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
