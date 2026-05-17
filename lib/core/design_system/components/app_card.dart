import 'package:flutter/material.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.cardTheme.color ?? AppColors.surface;

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: AppRadius.large,
        boxShadow: [
          // Outer diffuse — blue-tinted ambient lift
          BoxShadow(
            color: const Color(0xFF2563FF).withValues(alpha: 0.055),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          // Inner sharp — subtle depth contact shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }
}
