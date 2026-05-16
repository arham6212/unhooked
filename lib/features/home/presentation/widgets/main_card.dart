import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import 'home_widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';
class MainCard extends StatelessWidget {
  const MainCard({super.key,
    required this.elapsed,
    required this.currentStreak,
    required this.bestStreak,
    required this.averageStreak,
    required this.onResetTimer,
    this.onCounterTap,
    this.onJournalTap,
    this.onCommunityTap,
    this.onCoursesTap,
  });

  final Duration elapsed;
  final int currentStreak;
  final int bestStreak;
  final int averageStreak;
  final VoidCallback onResetTimer;
  final VoidCallback? onCounterTap;
  final VoidCallback? onJournalTap;
  final VoidCallback? onCommunityTap;
  final VoidCallback? onCoursesTap;

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
                NavButton(icon: LucideIcons.bookOpen, label: 'Journal', onTap: onJournalTap),
                SizedBox(width: AppSpacing.md),
                NavButton(icon: LucideIcons.users, label: 'Community', onTap: onCommunityTap),
                SizedBox(width: AppSpacing.md),
                NavButton(icon: LucideIcons.graduationCap, label: 'Courses', onTap: onCoursesTap),
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
