import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../domain/entities/meditation.dart';

class MeditationCard extends StatelessWidget {
  const MeditationCard({
    super.key,
    required this.meditation,
    required this.onTap,
  });

  final Meditation meditation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surface,
          borderRadius: AppRadius.large,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: meditation.accentColor.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: meditation.accentColor.withValues(alpha: 0.1),
                borderRadius: AppRadius.medium,
              ),
              child: Icon(
                meditation.category.icon,
                color: meditation.accentColor,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meditation.title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    meditation.subtitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceSunken,
                borderRadius: AppRadius.circular,
              ),
              child: Text(
                '${meditation.durationMinutes}m',
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBody,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickStartCard extends StatelessWidget {
  const QuickStartCard({
    super.key,
    required this.meditation,
    required this.onTap,
  });

  final Meditation meditation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              meditation.accentColor,
              meditation.accentColor.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: AppRadius.large,
          boxShadow: [
            BoxShadow(
              color: meditation.accentColor.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: AppRadius.small,
              ),
              child: Icon(
                meditation.category.icon,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              meditation.title,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              '${meditation.durationMinutes} min',
              style: AppTypography.caption.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
