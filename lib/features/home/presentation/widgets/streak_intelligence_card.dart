import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/components/app_card.dart';

class StreakIntelligenceCard extends StatelessWidget {
  const StreakIntelligenceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => HapticFeedback.lightImpact(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.barChart2, size: 16, color: AppColors.textMuted),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'STREAK INTELLIGENCE',
                style: AppTypography.label.copyWith(color: AppColors.textMuted, letterSpacing: 1.2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _buildStat(
                  icon: LucideIcons.trophy,
                  iconColor: AppColors.warning,
                  label: 'BEST',
                  value: '127',
                ),
              ),
              Expanded(
                child: _buildStat(
                  icon: LucideIcons.target,
                  iconColor: AppColors.primary,
                  label: 'NEXT GOAL',
                  value: '150',
                ),
              ),
              Expanded(
                child: _buildStat(
                  icon: LucideIcons.hourglass,
                  iconColor: AppColors.success,
                  label: 'DAYS LEFT',
                  value: '23',
                  valueColor: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: AppTypography.heading2.copyWith(
            color: valueColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          style: AppTypography.label.copyWith(
            color: AppColors.textMuted,
            fontSize: 9,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
