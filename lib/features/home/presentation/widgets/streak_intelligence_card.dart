import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class StreakIntelligenceCard extends StatelessWidget {
  const StreakIntelligenceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STREAK INTELLIGENCE',
            style: AppTypography.label.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildRow(
            icon: LucideIcons.trophy,
            iconColor: AppColors.warning,
            iconBg: AppColors.warning.withValues(alpha: 0.1),
            label: 'BEST',
            value: '127',
          ),
          const Divider(height: AppSpacing.md, color: AppColors.divider),
          _buildRow(
            icon: LucideIcons.target,
            iconColor: AppColors.primary,
            iconBg: AppColors.primary.withValues(alpha: 0.1),
            label: 'NEXT',
            value: '150',
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    Color? valueColor,
    bool isValueText = false,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.caption),
            Text(
              value,
              style: isValueText
                  ? AppTypography.heading3.copyWith(color: valueColor ?? AppColors.textPrimary)
                  : AppTypography.heading2.copyWith(color: valueColor ?? AppColors.textPrimary),
            ),
          ],
        ),
      ],
    );
  }
}
