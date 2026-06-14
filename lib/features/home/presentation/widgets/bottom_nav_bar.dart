import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/bottom_tab.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.selectedTab,
    required this.onTap,
  });

  final BottomTab selectedTab;
  final ValueChanged<BottomTab> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    // Use SafeArea or bottom padding to ensure it floats well above the bottom.
    // By returning it from the Scaffold's bottomNavigationBar property,
    // Flutter will automatically push FABs up so they don't collide.
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: ClipRRect(
          borderRadius: AppRadius.extraLarge,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161616).withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.85),
                borderRadius: AppRadius.extraLarge,
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: BottomTab.values.map((tab) {
                  final selected = tab == selectedTab;
                  return Expanded(
                    child: _NavItem(
                      tab: tab,
                      selected: selected,
                      isDark: isDark,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onTap(tab);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final BottomTab tab;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : (isDark ? AppColors.textMutedAlt : AppColors.textMuted);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: AnimatedScale(
            scale: selected ? 1.15 : 1.0,
            duration: 250.ms,
            curve: Curves.easeOutBack,
            child: Icon(
              tab.icon,
              color: color,
              size: 22,
            ),
          ),
        ),
      ).animate(target: selected ? 1 : 0).shimmer(duration: 800.ms, color: AppColors.primaryLight.withValues(alpha: 0.2)),
    );
  }
}
