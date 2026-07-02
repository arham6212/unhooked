import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../providers/onboarding_controller.dart';
import '../widgets/intro_button.dart';
import '../widgets/plasticity_line.dart';

/// Scene 3 — The Reframe. One credible mechanism instead of fear
/// statistics: the line of light reorganizes from chaos to calm while
/// the copy replaces shame with plasticity.
class SceneReframe extends ConsumerWidget {
  const SceneReframe({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instant = MediaQuery.of(context).disableAnimations;

    Widget reveal(Widget child, int delayMs) {
      if (instant) return child;
      return child
          .animate(delay: delayMs.ms)
          .fadeIn(duration: 700.ms, curve: Curves.easeOutCubic)
          .moveY(begin: 10, end: 0, duration: 700.ms, curve: Curves.easeOutCubic);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const Spacer(flex: 2),
          const PlasticityLine(),
          const SizedBox(height: 44),
          reveal(
            Text(
              "Your brain isn't broken.\nIt's trained.",
              textAlign: TextAlign.center,
              style: AppTypography.serifDisplay.copyWith(fontSize: 31),
            ),
            600,
          ),
          const SizedBox(height: 16),
          reveal(
            Text(
              'And anything trained can be retrained. Neuroscience calls it '
              "plasticity. You'll call it the way back.",
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.introText.withValues(alpha: 0.6),
              ),
            ),
            1400,
          ),
          const SizedBox(height: 24),
          reveal(
            Text(
              'GROUNDED IN HABIT-REVERSAL, URGE-SURFING,\nAND MINDFULNESS RESEARCH',
              textAlign: TextAlign.center,
              style: AppTypography.label.copyWith(
                color: AppColors.introText.withValues(alpha: 0.35),
              ),
            ),
            2000,
          ),
          const Spacer(flex: 3),
          reveal(
            IntroButton(
              label: 'Continue',
              onPressed: () => ref.read(onboardingProvider.notifier).next(),
            ),
            2400,
          ),
          const SizedBox(height: 34),
        ],
      ),
    );
  }
}
