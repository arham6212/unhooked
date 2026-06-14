import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class QuoteSection extends StatelessWidget {
  const QuoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '“',
                  style: TextStyle(
                    fontSize: 48,
                    height: 1.0,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'The strongest man is the one\nwho masters himself.',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '– SENECA',
                  style: AppTypography.label.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/zen_stones.png',
            width: 80,
            height: 80,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
