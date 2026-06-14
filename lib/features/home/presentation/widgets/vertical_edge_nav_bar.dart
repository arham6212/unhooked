import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../models/bottom_tab.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class VerticalEdgeNavBar extends StatefulWidget {
  const VerticalEdgeNavBar({
    super.key,
    required this.selectedTab,
    required this.onTap,
  });

  final BottomTab selectedTab;
  final ValueChanged<BottomTab> onTap;

  @override
  State<VerticalEdgeNavBar> createState() => _VerticalEdgeNavBarState();
}

class _VerticalEdgeNavBarState extends State<VerticalEdgeNavBar> {
  bool _isExpanded = true;
  Timer? _collapseTimer;

  @override
  void initState() {
    super.initState();
    _startCollapseTimer();
  }

  @override
  void dispose() {
    _collapseTimer?.cancel();
    super.dispose();
  }

  void _startCollapseTimer() {
    _collapseTimer?.cancel();
    _collapseTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _isExpanded) {
        setState(() => _isExpanded = false);
      }
    });
  }

  void _expand() {
    HapticFeedback.selectionClick();
    setState(() => _isExpanded = true);
    _startCollapseTimer();
  }

  void _handleTabTap(BottomTab tab) {
    HapticFeedback.lightImpact();
    widget.onTap(tab);
    _startCollapseTimer();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _isExpanded ? _startCollapseTimer : _expand,
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: const EdgeInsets.only(right: 8), // Slight margin from screen edge
          child: ClipRRect(
            borderRadius: AppRadius.extraLarge,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  vertical: _isExpanded ? 16 : 12,
                  horizontal: _isExpanded ? 8 : 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161616).withValues(alpha: 0.75) : Colors.white.withValues(alpha: 0.85),
                  borderRadius: AppRadius.extraLarge,
                  border: Border.all(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                  ),
                  boxShadow: [
                    if (!isDark)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(-5, 5),
                      ),
                  ],
                ),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.center,
                  child: _isExpanded
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: BottomTab.values.map((tab) {
                            final selected = tab == widget.selectedTab;
                            return _EdgeItem(
                              tab: tab,
                              selected: selected,
                              isDark: isDark,
                              onTap: () => _handleTabTap(tab),
                            );
                          }).toList(),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.selectedTab.icon,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                              size: 20,
                            ),
                            const SizedBox(height: 8),
                            Icon(
                              LucideIcons.chevronLeft, // Indicates it can be pulled open
                              color: isDark ? Colors.white54 : AppColors.textMuted,
                              size: 16,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 800.ms).slideX(begin: 0.5, end: 0, duration: 800.ms, curve: Curves.easeOutCubic),
      ),
    );
  }
}

class _EdgeItem extends StatelessWidget {
  const _EdgeItem({
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: AnimatedScale(
          scale: selected ? 1.1 : 1.0,
          duration: 250.ms,
          curve: Curves.easeOutBack,
          child: Icon(
            tab.icon,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }
}
