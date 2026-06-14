import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';

import 'borderless_stats_section.dart';
import 'editorial_quote_section.dart';
import '../../../../core/design_system/components/app_scrollbar.dart';

class PremiumGlassSheet extends StatelessWidget {
  const PremiumGlassSheet({
    super.key,
    required this.onSosTap,
    required this.onJournalTap,
  });

  final VoidCallback onSosTap;
  final VoidCallback onJournalTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Smooth iOS-like sheet physics
    return DraggableScrollableSheet(
      initialChildSize: 0.18, // Just the handle and quick actions visible
      minChildSize: 0.18,
      maxChildSize: 0.85,
      snap: true,
      snapSizes: const [0.18, 0.5, 0.85],
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF161616).withValues(alpha: 0.75) : Colors.white.withValues(alpha: 0.85),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 30,
                      offset: const Offset(0, -10),
                    ),
                ],
              ),
              child: AppScrollbar(
                controller: scrollController,
                interactive: true,
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                  // Draggable Handle & Quick Actions (Always visible at bottom)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Quick Actions
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _QuickActionBtn(
                                icon: LucideIcons.pencil,
                                label: 'Journal',
                                onTap: onJournalTap,
                                isDark: isDark,
                              ),
                              _QuickActionBtn(
                                icon: LucideIcons.heartPulse,
                                label: 'SOS',
                                onTap: onSosTap,
                                isDark: isDark,
                                isPrimary: true,
                              ),
                              _QuickActionBtn(
                                icon: LucideIcons.activity,
                                label: 'Health',
                                onTap: () {},
                                isDark: isDark,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),

                  // Deep Content (Visible when dragged up)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Divider(
                          height: 1,
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                        ),
                        const SizedBox(height: AppSpacing.xl * 1.5),
                        
                        const BorderlessStatsSection(),
                        
                        const SizedBox(height: AppSpacing.xl * 2),
                        
                        const EditorialQuoteSection(),
                        
                        const SizedBox(height: 120), // Bottom padding
                      ],
                    ),
                  ),
                ],
              ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickActionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDark;
  final bool isPrimary;

  const _QuickActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDark,
    this.isPrimary = false,
  });

  @override
  State<_QuickActionBtn> createState() => _QuickActionBtnState();
}

class _QuickActionBtnState extends State<_QuickActionBtn> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isPrimary 
        ? AppColors.error.withValues(alpha: 0.15)
        : (widget.isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03));
        
    final iconColor = widget.isPrimary 
        ? AppColors.error 
        : (widget.isDark ? Colors.white : AppColors.textPrimary);

    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.selectionClick();
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        HapticFeedback.lightImpact();
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
                border: widget.isPrimary ? Border.all(color: AppColors.error.withValues(alpha: 0.3)) : null,
              ),
              child: Icon(widget.icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.isPrimary 
                    ? AppColors.error 
                    : (widget.isDark ? Colors.white70 : AppColors.textMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
