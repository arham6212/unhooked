import 'package:flutter/material.dart';

import '../models/bottom_tab.dart';
import 'home_constants.dart';

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

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.paddingOf(context).bottom + 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: BottomTab.values.map((tab) {
          final selected = tab == selectedTab;

          return InkWell(
            onTap: () => onTap(tab),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tab.icon,
                    size: 24,
                    color: selected
                        ? kPrimaryStart
                        : (isDark ? Colors.white54 : kQuoteMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tab.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected
                          ? kPrimaryStart
                          : (isDark ? Colors.white54 : kQuoteMuted),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(), // ✅ IMPORTANT
      ),
    );
  }
}