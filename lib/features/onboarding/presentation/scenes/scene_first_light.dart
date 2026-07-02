import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../providers/onboarding_controller.dart';
import '../widgets/intro_button.dart';

/// Scene 6 — First Light. The streak is already alive: the timer has
/// been running since the vow, so the user enters the app with
/// something to protect, not something to start. The path ahead is
/// shown veiled — curiosity, not a paywall.
class SceneFirstLight extends ConsumerStatefulWidget {
  final VoidCallback onEnter;

  const SceneFirstLight({super.key, required this.onEnter});

  @override
  ConsumerState<SceneFirstLight> createState() => _SceneFirstLightState();
}

class _SceneFirstLightState extends ConsumerState<SceneFirstLight> {
  static const _path = [
    ('Steady the ground', false),
    ('Understand the pattern', false),
    ('Rewire the response', false),
    ('Rebuild the life', true),
    ('Beyond', true),
  ];

  late final DateTime _start;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _start = ref.read(onboardingProvider).answers.vowDate ?? DateTime.now();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String get _elapsed {
    final d = DateTime.now().difference(_start);
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    final timerDigits = _elapsed;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 2),
          Text(
            'DAY ONE',
            style: AppTypography.label.copyWith(
              color: AppColors.introEmber,
              letterSpacing: 2.4,
            ),
          ),
          const SizedBox(height: 10),
          Semantics(
            label: 'Day one timer running',
            child: Text(
              timerDigits,
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 44,
                fontWeight: FontWeight.w800,
                color: AppColors.introText,
                letterSpacing: -1,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your streak started the moment you committed.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.introText.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 40),
          for (var i = 0; i < _path.length; i++) _buildNode(i),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              'Unfolds as you go',
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                color: AppColors.introText.withValues(alpha: 0.35),
              ),
            ),
          ),
          const Spacer(flex: 3),
          IntroButton(label: 'Enter', onPressed: widget.onEnter),
          const SizedBox(height: 34),
        ],
      ),
    );
  }

  Widget _buildNode(int index) {
    final (label, veiled) = _path[index];
    final lit = index == 0;
    final isLast = index == _path.length - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 10,
          child: Column(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 7),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: lit
                      ? AppColors.introEmber
                      : AppColors.introText.withValues(alpha: 0.25),
                ),
              ),
              if (!isLast)
                Container(
                  width: 1,
                  height: 24,
                  margin: const EdgeInsets.only(top: 4),
                  color: AppColors.introText.withValues(alpha: 0.12),
                ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.introText.withValues(alpha: lit ? 1 : 0.45),
          ),
        ),
        if (veiled) ...[
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '✦',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.introEmber.withValues(alpha: 0.55),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
