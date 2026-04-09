import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final IconData? icon;

  const AppChip({
    super.key,
    required this.label,
    this.isActive = false,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final activeBg = isDark ? AppColors.surface : AppColors.textPrimary;
    final activeFg = isDark ? AppColors.textPrimary : AppColors.surface;
    
    final inactiveBg = isDark ? AppColors.surfaceDark : AppColors.surface;
    final inactiveFg = AppColors.textMutedAlt;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm, 
        ),
        decoration: BoxDecoration(
          color: isActive ? activeBg : inactiveBg,
          borderRadius: AppRadius.circular,
          border: Border.all(
            color: isActive ? Colors.transparent : AppColors.border,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isActive ? activeFg : inactiveFg,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: isActive ? activeFg : inactiveFg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
