import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import 'relapse_heatmap.dart';

class MainDashboardCard extends StatelessWidget {
  const MainDashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.03),
            blurRadius: 8,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CURRENT STREAK',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSubtle,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
                                  stops: [0.0, 0.5, 1.0],
                                ).createShader(bounds),
                                child: Text(
                                  '12',
                                  style: AppTypography.display.copyWith(
                                    color: Colors.white,
                                    fontSize: 62,
                                    height: 1.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'days',
                                style: AppTypography.heading3.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Row(
                            children: [
                              Icon(LucideIcons.shield, size: 16, color: AppColors.primary),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Discipline Level 2',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _buildProgressBar(),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Next level in 3 days',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSubtle,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Last 30 days',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSubtle,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const RelapseHeatmap(),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildLegendItem(AppColors.successMuted, 'Clean'),
                            const SizedBox(width: AppSpacing.lg),
                            _buildLegendItem(AppColors.errorMuted, 'Relapsed'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSunken.withValues(alpha: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TIME RECLAIMED',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        _buildTimeBlock('12', 'd'),
                        _buildTimeSep(),
                        _buildTimeBlock('06', 'h'),
                        _buildTimeSep(),
                        _buildTimeBlock('36', 'm'),
                        _buildTimeSep(),
                        _buildTimeBlock('54', 's'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'You\'ve saved ~18 hours',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSubtle,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: -5,
            bottom: -5,
            child: IgnorePointer(
              child: Image.asset(
                'assets/images/meditating_monk.png',
                width: 190,
                height: 190,
                fit: BoxFit.contain,
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
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 0.6,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primary],
            ),
            borderRadius: BorderRadius.circular(3),
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSubtle,
            fontSize: 11,
          ),
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
            fontWeight: FontWeight.w800,
            fontSize: 28,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          unit,
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.textSubtle,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: AppTypography.heading2.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 24,
          color: AppColors.textSubtle,
        ),
      ),
    );
  }
}
