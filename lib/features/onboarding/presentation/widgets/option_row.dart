import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

/// A calibration choice: quiet text over a hairline. Selection sweeps
/// an ember underline instead of showing a checkbox or card.
class OptionRow extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const OptionRow({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: AppTypography.bodyLarge.copyWith(
                  color: selected
                      ? AppColors.introText
                      : AppColors.introText.withValues(alpha: 0.72),
                ),
                child: Text(label),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 1,
                  color: AppColors.introText.withValues(alpha: 0.08),
                ),
                AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.centerLeft,
                  widthFactor: selected ? 1 : 0,
                  child: Container(height: 1.5, color: AppColors.introEmber),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
