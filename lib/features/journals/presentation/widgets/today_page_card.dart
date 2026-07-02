import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/journal_entry.dart';
import '../styles/journal_styles.dart';
import '../utils/journal_dates.dart';

/// Today's page — the hero of the screen and the primary way into writing.
/// Empty: an inviting blank page with a breathing caret.
/// Started: a preview of today's words with a nudge to continue.
class TodayPageCard extends StatelessWidget {
  const TodayPageCard({super.key, this.todayEntry, required this.onTap});

  final JournalEntry? todayEntry;
  final VoidCallback onTap;

  String get _ghostLine {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'What\'s on your mind this morning?';
    if (hour >= 12 && hour < 17) return 'What\'s on your mind this afternoon?';
    if (hour >= 17 && hour < 22) return 'What\'s on your mind this evening?';
    return 'What\'s keeping you up tonight?';
  }

  @override
  Widget build(BuildContext context) {
    final palette = JournalPalette.of(context);
    final entry = todayEntry;
    final started = entry != null && !entry.isEmpty;

    return Semantics(
      button: true,
      label: started ? 'Continue writing today\'s entry' : 'Start writing today\'s entry',
      child: Material(
        color: palette.surface,
        borderRadius: AppRadius.extraLarge,
        child: InkWell(
          borderRadius: AppRadius.extraLarge,
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.extraLarge,
              border: Border.all(color: palette.border, width: 1),
              boxShadow: AppShadows.md,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'TODAY · ${JournalDates.compact(DateTime.now()).toUpperCase()}',
                        style: AppTypography.label.copyWith(color: palette.textSubtle),
                      ),
                      const Spacer(),
                      Icon(LucideIcons.feather, size: 16, color: palette.textSubtle),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (started) ...[
                    Text(
                      entry.body.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: JournalType.preview.copyWith(color: palette.textBody),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        if (entry.mood != null) ...[
                          _MoodDot(mood: entry.mood!),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Text(
                          '${entry.wordCount} words so far',
                          style: AppTypography.caption.copyWith(
                            fontSize: 12,
                            color: palette.textSubtle,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Continue',
                          style: AppTypography.button.copyWith(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        const Icon(LucideIcons.arrowRight,
                            size: 14, color: AppColors.primary),
                      ],
                    ),
                  ] else ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _BreathingCaret(),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            _ghostLine,
                            style: JournalType.ghost.copyWith(color: palette.textSubtle),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Text(
                          'This page is still blank',
                          style: AppTypography.caption.copyWith(
                            fontSize: 12,
                            color: palette.textSubtle,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Begin',
                          style: AppTypography.button.copyWith(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        const Icon(LucideIcons.arrowRight,
                            size: 14, color: AppColors.primary),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodDot extends StatelessWidget {
  const _MoodDot({required this.mood});
  final JournalMood mood;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: mood.gradient,
        ),
      ),
    );
  }
}

/// A slim caret that breathes — the page quietly waiting for words.
class _BreathingCaret extends StatelessWidget {
  const _BreathingCaret();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2.5,
      height: 24,
      margin: const EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(2),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fade(begin: 0.15, end: 1, duration: 900.ms, curve: Curves.easeInOut);
  }
}
