import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../styles/journal_styles.dart';

/// A small idea to write from — rotates daily so the row never goes stale.
class JournalSpark {
  final String category;
  final String text;
  final IconData icon;
  final Color tint;
  final Color accent;

  const JournalSpark({
    required this.category,
    required this.text,
    required this.icon,
    required this.tint,
    required this.accent,
  });
}

const _gratitude = [
  'Name three small things that went right today.',
  'Who made today a little lighter? Write to them.',
  'What ordinary thing would you miss if it were gone?',
];

const _reflect = [
  'What did today teach you about yourself?',
  'When did you feel most like yourself today?',
  'What thought kept returning today? Follow it.',
];

const _intention = [
  'What would make tomorrow feel like a win?',
  'What matters most this week — in one honest line?',
  'What do you want to protect tomorrow?',
];

const _quotes = [
  '“Between stimulus and response there is a space. In that space is our power to choose.” — Viktor Frankl',
  '“You can\'t stop the waves, but you can learn to surf.” — Jon Kabat-Zinn',
  '“The quieter you become, the more you can hear.” — Ram Dass',
];

/// Deterministic daily rotation of prompt content.
List<JournalSpark> sparksForToday() {
  final day = DateTime.now().difference(DateTime(2026)).inDays;
  int pick(int offset) => (day + offset) % 3;

  return [
    JournalSpark(
      category: 'Gratitude',
      text: _gratitude[pick(0)],
      icon: LucideIcons.heart,
      tint: AppColors.tintGreen,
      accent: AppColors.tealDark,
    ),
    JournalSpark(
      category: 'Reflect',
      text: _reflect[pick(1)],
      icon: LucideIcons.sparkles,
      tint: AppColors.tintBlue,
      accent: AppColors.primary,
    ),
    JournalSpark(
      category: 'Intention',
      text: _intention[pick(2)],
      icon: LucideIcons.compass,
      tint: AppColors.tintPurple,
      accent: const Color(0xFF8B5CF6),
    ),
    JournalSpark(
      category: 'Sit with this',
      text: _quotes[pick(0)],
      icon: LucideIcons.quote,
      tint: AppColors.warmCream,
      accent: AppColors.warmAmber,
    ),
  ];
}

/// Horizontal row of lightweight prompt cards.
class WritingSparks extends StatelessWidget {
  const WritingSparks({super.key, required this.onSparkTap});

  final ValueChanged<JournalSpark> onSparkTap;

  @override
  Widget build(BuildContext context) {
    final sparks = sparksForToday();

    return SizedBox(
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg + AppSpacing.xs),
        clipBehavior: Clip.none,
        itemCount: sparks.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) => _SparkCard(
          spark: sparks[i],
          onTap: () {
            HapticFeedback.selectionClick();
            onSparkTap(sparks[i]);
          },
        ),
      ),
    );
  }
}

class _SparkCard extends StatelessWidget {
  const _SparkCard({required this.spark, required this.onTap});

  final JournalSpark spark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = JournalPalette.of(context);

    return Semantics(
      button: true,
      label: 'Writing prompt, ${spark.category}: ${spark.text}',
      child: Material(
        color: palette.surface,
        borderRadius: AppRadius.large,
        child: InkWell(
          borderRadius: AppRadius.large,
          onTap: onTap,
          child: Ink(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: AppRadius.large,
              border: Border.all(color: palette.border, width: 1),
              boxShadow: AppShadows.sm,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: spark.tint,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(spark.icon, size: 13, color: spark.accent),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        spark.category.toUpperCase(),
                        style: AppTypography.label.copyWith(
                          fontSize: 10,
                          color: spark.accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: Text(
                      spark.text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        fontSize: 12.5,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        color: palette.textBody,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
