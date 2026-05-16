import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import 'package:lucide_icons/lucide_icons.dart';
class CurrentBenefitsRow extends StatelessWidget {
  const CurrentBenefitsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Icon(
              LucideIcons.heart,
              color: AppColors.onPrimary.withValues(alpha: 0.7),
              size: 24,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              'Current Benefits',
              style: AppTypography.button.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: AppRadius.medium,
              ),
              child: Text(
                '21',
                style: AppTypography.button.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
            const Spacer(),
            Icon(
              LucideIcons.chevronRight,
              size: 14,
              color: AppColors.onPrimary.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
