import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../styles/journal_styles.dart';
import '../utils/journal_dates.dart';

/// Time-aware greeting: warm, quiet, never saccharine.
class JournalHeader extends StatelessWidget {
  const JournalHeader({super.key});

  ({String greeting, String line, IconData icon, Color tint}) get _daypart {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return (
        greeting: 'Good morning',
        line: 'A few quiet lines to set the tone for today.',
        icon: LucideIcons.sunrise,
        tint: AppColors.warmAmber,
      );
    }
    if (hour >= 12 && hour < 17) {
      return (
        greeting: 'Good afternoon',
        line: 'Pause for a moment — how is today unfolding?',
        icon: LucideIcons.sun,
        tint: AppColors.warmAmber,
      );
    }
    if (hour >= 17 && hour < 22) {
      return (
        greeting: 'Good evening',
        line: 'Capture today\'s thoughts before they disappear.',
        icon: LucideIcons.sunset,
        tint: AppColors.primary,
      );
    }
    return (
      greeting: 'Still awake',
      line: 'Empty the mind onto the page before sleep.',
      icon: LucideIcons.moon,
      tint: AppColors.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = JournalPalette.of(context);
    final daypart = _daypart;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                JournalDates.monthYear(DateTime.now()).toUpperCase(),
                style: AppTypography.label.copyWith(color: palette.textSubtle),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                daypart.greeting,
                style: AppTypography.heading1.copyWith(
                  fontSize: 32,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                daypart.line,
                style: AppTypography.bodyMedium.copyWith(color: palette.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          width: 42,
          height: 42,
          margin: const EdgeInsets.only(top: AppSpacing.lg),
          decoration: BoxDecoration(
            color: daypart.tint.withValues(alpha: 0.09),
            shape: BoxShape.circle,
          ),
          child: Icon(daypart.icon, size: 20, color: daypart.tint),
        ),
      ],
    );
  }
}
