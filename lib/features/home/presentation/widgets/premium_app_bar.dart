import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class PremiumAppBar extends StatelessWidget {
  const PremiumAppBar({
    super.key,
    required this.onMenu,
    required this.onSos,
    required this.onLogout,
  });

  final VoidCallback onMenu;
  final VoidCallback onSos;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xE8EEF4FF), // semi-transparent blue-white
        border: Border(
          bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.6), width: 0.5),
        ),
      ),
      child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          // Logo mark
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadius.medium,
            ),
            child: const Icon(LucideIcons.flame, size: 17, color: AppColors.onPrimary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Recover Me',
            style: AppTypography.heading3.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          // SOS button
          GestureDetector(
            onTap: onSos,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.sosEnd,
                borderRadius: AppRadius.circular,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sosEnd.withValues(alpha: 0.30),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.heartPulse, color: AppColors.onPrimary, size: 14),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'SOS',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
