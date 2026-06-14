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
          const SizedBox(height: AppSpacing.sm),
          _buildRow(
            icon: LucideIcons.trophy,
            iconColor: AppColors.warning,
            label: 'BEST',
            value: '127',
          ),
          const Divider(height: AppSpacing.sm, color: AppColors.divider),
          _buildRow(
            icon: LucideIcons.target,
            iconColor: AppColors.primary,
            label: 'NEXT',
            value: '150',
          ),
          const Divider(height: AppSpacing.sm, color: AppColors.divider),
          _buildRow(
            icon: LucideIcons.hourglass,
            iconColor: AppColors.success,
            label: 'LEFT',
            value: '23',
            valueColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.label),
            Text(
              value,
              style: AppTypography.heading3.copyWith(color: valueColor ?? AppColors.textPrimary),
            ),
          ],
        ),
      ],
    );
  }
}
