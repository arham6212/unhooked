import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class RecoveryLevelCard extends StatelessWidget {
  const RecoveryLevelCard({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/mountains_circle.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RECOVERY LEVEL', style: AppTypography.label),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Level 7 • Clarity', style: AppTypography.heading3.copyWith(color: AppColors.primaryDark)),
                    const Icon(LucideIcons.chevronRight, size: 20, color: AppColors.primaryDark),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('Progress to Level 8', style: AppTypography.caption),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: List.generate(24, (index) {
                          bool isFilled = index < 20; // ~84% of 24
                          return Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: index < 23 ? 2 : 0),
                              height: 6,
                              decoration: BoxDecoration(
                                color: isFilled ? AppColors.primary : AppColors.border,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text('84%', style: AppTypography.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    const Icon(LucideIcons.calendar, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: AppSpacing.xs),
                    Text('Next unlock in 23 days', style: AppTypography.caption),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
