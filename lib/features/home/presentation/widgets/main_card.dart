import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import 'home_widgets.dart';
class MainCard extends StatelessWidget {
  const MainCard({super.key, 
    required this.elapsed,
    required this.currentStreak,
    required this.bestStreak,
    required this.averageStreak,
    required this.onResetTimer,
    this.onCounterTap,
  });

  final Duration elapsed;
  final int currentStreak;
  final int bestStreak;
  final int averageStreak;
  final VoidCallback onResetTimer;
  final VoidCallback? onCounterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.extraLarge,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primaryLight],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onCounterTap,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$currentStreak',
                                style: AppTypography.heading1.copyWith(
                                  fontSize: 42,
                                  color: AppColors.onPrimary,
                                  height: 1.0,
                                  letterSpacing: -1,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: AppSpacing.md),
                                  Text(
                                    'days',
                                    style: AppTypography.caption.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onPrimary.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Current Streak',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.onPrimary.withValues(alpha: 0.7),
                            ),
                          ),
                          Text(
                            'Best: $bestStreak days',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.onPrimary.withValues(alpha: 0.7),
                            ),
                          ),
                          Text(
                            'Average: $averageStreak days',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.onPrimary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    DailyGrid(),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            RecoveryTimerSection(
              elapsed: elapsed,
              onReset: onResetTimer,
              onTimerTap: onCounterTap,
            ),
            SizedBox(height: AppSpacing.lg),

            Row(
              children: [
                NavButton(icon: Icons.menu_book_rounded, label: 'Journal'),
                SizedBox(width: AppSpacing.md),
                NavButton(
                  icon: Icons.people_rounded,
                  label: 'Community',
                ),
                SizedBox(width: AppSpacing.md),
                NavButton(
                  icon: Icons.school_rounded,
                  label: 'Courses',
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),

            CurrentBenefitsRow(),
          ],
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
