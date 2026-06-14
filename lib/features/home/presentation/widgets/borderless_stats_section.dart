import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';

class BorderlessStatsSection extends StatelessWidget {
  const BorderlessStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: AppTypography.heading3.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _EditorialStat(
                  title: 'Average Streak',
                  value: '47',
                  subtitle: 'days',
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _EditorialStat(
                  title: 'Longest Streak',
                  value: '141',
                  subtitle: 'days',
                  isDark: isDark,
                ),
              ),
              Expanded(
                child: _EditorialStat(
                  title: 'Total Check-ins',
                  value: '84',
                  subtitle: 'entries',
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditorialStat extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final bool isDark;

  const _EditorialStat({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.caption.copyWith(
            color: isDark ? Colors.white54 : AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppTypography.heading1.fontFamily,
            fontSize: 32,
            height: 1.0,
            fontWeight: FontWeight.w300,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTypography.caption.copyWith(
            color: isDark ? Colors.white38 : AppColors.textMuted.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
