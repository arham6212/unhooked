import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../providers/onboarding_controller.dart';
import '../utils/time_context.dart';
import '../widgets/hold_to_commit.dart';

/// Scene 5 — The Vow. The signature moment: a date-stamped identity
/// line committed with a 3-second press-and-hold. Effort creates
/// ownership; the vow persists as an artifact the user keeps.
class SceneVow extends ConsumerStatefulWidget {
  final ValueChanged<double>? onHoldProgress;

  const SceneVow({super.key, this.onHoldProgress});

  @override
  ConsumerState<SceneVow> createState() => _SceneVowState();
}

class _SceneVowState extends ConsumerState<SceneVow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flash;
  late final Animation<double> _flashOpacity;
  bool _committed = false;

  @override
  void initState() {
    super.initState();
    _flash = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _flashOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 0.85), weight: 120),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 0), weight: 400),
    ]).animate(_flash);
  }

  @override
  void dispose() {
    _flash.dispose();
    super.dispose();
  }

  void _onCommitted() {
    ref.read(onboardingProvider.notifier).commitVow();
    setState(() => _committed = true);
    if (!MediaQuery.of(context).disableAnimations) {
      _flash.forward(from: 0);
    }
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) ref.read(onboardingProvider.notifier).next();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                vowDateLine(DateTime.now()),
                style: AppTypography.caption.copyWith(
                  fontSize: 12,
                  color: AppColors.introText.withValues(alpha: 0.48),
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _committed
                    ? null
                    : () => ref.read(onboardingProvider.notifier).cycleVow(),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: Text(
                    state.vowText,
                    key: ValueKey(state.vowText),
                    textAlign: TextAlign.center,
                    style: AppTypography.serifDisplay.copyWith(
                      fontSize: 32,
                      color: _committed
                          ? AppColors.introText
                          : AppColors.introText.withValues(alpha: 0.92),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _committed ? 0 : 1,
                child: Text(
                  'Tap the words to make them yours',
                  style: AppTypography.caption.copyWith(
                    fontSize: 12,
                    color: AppColors.introText.withValues(alpha: 0.3),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              HoldToCommit(
                onCommitted: _onCommitted,
                onProgress: widget.onHoldProgress,
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  _committed
                      ? 'Witnessed by you. Day One begins now.'
                      : 'Hold to make it real.',
                  key: ValueKey(_committed),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.introText.withValues(
                      alpha: _committed ? 0.7 : 0.5,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
        // Commit flash: a 120ms burst of light, then a slow settle.
        IgnorePointer(
          child: AnimatedBuilder(
            animation: _flashOpacity,
            builder: (context, _) {
              if (_flashOpacity.value == 0) return const SizedBox.shrink();
              return Container(
                color: AppColors.introText.withValues(alpha: _flashOpacity.value),
              );
            },
          ),
        ),
      ],
    );
  }
}
