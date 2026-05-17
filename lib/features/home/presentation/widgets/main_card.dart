import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';

const _kMilestones = [7, 14, 30, 60, 90, 180, 365, 730];

int _nextMilestone(int days) {
  for (final m in _kMilestones) {
    if (days < m) return m;
  }
  return _kMilestones.last;
}

int _prevMilestone(int days) {
  int prev = 0;
  for (final m in _kMilestones) {
    if (days < m) return prev;
    prev = m;
  }
  return prev;
}

class MainCard extends StatelessWidget {
  const MainCard({
    super.key,
    required this.currentStreak,
    required this.bestStreak,
    required this.averageStreak,
    this.onViewProgress,
  });

  final int currentStreak;
  final int bestStreak;
  final int averageStreak;
  final VoidCallback? onViewProgress;

  @override
  Widget build(BuildContext context) {
    final next = _nextMilestone(currentStreak);
    final prev = _prevMilestone(currentStreak);
    final progress = next == prev
        ? 1.0
        : ((currentStreak - prev) / (next - prev)).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.huge,
        boxShadow: AppShadows.colored(AppColors.primary, intensity: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: onViewProgress,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top row: flame + STREAK pill
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.flame,
                      size: 18,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary.withValues(alpha: 0.18),
                      borderRadius: AppRadius.circular,
                    ),
                    child: Text(
                      'STREAK',
                      style: AppTypography.label.copyWith(
                        color: AppColors.onPrimary,
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),

              // Middle: massive streak number
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$currentStreak',
                        style: AppTypography.display.copyWith(
                          fontSize: 68,
                          color: AppColors.onPrimary,
                          height: 0.9,
                          letterSpacing: -3.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Text(
                          'days',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.onPrimary.withValues(alpha: 0.80),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'of progress',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              // Bottom: progress to next milestone
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Next: $next days',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${next - currentStreak}d to go',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: AppRadius.circular,
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor:
                          AppColors.onPrimary.withValues(alpha: 0.20),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.onPrimary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(
          begin: 0.03,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
