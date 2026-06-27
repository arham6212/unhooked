import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  String _dynamicSubtitle(int streakDays) {
    if (streakDays >= 365) return 'Over a year strong. You\'re rewriting your story.';
    if (streakDays >= 180) return '6 months deep — this is who you are now.';
    if (streakDays >= 120) return 'You\'ve passed 4 months. Remarkable.';
    if (streakDays >= 90) return '90 days — a true milestone. Keep going.';
    if (streakDays >= 60) return '2 months in. The compound effect is real.';
    if (streakDays >= 30) return 'One full month. You\'re building something.';
    if (streakDays >= 14) return 'Two weeks strong — momentum is yours.';
    if (streakDays >= 7) return 'A full week. Each day adds up.';
    if (streakDays >= 3) return 'Three days and counting. Stay with it.';
    return 'Every hour matters. You\'re doing this.';
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good\nmorning.' : hour < 17 ? 'Good\nafternoon.' : 'Good\nevening.';
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','May','June','Jul','Aug','Sep','Oct','Nov','Dec'];
    final weekdays = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    final dateLabel = '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
    const streakDays = 127;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        const SizedBox(height: AppSpacing.sm),
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
          _dynamicSubtitle(streakDays),
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
