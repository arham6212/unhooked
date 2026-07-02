import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/meditation.dart';
import '../styles/meditation_palette.dart';

/// List card for guided sessions and breathing exercises.
/// Leads with the honest question — "how long will this take?" — via a
/// flat duration disc; the category icon lives as an oversized watermark.
class PracticeCard extends StatelessWidget {
  const PracticeCard({super.key, required this.meditation, required this.onTap});

  final Meditation meditation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = MeditationPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = meditation.accentColor;

    return Semantics(
      button: true,
      label: '${meditation.title}, ${meditation.durationMinutes} minutes',
      child: Container(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: AppRadius.large,
          border: Border.all(color: palette.border),
          boxShadow: AppShadows.sm,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.large,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            child: Stack(
              children: [
                Positioned(
                  right: -14,
                  bottom: -18,
                  child: Icon(
                    meditation.category.icon,
                    size: 84,
                    color: accent.withValues(alpha: isDark ? 0.10 : 0.06),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: isDark ? 0.18 : 0.12),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${meditation.durationMinutes}m',
                          style: AppTypography.caption.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: accent,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md + AppSpacing.xxs),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meditation.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: palette.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              meditation.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption.copyWith(
                                fontSize: 12,
                                color: palette.textMuted,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _MetaBadge(
                              meditation: meditation,
                              accent: accent,
                              palette: palette,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accent.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(LucideIcons.play, size: 11, color: accent),
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

/// Breathing exercises show their rhythm; guided sessions show their length
/// in steps — a small honest detail instead of decorative filler.
class _MetaBadge extends StatelessWidget {
  const _MetaBadge({
    required this.meditation,
    required this.accent,
    required this.palette,
    required this.isDark,
  });

  final Meditation meditation;
  final Color accent;
  final MeditationPalette palette;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final pattern = meditation.breathingPattern;
    final tinted = pattern != null;
    final label = pattern?.name ?? '${meditation.steps.length} steps';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + 1,
            vertical: 2.5,
          ),
          decoration: BoxDecoration(
            color: tinted
                ? accent.withValues(alpha: isDark ? 0.18 : 0.10)
                : palette.surfaceSunken,
            borderRadius: AppRadius.circular,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (tinted) ...[
                Icon(LucideIcons.wind, size: 10, color: accent),
                const SizedBox(width: 3),
              ],
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: tinted ? accent : palette.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Soundscapes get their own shape: a spinning-record motif of flat
/// concentric rings instead of a duration disc.
class SoundscapeCard extends StatelessWidget {
  const SoundscapeCard({super.key, required this.meditation, required this.onTap});

  final Meditation meditation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = MeditationPalette.of(context);
    final accent = meditation.accentColor;

    return Semantics(
      button: true,
      label: 'Soundscape: ${meditation.title}',
      child: Container(
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: AppRadius.large,
          border: Border.all(color: palette.border),
          boxShadow: AppShadows.sm,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.large,
          child: InkWell(
            borderRadius: AppRadius.large,
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  _RecordDisc(color: accent),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meditation.title,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          meditation.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            fontSize: 12,
                            color: palette.textMuted,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(LucideIcons.headphones,
                                size: 11, color: palette.textSubtle),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${meditation.durationMinutes} min · loops',
                              style: AppTypography.caption.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: palette.textSubtle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                    child: const Icon(LucideIcons.play, size: 15, color: Colors.white),
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

class _RecordDisc extends StatelessWidget {
  const _RecordDisc({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget ring(double size, double alpha, double width) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: alpha), width: width),
          ),
        );

    return SizedBox(
      width: 54,
      height: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ring(54, 0.18, 1.5),
          ring(38, 0.30, 1.5),
          ring(24, 0.42, 1.5),
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
