import 'package:flutter/material.dart';

import '../tokens/app_radius.dart';

class AppScrollbar extends StatelessWidget {
  final Widget child;
  final ScrollController? controller;
  final bool interactive;

  const AppScrollbar({
    super.key,
    required this.child,
    this.controller,
    this.interactive = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return RawScrollbar(
      controller: controller,
      interactive: interactive,
      thumbVisibility: false, 
      thickness: 6,
      radius: const Radius.circular(AppRadius.xs),
      thumbColor: isDark 
          ? Colors.white.withValues(alpha: 0.2) 
          : Colors.black.withValues(alpha: 0.15),
      crossAxisMargin: 4,
      child: child,
    );
  }
}
