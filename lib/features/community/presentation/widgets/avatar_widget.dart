import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

/// Gradient-backed circular avatar with an initial letter.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.initial,
    required this.color,
    this.size = 36,
  });

  final String initial;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Build a subtle gradient from the base colour to a slightly lighter tone.
    final HSLColor hsl = HSLColor.fromColor(color);
    final Color lighter = hsl
        .withLightness((hsl.lightness + 0.18).clamp(0.0, 1.0))
        .toColor();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color, lighter],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.30),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTypography.heading3.copyWith(
          color: AppColors.onPrimary,
          fontSize: size * 0.42,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
