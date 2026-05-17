import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';

class _FocusContent {
  final IconData icon;
  final String tag;
  final String title;
  final String description;
  final String cta;
  final Color accent;

  const _FocusContent({
    required this.icon,
    required this.tag,
    required this.title,
    required this.description,
    required this.cta,
    required this.accent,
  });
}

const _kMorning = _FocusContent(
  icon: LucideIcons.sun,
  tag: 'MORNING RITUAL',
  title: 'Start with intention',
  description: 'Take 3 deep breaths and set one intention for your day.',
  cta: 'Begin practice',
  accent: Color(0xFFB45309),
);

const _kAfternoon = _FocusContent(
  icon: LucideIcons.leaf,
  tag: 'MIDDAY RESET',
  title: 'Pause & realign',
  description: 'A 2-minute body scan resets stress before it builds.',
  cta: 'Try body scan',
  accent: Color(0xFF059669),
);

const _kEvening = _FocusContent(
  icon: LucideIcons.moon,
  tag: 'EVENING WIND-DOWN',
  title: 'Reflect on today',
  description: 'Write one thing you\'re grateful for from today.',
  cta: 'Open journal',
  accent: Color(0xFF7C3AED),
);

class TodaysFocusCard extends StatefulWidget {
  const TodaysFocusCard({super.key, this.onAction});

  final VoidCallback? onAction;

  @override
  State<TodaysFocusCard> createState() => _TodaysFocusCardState();
}

class _TodaysFocusCardState extends State<TodaysFocusCard> {
  bool _pressed = false;

  _FocusContent get _content {
    final hour = DateTime.now().hour;
    if (hour < 12) return _kMorning;
    if (hour < 18) return _kAfternoon;
    return _kEvening;
  }

  @override
  Widget build(BuildContext context) {
    final c = _content;

    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _pressed = true);
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onAction,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.extraLarge,
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: AppShadows.sm,
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left vertical accent bar
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: c.accent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tag with subtle dot
                        Row(
                          children: [
                            Icon(c.icon, size: 13, color: c.accent),
                            const SizedBox(width: AppSpacing.xs + 2),
                            Text(
                              c.tag,
                              style: AppTypography.label.copyWith(
                                color: c.accent,
                                fontSize: 10,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.sm + 2),

                        // Title
                        Text(
                          c.title,
                          style: AppTypography.heading2.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.2,
                            letterSpacing: -0.4,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xs),

                        // Description
                        Text(
                          c.description,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // CTA pill button
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs + 2,
                          ),
                          decoration: BoxDecoration(
                            color: c.accent,
                            borderRadius: AppRadius.circular,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                c.cta,
                                style: AppTypography.button.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(LucideIcons.arrowRight,
                                  size: 13, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
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
