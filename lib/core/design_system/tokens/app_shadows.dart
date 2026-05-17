import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  // Subtle lift — for inline elements, chips
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x05000000), blurRadius: 2),
  ];

  // Standard card elevation
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x0C000000), blurRadius: 16, spreadRadius: -2, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x05000000), blurRadius: 4, offset: Offset(0, 1)),
  ];

  // Prominent card — hero areas
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x10000000), blurRadius: 32, spreadRadius: -4, offset: Offset(0, 10)),
    BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  // Floating elements — modals, bottom sheets
  static const List<BoxShadow> xl = [
    BoxShadow(color: Color(0x14000000), blurRadius: 48, spreadRadius: -6, offset: Offset(0, 16)),
    BoxShadow(color: Color(0x08000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  // Colored glow shadow — pass any brand color
  static List<BoxShadow> colored(Color color, {double intensity = 1.0}) => [
    BoxShadow(
      color: color.withValues(alpha: 0.22 * intensity),
      blurRadius: 24,
      spreadRadius: -3,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.08 * intensity),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // Primary brand glow
  static List<BoxShadow> primary({double intensity = 1.0}) =>
      colored(AppColors.primary, intensity: intensity);
}
