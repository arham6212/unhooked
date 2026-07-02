import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../providers/onboarding_controller.dart';
import '../scenes/scene_arrival.dart';
import '../scenes/scene_calibration.dart';
import '../scenes/scene_first_light.dart';
import '../scenes/scene_recognition.dart';
import '../scenes/scene_reframe.dart';
import '../scenes/scene_vow.dart';
import '../widgets/ember_background.dart';

/// "First Light" — the intro sequence. The only dark surface in the
/// app: the user begins in the dark and the final transition is a
/// sunrise into the light UI. Scenes crossfade under an ember that
/// persists across the whole sequence; there is no swipe navigation.
class OnboardingFlowScreen extends ConsumerStatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  ConsumerState<OnboardingFlowScreen> createState() =>
      _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen> {
  final ValueNotifier<double> _emberBoost = ValueNotifier(0);
  bool _exiting = false;

  @override
  void dispose() {
    _emberBoost.dispose();
    super.dispose();
  }

  /// Ease the ember back to its resting glow after the vow.
  Future<void> _fadeBoost() async {
    while (mounted && _emberBoost.value > 0.01) {
      _emberBoost.value *= 0.85;
      await Future.delayed(const Duration(milliseconds: 16));
    }
    if (mounted) _emberBoost.value = 0;
  }

  void _enterApp() {
    if (_exiting) return;
    if (MediaQuery.of(context).disableAnimations) {
      ref.read(onboardingProvider.notifier).finish();
      return;
    }
    setState(() => _exiting = true);
  }

  Widget _sceneFor(OnboardingScene scene) {
    return switch (scene) {
      OnboardingScene.arrival => const SceneArrival(),
      OnboardingScene.recognition => const SceneRecognition(),
      OnboardingScene.reframe => const SceneReframe(),
      OnboardingScene.calibration => const SceneCalibration(),
      OnboardingScene.vow => SceneVow(
          onHoldProgress: (v) => _emberBoost.value = v,
        ),
      OnboardingScene.firstLight => SceneFirstLight(onEnter: _enterApp),
    };
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(onboardingProvider.select((s) => s.scene), (prev, next) {
      if (prev == OnboardingScene.vow) _fadeBoost();
    });
    final scene = ref.watch(onboardingProvider.select((s) => s.scene));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.introInk,
        body: Stack(
          fit: StackFit.expand,
          children: [
            EmberBackground(boost: _emberBoost),
            SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.015),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(scene),
                  child: _sceneFor(scene),
                ),
              ),
            ),
            if (_exiting) _buildSunrise(),
          ],
        ),
      ),
    );
  }

  /// The hand-off: light rises from the bottom of the screen, its
  /// leading edge tinted with the app's blue — the intro's first and
  /// only blue moment. When fully risen, the router takes over on a
  /// matching light surface.
  Widget _buildSunrise() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
      onEnd: () => ref.read(onboardingProvider.notifier).finish(),
      builder: (context, t, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: t,
            widthFactor: 1,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryXLight,
                    AppColors.background,
                    AppColors.background,
                  ],
                  stops: [0.0, 0.35, 1.0],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
