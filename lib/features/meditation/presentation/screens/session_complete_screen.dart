import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class SessionCompleteScreen extends StatefulWidget {
  const SessionCompleteScreen({
    super.key,
    required this.title,
    required this.durationSeconds,
    required this.color,
  });

  final String title;
  final int durationSeconds;
  final Color color;

  @override
  State<SessionCompleteScreen> createState() => _SessionCompleteScreenState();
}

class _SessionCompleteScreenState extends State<SessionCompleteScreen> {
  int? _selectedMood;

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = widget.durationSeconds ~/ 60;
    final seconds = widget.durationSeconds % 60;
    final timeStr = minutes > 0
        ? '$minutes min ${seconds > 0 ? "$seconds sec" : ""}'
        : '$seconds sec';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/mountain_lake.jpeg',
              fit: BoxFit.cover,
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.05, 1.05),
              duration: 20.seconds,
              curve: Curves.easeInOutSine,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0A0E1A).withValues(alpha: 0.85),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Checkmark
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withValues(alpha: 0.15),
                      border: Border.all(
                        color: widget.color.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.2),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.check,
                      size: 44,
                      color: widget.color,
                    ),
                  ).animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  ).shimmer(
                    duration: 2.seconds,
                    color: widget.color.withValues(alpha: 0.4),
                  ).scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.05, 1.05),
                    duration: 3.seconds,
                    curve: Curves.easeInOutSine,
                  ).animate().scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.0, 1.0),
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      ).fadeIn(duration: 400.ms),

                  const SizedBox(height: AppSpacing.xxl),

                  Text(
                    'Session Complete',
                    style: AppTypography.heading1.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    widget.title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white54,
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 500.ms),

                  const SizedBox(height: AppSpacing.xxl),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CompleteStat(
                        icon: LucideIcons.clock,
                        value: timeStr,
                        label: 'Duration',
                        color: widget.color,
                      ),
                    ],
                  ).animate().fadeIn(delay: 500.ms, duration: 500.ms)
                      .slideY(begin: 0.05, end: 0, duration: 500.ms, delay: 500.ms),

                  const SizedBox(height: AppSpacing.xxl),

                  // Feedback Section
                  Text(
                    'How are you feeling?',
                    style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
                  ).animate().fadeIn(delay: 700.ms, duration: 500.ms),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final isSelected = _selectedMood == index;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedMood = index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? widget.color.withValues(alpha: 0.2) : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? widget.color : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            ['😞', '🙁', '😐', '🙂', '🤩'][index],
                            style: TextStyle(fontSize: isSelected ? 28 : 24),
                          ),
                        ),
                      ).animate().fadeIn(delay: (700 + index * 100).ms, duration: 400.ms);
                    }),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  Text(
                    '"The mind is everything.\nWhat you think, you become."',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white38,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),

                  const SizedBox(height: AppSpacing.xs),

                  Text(
                    '— Buddha',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white24,
                    ),
                  ).animate().fadeIn(delay: 1200.ms, duration: 500.ms),

                  const Spacer(flex: 2),

                  // Done button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.go('/meditate');
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: AppRadius.large,
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        'Done',
                        style: AppTypography.button.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ).animate().fadeIn(delay: 1300.ms, duration: 500.ms)
                      .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 1300.ms),

                  const SizedBox(height: AppSpacing.md),

                  // Share button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Share.share('I just completed a $timeStr meditation on Inner Monk! 🧘‍♂️');
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: AppRadius.large,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.share, size: 18, color: Colors.white),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Share Milestone',
                            style: AppTypography.button.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 1400.ms, duration: 500.ms)
                      .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 1400.ms),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompleteStat extends StatelessWidget {
  const _CompleteStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: AppRadius.large,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.heading3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}
