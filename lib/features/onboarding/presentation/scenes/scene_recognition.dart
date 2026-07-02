import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../providers/onboarding_controller.dart';

/// Scene 2 — Recognition. A film-title sequence, not a feature tour:
/// one line at a time, naming the user's experience without asking
/// them to confess anything. The final line breaks the rhythm with a
/// hard cut. Auto-advance is disabled for assistive tech and reduced
/// motion — tapping always advances.
class SceneRecognition extends ConsumerStatefulWidget {
  const SceneRecognition({super.key});

  @override
  ConsumerState<SceneRecognition> createState() => _SceneRecognitionState();
}

class _SceneRecognitionState extends ConsumerState<SceneRecognition> {
  static const _lines = [
    "You've made promises at 2 a.m.",
    "You've deleted things, blocked things, sworn it was the last time.",
    "You've carried this alone, where no one could see.",
    'Not anymore.',
  ];
  static const _holdMs = [2600, 3400, 3200, 1800];

  int _index = 0;
  Timer? _timer;

  bool get _autoAdvance {
    final media = MediaQuery.of(context);
    return !media.disableAnimations && !media.accessibleNavigation;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _arm();
  }

  void _arm() {
    _timer?.cancel();
    if (!_autoAdvance) return;
    _timer = Timer(Duration(milliseconds: _holdMs[_index]), _advance);
  }

  void _advance() {
    _timer?.cancel();
    if (_index >= _lines.length - 1) {
      ref.read(onboardingProvider.notifier).next();
      return;
    }
    setState(() => _index++);
    if (_index == _lines.length - 1) HapticFeedback.lightImpact();
    _arm();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFinalLine = _index == _lines.length - 1;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _advance,
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: AnimatedSwitcher(
                // The last line lands as a hard cut — the rhythm break is
                // the emphasis.
                duration: Duration(milliseconds: isFinalLine ? 90 : 700),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: Text(
                  _lines[_index],
                  key: ValueKey(_index),
                  textAlign: TextAlign.center,
                  style: AppTypography.serifTitle.copyWith(fontSize: 27),
                ),
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: TextButton(
              onPressed: () =>
                  ref.read(onboardingProvider.notifier).skipToCalibration(),
              child: Text(
                'Skip',
                style: AppTypography.caption.copyWith(
                  color: AppColors.introText.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
