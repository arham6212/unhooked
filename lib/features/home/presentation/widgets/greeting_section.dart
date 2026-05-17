import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good\nmorning.' : hour < 17 ? 'Good\nafternoon.' : 'Good\nevening.';
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final weekdays = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    final dateLabel = '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date chip
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs + 1,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryXLight,
            borderRadius: AppRadius.circular,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.calendarDays, size: 11, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                dateLabel,
                style: AppTypography.label.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        // Large greeting
        Text(
          greeting,
          style: AppTypography.heading1.copyWith(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
            height: 1.0,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        Text(
          'Your streak is growing — keep it up.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textMuted,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
