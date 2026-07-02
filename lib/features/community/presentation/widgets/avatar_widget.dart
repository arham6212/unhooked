import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_typography.dart';

/// Flat, solid-color rounded-square avatar with initials.
/// Deliberately gradient-free — the color itself is the personality.
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTypography.heading3.copyWith(
          color: Colors.white,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          height: 1,
        ),
      ),
    );
  }
}
