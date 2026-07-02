import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/meditation.dart';
import '../styles/meditation_palette.dart';

/// The centerpiece: one session picked for this moment of the day,
/// wearing a set of slowly breathing rings. Flat color only.
class MeditationHero extends StatelessWidget {
  const MeditationHero({
    super.key,
    required this.label,
    required this.meditation,
    required this.onTap,
  });

  final String label;
  final Meditation meditation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = MeditationPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = meditation.accentColor;

    return Semantics(
      button: true,
      label: 'Recommended: ${meditation.title}, ${meditation.durationMinutes} minutes',
      child: Material(
        color: accent.withValues(alpha: isDark ? 0.14 : 0.09),
        borderRadius: AppRadius.extraLarge,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.extraLarge,
              border: Border.all(color: accent.withValues(alpha: 0.22)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -34,
                  top: 0,
                  bottom: 0,
                  child: Center(child: _BreathingRings(color: accent)),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label.toUpperCase(),
                        style: AppTypography.label.copyWith(
                          fontSize: 10.5,
                          color: accent,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Padding(
                        padding: const EdgeInsets.only(right: 96),
                        child: Text(
                          meditation.title,
                          style: AppTypography.heading2.copyWith(
                            fontSize: 22,
                            color: palette.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Padding(
                        padding: const EdgeInsets.only(right: 96),
                        child: Text(
                          meditation.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            fontSize: 12.5,
                            color: palette.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration:
                                BoxDecoration(color: accent, shape: BoxShape.circle),
                            child: const Icon(LucideIcons.play,
                                size: 16, color: Colors.white),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            '${meditation.durationMinutes} min · ${switch (meditation.type) {
                              MeditationType.guided => 'Guided',
                              MeditationType.exercise => 'Breathing',
                              MeditationType.soundscape => 'Sounds',
                            }}',
                            style: AppTypography.caption.copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: accent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Three concentric rings inhaling and exhaling on a slow cycle.
class _BreathingRings extends StatelessWidget {
  const _BreathingRings({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget ring(double size, double alpha, int delayMs) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: alpha), width: 1.5),
        ),
      )
          .animate(delay: delayMs.ms, onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.06, 1.06),
            duration: 2600.ms,
            curve: Curves.easeInOut,
          );
    }

    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ring(146, 0.14, 0),
          ring(106, 0.22, 220),
          ring(68, 0.32, 440),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.65),
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.25, 1.25),
                duration: 2600.ms,
                curve: Curves.easeInOut,
              ),
        ],
      ),
    );
  }
}

/// Always within reach: the 3-minute lifeline for when a craving spikes.
class SosStrip extends StatelessWidget {
  const SosStrip({super.key, required this.onTap});

  final VoidCallback onTap;

  static const _coral = AppColors.sosStart;

  @override
  Widget build(BuildContext context) {
    final palette = MeditationPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: 'Emergency Calm, 3 minute session for cravings',
      child: Material(
        color: isDark ? _coral.withValues(alpha: 0.14) : const Color(0xFFFFF1F0),
        borderRadius: AppRadius.large,
        child: InkWell(
          borderRadius: AppRadius.large,
          onTap: () {
            HapticFeedback.mediumImpact();
            onTap();
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.large,
              border: Border.all(color: _coral.withValues(alpha: 0.25)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 34,
                    height: 34,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _coral.withValues(alpha: 0.5),
                              width: 1.5,
                            ),
                          ),
                        )
                            .animate(onPlay: (c) => c.repeat())
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.35, 1.35),
                              duration: 1600.ms,
                              curve: Curves.easeOut,
                            )
                            .fadeOut(duration: 1600.ms),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: _coral,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.waves,
                              size: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Craving right now?',
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Three minutes of Emergency Calm breaks the wave.',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            fontSize: 11.5,
                            color: palette.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs + 1,
                    ),
                    decoration: BoxDecoration(
                      color: _coral,
                      borderRadius: AppRadius.circular,
                    ),
                    child: Text(
                      '3 min',
                      style: AppTypography.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
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
