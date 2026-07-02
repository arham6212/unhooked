import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../styles/journal_styles.dart';

/// First-use moment: a small stack of waiting pages instead of a stock
/// illustration. The top page breathes, inviting the first line.
class JournalEmptyState extends StatelessWidget {
  const JournalEmptyState({
    super.key,
    required this.onBegin,
    required this.onGratitudePrompt,
  });

  final VoidCallback onBegin;
  final VoidCallback onGratitudePrompt;

  @override
  Widget build(BuildContext context) {
    final palette = JournalPalette.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.xl,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PageStack(palette: palette),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Your first page is waiting',
                style: JournalType.display.copyWith(color: palette.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'One honest line is enough to begin.\nNo one else will ever read it.',
                style: AppTypography.bodyMedium.copyWith(
                  color: palette.textMuted,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Semantics(
                button: true,
                child: Material(
                  color: AppColors.primary,
                  borderRadius: AppRadius.circular,
                  child: InkWell(
                    borderRadius: AppRadius.circular,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onBegin();
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.circular,
                        boxShadow: AppShadows.primary(intensity: 0.9),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxl,
                          vertical: AppSpacing.lg - AppSpacing.xxs,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.feather,
                                size: 17, color: AppColors.onPrimary),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Begin writing',
                              style: AppTypography.button
                                  .copyWith(color: AppColors.onPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: onGratitudePrompt,
                child: Text(
                  'Not sure where to start? Try gratitude →',
                  style: AppTypography.caption.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: palette.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, curve: Curves.easeOut)
        .slideY(begin: 0.03, end: 0, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}

/// Two pages fanned behind a crisp top page with faint ruled lines
/// and a breathing caret on the first line.
class _PageStack extends StatelessWidget {
  const _PageStack({required this.palette});

  final JournalPalette palette;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: 0.09,
            child: _blankPage(color: AppColors.primaryXLight.withValues(alpha: 0.45)),
          ),
          Transform.rotate(
            angle: -0.05,
            child: _blankPage(color: palette.surface.withValues(alpha: 0.85)),
          ),
          Container(
            width: 132,
            height: 132,
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: AppRadius.medium,
              border: Border.all(color: palette.border),
              boxShadow: AppShadows.lg,
            ),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 2,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .fade(begin: 0.15, end: 1, duration: 900.ms),
                    const SizedBox(width: AppSpacing.sm),
                    _ruledLine(width: 56),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _ruledLine(width: 96),
                const SizedBox(height: AppSpacing.lg),
                _ruledLine(width: 80),
                const SizedBox(height: AppSpacing.lg),
                _ruledLine(width: 90),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blankPage({required Color color}) {
    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.medium,
        border: Border.all(color: palette.border.withValues(alpha: 0.6)),
      ),
    );
  }

  Widget _ruledLine({required double width}) {
    return Container(
      width: width,
      height: 1.5,
      decoration: BoxDecoration(
        color: palette.divider,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
