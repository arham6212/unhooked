import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/design_system/tokens/app_colors.dart';

enum DayStatus {
  success,
  relapse,
  future,
}

class RelapseHeatmap extends StatelessWidget {
  const RelapseHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate 30 days of mock data
    final List<DayStatus> history = List.generate(30, (index) {
      if (index == 5 || index == 17) return DayStatus.relapse;
      if (index > 26) return DayStatus.future;
      return DayStatus.success;
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Holographic Glowing Orbs Grid (6x5)
        SizedBox(
          width: 134, // 6 items * 12px + 5 spaces * 10px = 72 + 50 = 122 + breathing room = 134
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(30, (i) {
              return _GlowingOrb(status: history[i], index: i);
            }),
          ),
        ),
      ],
    );
  }
}

class _GlowingOrb extends StatelessWidget {
  final DayStatus status;
  final int index;

  const _GlowingOrb({required this.status, required this.index});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const double size = 12.0; // Perfect orb size
    
    Color bgColor;
    Color borderColor = Colors.transparent;
    List<BoxShadow>? shadows;
    
    switch (status) {
      case DayStatus.success:
        bgColor = AppColors.primary.withValues(alpha: 0.9);
        shadows = [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.6),
            blurRadius: 8,
            spreadRadius: 1,
          )
        ];
        break;
      case DayStatus.relapse:
        bgColor = Colors.transparent;
        borderColor = AppColors.error.withValues(alpha: 0.8);
        shadows = [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.4),
            blurRadius: 6,
            spreadRadius: 0.5,
          )
        ];
        break;
      case DayStatus.future:
        bgColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05);
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: borderColor != Colors.transparent ? Border.all(color: borderColor, width: 2) : null,
        boxShadow: shadows,
      ),
      child: status == DayStatus.relapse 
          ? Center(
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  boxShadow: [
                     BoxShadow(color: AppColors.error, blurRadius: 4)
                  ]
                ),
              ),
            )
          : null,
    )
    .animate(delay: (20 * index).ms) // Elegant staggered cascade wave
    .scaleXY(begin: 0.0, end: 1.0, duration: 600.ms, curve: Curves.easeOutBack)
    .fadeIn(duration: 600.ms);
  }
}
