import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../providers/onboarding_controller.dart';
import '../utils/time_context.dart';
import '../widgets/intro_button.dart';

/// Scene 1 — The Pause. A cold open: the ember fades in, then the copy
/// arrives line by line. The delayed CTA manufactures a moment of
/// stillness; tapping anywhere fast-forwards the reveal.
class SceneArrival extends ConsumerStatefulWidget {
  const SceneArrival({super.key});

  @override
  ConsumerState<SceneArrival> createState() => _SceneArrivalState();
}

class _SceneArrivalState extends ConsumerState<SceneArrival> {
  late final String _contextLine;
  bool _skipReveal = false;

  @override
  void initState() {
    super.initState();
    _contextLine = timeContextLine(DateTime.now());
  }

  Widget _reveal(Widget child, int delayMs, bool instant) {
    if (instant) return child;
    return child
        .animate(delay: delayMs.ms)
        .fadeIn(duration: 700.ms, curve: Curves.easeOutCubic)
        .moveY(begin: 12, end: 0, duration: 700.ms, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final instant = _skipReveal || MediaQuery.of(context).disableAnimations;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (!_skipReveal) setState(() => _skipReveal = true);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 22),
            Center(
              child: _reveal(
                Text(
                  'INNER MONK',
                  style: AppTypography.label.copyWith(
                    color: AppColors.introText.withValues(alpha: 0.32),
                    letterSpacing: 3,
                  ),
                ),
                400,
                instant,
              ),
            ),
            const Spacer(),
            _reveal(
              Text(
                _contextLine,
                style: AppTypography.caption.copyWith(
                  fontSize: 12,
                  color: AppColors.introText.withValues(alpha: 0.48),
                  letterSpacing: 1.8,
                ),
              ),
              800,
              instant,
            ),
            const SizedBox(height: 16),
            _reveal(
              const Text('This is where\nit turns.', style: AppTypography.serifDisplay),
              1400,
              instant,
            ),
            const SizedBox(height: 14),
            _reveal(
              Text(
                'A quiet, private place to take your mind back.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.introText.withValues(alpha: 0.6),
                ),
              ),
              2200,
              instant,
            ),
            const SizedBox(height: 44),
            _reveal(
              IntroButton(
                label: 'Begin',
                onPressed: () => ref.read(onboardingProvider.notifier).next(),
              ),
              2800,
              instant,
            ),
            const SizedBox(height: 14),
            _reveal(
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.lock,
                      size: 12,
                      color: AppColors.introText.withValues(alpha: 0.35),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Private by design',
                      style: AppTypography.caption.copyWith(
                        fontSize: 12,
                        color: AppColors.introText.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ),
              ),
              3000,
              instant,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
