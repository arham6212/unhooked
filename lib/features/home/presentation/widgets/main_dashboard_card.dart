import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import 'relapse_heatmap.dart';

class MainDashboardCard extends StatelessWidget {
  const MainDashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.extraLarge,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: Streak info + Heatmap ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: streak
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CURRENT STREAK',
                            style: AppTypography.label.copyWith(
                              color: AppColors.textMuted,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '12',
                                style: AppTypography.display.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 56,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'days',
                                style: AppTypography.heading3.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              const Icon(LucideIcons.shieldCheck, size: 16, color: AppColors.primary),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                'Discipline Level 2',
                                style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildProgressBar(),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            'Next level in 3 days',
                            style: AppTypography.caption.copyWith(color: AppColors.textMuted, fontSize: 11),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          // Momentum banner
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: AppRadius.large,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(LucideIcons.trendingUp, size: 12, color: AppColors.onPrimary),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Flexible(
                                  child: Text(
                                    "You're building\nreal momentum.",
                                    style: AppTypography.caption.copyWith(
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    // Right: heatmap
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Last 30 days',
                          style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const RelapseHeatmap(),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildLegendItem(AppColors.success, 'Clean'),
                            const SizedBox(width: AppSpacing.md),
                            _buildLegendItem(AppColors.error, 'Relapsed'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // ── Bottom: Time Reclaimed ──
                Text(
                  'TIME RECLAIMED',
                  style: AppTypography.label.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    _buildTimeBlock('12', 'd'),
                    _buildTimeColon(),
                    _buildTimeBlock('06', 'h'),
                    _buildTimeColon(),
                    _buildTimeBlock('36', 'm'),
                    _buildTimeColon(),
                    _buildTimeBlock('54', 's'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  "You've saved ~18 hours",
                  style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          // Monk image
          Positioned(
            right: -20,
            bottom: -20,
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: AppRadius.extraLarge,
                child: Image.asset(
                  'assets/images/meditating_monk.png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 6,
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 0.6,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildTimeBlock(String value, String unit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: AppTypography.heading2.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          unit,
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeColon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: AppTypography.heading2.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
