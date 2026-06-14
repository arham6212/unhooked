import 'dart:ui';
import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  final bool glass;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.color,
    this.onTap,
    this.glass = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? AppColors.surfaceDark : AppColors.surface;
    final cardColor = color ?? defaultColor;
    
    final borderColor = isDark ? AppColors.borderDark : AppColors.border;

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: glass ? cardColor.withValues(alpha: 0.7) : cardColor,
        borderRadius: AppRadius.large,
        border: Border.all(color: borderColor),
        boxShadow: glass ? [] : [
          // Outer diffuse — blue-tinted ambient lift (subtle for dark mode)
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.3) : const Color(0xFF2563FF).withValues(alpha: 0.04),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          // Inner sharp — subtle depth contact shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );

    if (glass) {
      content = ClipRRect(
        borderRadius: AppRadius.large,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: content,
        ),
      );
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.large,
          child: content,
        ),
      );
    }
    return content;
  }
}
