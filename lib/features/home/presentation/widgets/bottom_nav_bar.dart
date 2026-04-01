import 'package:flutter/material.dart';
import 'home_constants.dart';
import 'home_widgets.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, 
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.menu_book_rounded, 'Journal'),
      (Icons.people_rounded, 'Community'),
      (Icons.history_rounded, 'History'),
      (Icons.settings_rounded, 'Settings'),
    ];

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
        children: List.generate(
          items.length,
          (i) {
            final (icon, label) = items[i];
            final selected = i == selectedIndex;
            return InkWell(
              onTap: () => onTap(i),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 24,
                      color: selected
                          ? kPrimaryStart
                          : (isDark ? Colors.white54 : kQuoteMuted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
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
          },
        ),
      ),
    );
  }
}
