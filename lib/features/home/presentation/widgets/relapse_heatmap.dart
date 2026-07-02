import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

enum DayStatus {
  success,
  relapse,
}

class RelapseHeatmap extends StatelessWidget {
  const RelapseHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DayStatus> history = List.generate(32, (index) {
      if (index >= 29) return DayStatus.relapse;
      return DayStatus.success;
    });

    const double dotSize = 14.0;
    const double spacing = 8.0;
    const int columns = 7;
    const double gridWidth = columns * dotSize + (columns - 1) * spacing;

    return SizedBox(
      width: gridWidth,
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: List.generate(32, (i) {
          final isRelapse = history[i] == DayStatus.relapse;
          return Container(
            width: dotSize,
            height: dotSize,
            decoration: BoxDecoration(
              color: isRelapse ? AppColors.errorMuted : AppColors.successMuted,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}
