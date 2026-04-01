import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
        borderRadius: BorderRadius.circular(kCardRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kPrimaryStart, kPrimaryEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimaryStart.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                '$currentStreak',
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w800,
                                  color: kOnPrimary,
                                  height: 1.0,
                                  letterSpacing: -1,
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 12),
                                  const Text(
                                    'days',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: kOnPrimaryMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          const Text(
                            'Current Streak',
                            style: TextStyle(
                              fontSize: 12,
                              color: kOnPrimaryMuted,
                            ),
                          ),
                          Text(
                            'Best: $bestStreak days',
                            style: const TextStyle(
                              fontSize: 12,
                              color: kOnPrimaryMuted,
                            ),
                          ),
                          Text(
                            'Average: $averageStreak days',
                            style: const TextStyle(
                              fontSize: 12,
                              color: kOnPrimaryMuted,
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
            SizedBox(height: 16),
            RecoveryTimerSection(
              elapsed: elapsed,
              onReset: onResetTimer,
              onTimerTap: onCounterTap,
            ),
            SizedBox(height: 16),

            Row(
              children: [
                NavButton(icon: Icons.menu_book_rounded, label: 'Journal'),
                SizedBox(width: 12),
                NavButton(
                  icon: Icons.people_rounded,
                  label: 'Community',
                ),
                SizedBox(width: 12),
                NavButton(
                  icon: Icons.school_rounded,
                  label: 'Courses',
                ),
              ],
            ),
            SizedBox(height: 16),

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
