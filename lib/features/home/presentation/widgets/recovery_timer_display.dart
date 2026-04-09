import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import 'home_widgets.dart';

class RecoveryTimerDisplay extends StatelessWidget {
  const RecoveryTimerDisplay({super.key, required this.elapsed});

  final Duration elapsed;

  static const _tabularFigures = [FontFeature.tabularFigures()];

  @override
  Widget build(BuildContext context) {
    final d = elapsed.inDays;
    final h = elapsed.inHours % 24;
    final m = elapsed.inMinutes % 60;
    final s = elapsed.inSeconds % 60;
    final style = AppTypography.heading2.copyWith(
      color: AppColors.onPrimary,
      fontFeatures: _tabularFigures,
    );
    final labelStyle = AppTypography.heading2.copyWith(
      color: AppColors.onPrimary.withValues(alpha: 0.7),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Icon(
          Icons.schedule_rounded,
          color: AppColors.onPrimary.withValues(alpha: 0.7),
          size: 20,
        ),
        const SizedBox(width: AppSpacing.md),
        SizedBox(
          child: Align(
            alignment: Alignment.centerLeft,
            child: FlipOnlyOnChange(
              value: d,
              textStyle: style,
              duration: const Duration(milliseconds: 320),
            ),
          ),
        ),
        Text('d', style: labelStyle),
        Text(':', style: labelStyle),
        FlipDigitPair(keyPrefix: 'th', value: h, textStyle: style),
        Text(':', style: labelStyle),
        FlipDigitPair(keyPrefix: 'tm', value: m, textStyle: style),
        Text(':', style: labelStyle),
        FlipDigitPair(keyPrefix: 'ts', value: s, textStyle: style),
      ],
    );
  }
}
