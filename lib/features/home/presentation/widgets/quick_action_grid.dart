import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';

class _Action {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;

  const _Action({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
  });
}

const _kActions = [
  _Action(
    icon: LucideIcons.bookOpen,
    label: 'Journal',
    subtitle: 'Write your thoughts',
    color: Color(0xFF2563FF),
  ),
  _Action(
    icon: LucideIcons.users,
    label: 'Community',
    subtitle: 'Connect with others',
    color: Color(0xFF059669),
  ),
  _Action(
    icon: LucideIcons.graduationCap,
    label: 'Courses',
    subtitle: 'Learn & grow',
    color: Color(0xFF7C3AED),
  ),
  _Action(
    icon: LucideIcons.wrench,
    label: 'Tools',
    subtitle: 'Breathing & more',
    color: Color(0xFFB45309),
  ),
];

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({
    super.key,
    this.onJournal,
    this.onCommunity,
    this.onCourses,
    this.onTools,
  });

  final VoidCallback? onJournal;
  final VoidCallback? onCommunity;
  final VoidCallback? onCourses;
  final VoidCallback? onTools;

  @override
  Widget build(BuildContext context) {
    final taps = [onJournal, onCommunity, onCourses, onTools];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _ActionTile(action: _kActions[0], onTap: taps[0])),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _ActionTile(action: _kActions[1], onTap: taps[1])),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(child: _ActionTile(action: _kActions[2], onTap: taps[2])),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _ActionTile(action: _kActions[3], onTap: taps[3])),
          ],
        ),
      ],
    );
  }
}

class _ActionTile extends StatefulWidget {
  const _ActionTile({required this.action, this.onTap});
  final _Action action;
  final VoidCallback? onTap;

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _pressed = true);
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        child: Container(
          height: 112,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.extraLarge,
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: AppShadows.sm,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      widget.action.icon,
                      size: 22,
                      color: widget.action.color,
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: AppRadius.circular,
                      ),
                      child: Icon(
                        LucideIcons.arrowUpRight,
                        size: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  widget.action.label,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.action.subtitle,
                  style: AppTypography.caption.copyWith(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
