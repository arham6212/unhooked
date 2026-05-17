import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import 'home_widgets.dart';

class RecoveryTimerCard extends StatelessWidget {
  const RecoveryTimerCard({
    super.key,
    required this.elapsed,
    required this.onReset,
    this.onTap,
  });

  final Duration elapsed;
  final VoidCallback onReset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final d = elapsed.inDays;
    final h = elapsed.inHours % 24;
    final m = elapsed.inMinutes % 60;
    final s = elapsed.inSeconds % 60;
    final dayProgress = ((elapsed.inHours % 24) * 3600 +
            (elapsed.inMinutes % 60) * 60 +
            (elapsed.inSeconds % 60)) /
        86400;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.extraLarge,
        boxShadow: AppShadows.md,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryXLight,
                    borderRadius: AppRadius.medium,
                  ),
                  child: const Icon(LucideIcons.clock, size: 15, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Live Timer',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // H : M : S primary display + ring reset button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _UnitBlock(value: d, label: 'DAYS', pad: false),
                        _Separator(),
                        _UnitBlock(value: h, label: 'HRS', pad: true),
                        _Separator(),
                        _UnitBlock(value: m, label: 'MIN', pad: true),
                        _Separator(),
                        _UnitBlock(value: s, label: 'SEC', pad: true, flip: true),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: AppSpacing.lg),

                // Circular reset ring
                GestureDetector(
                  onTap: onReset,
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 3,
                            color: AppColors.border,
                          ),
                        ),
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: dayProgress,
                            strokeWidth: 3,
                            color: AppColors.primary,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.refreshCw,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      ':',
      style: AppTypography.heading2.copyWith(
        color: AppColors.border,
        fontWeight: FontWeight.w300,
        height: 1,
      ),
    );
  }
}

class _UnitBlock extends StatelessWidget {
  const _UnitBlock({
    required this.value,
    required this.label,
    this.pad = false,
    this.flip = false,
  });

  final int value;
  final String label;
  final bool pad;
  final bool flip;

  static const _tab = [FontFeature.tabularFigures()];

  @override
  Widget build(BuildContext context) {
    final display = pad ? value.toString().padLeft(2, '0') : value.toString();
    return Column(
      children: [
        flip
            ? FlipDigitPair(keyPrefix: label, value: value, textStyle: AppTypography.heading2.copyWith(
                fontFeatures: _tab,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ))
            : Text(
                display,
                style: AppTypography.heading2.copyWith(
                  fontFeatures: _tab,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
        const SizedBox(height: 3),
        Text(
          label,
          style: AppTypography.label.copyWith(
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
