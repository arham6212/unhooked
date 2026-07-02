import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/bottom_tab.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: BottomTab.values.map((tab) {
              final selected = tab == selectedTab;
              return _NavItem(
                tab: tab,
                selected: selected,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onTap(tab);
                },
              );
            }).toList(),
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
    required this.onTap,
  });

  final BottomTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryXLight : Colors.transparent,
                borderRadius: AppRadius.circular,
              ),
              child: Icon(
                tab.icon,
                color: selected ? AppColors.primary : AppColors.textSubtle,
                size: 21,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              tab.label,
              style: AppTypography.caption.copyWith(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.primary : AppColors.textSubtle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
