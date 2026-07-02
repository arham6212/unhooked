import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/onboarding_answers.dart';
import '../providers/onboarding_controller.dart';
import '../widgets/intro_button.dart';
import '../widgets/option_row.dart';

enum _Step { privacy, goal, hardestTime, attempts, response }

/// Scene 4 — Calibration. A privacy promise first, then exactly three
/// questions, each of which visibly changes the product. The progress
/// hairline starts pre-filled: downloading the app already counted.
class SceneCalibration extends ConsumerStatefulWidget {
  const SceneCalibration({super.key});

  @override
  ConsumerState<SceneCalibration> createState() => _SceneCalibrationState();
}

class _SceneCalibrationState extends ConsumerState<SceneCalibration> {
  _Step _step = _Step.privacy;
  bool _advancing = false;

  static const _progress = {
    _Step.privacy: 0.12,
    _Step.goal: 0.3,
    _Step.hardestTime: 0.5,
    _Step.attempts: 0.7,
    _Step.response: 0.88,
  };

  void _selectAndAdvance(VoidCallback select, _Step nextStep) {
    if (_advancing) return;
    _advancing = true;
    select();
    // Let the ember underline finish its sweep before moving on.
    Future.delayed(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      setState(() {
        _step = nextStep;
        _advancing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          _buildProgressHairline(),
          if (_step == _Step.goal) ...[
            const SizedBox(height: 10),
            Text(
              "Downloading this app was the first step. It's already counted.",
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                color: AppColors.introText.withValues(alpha: 0.4),
              ),
            ),
          ],
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 550),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: KeyedSubtree(
                key: ValueKey(_step),
                child: _buildStep(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHairline() {
    return Stack(
      children: [
        Container(
          height: 2,
          color: AppColors.introText.withValues(alpha: 0.08),
        ),
        AnimatedFractionallySizedBox(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          alignment: Alignment.centerLeft,
          widthFactor: _progress[_step]!,
          child: Container(height: 2, color: AppColors.introEmber),
        ),
      ],
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      _Step.privacy => _buildPrivacy(),
      _Step.goal => _buildQuestion<OnboardingGoal>(
          question: 'What are you here\nto get back?',
          options: OnboardingGoal.values,
          labelOf: (o) => o.label,
          selected: ref.watch(onboardingProvider).answers.goal,
          onSelect: (o) => _selectAndAdvance(
            () => ref.read(onboardingProvider.notifier).selectGoal(o),
            _Step.hardestTime,
          ),
        ),
      _Step.hardestTime => _buildQuestion<HardestTime>(
          question: 'When does it\nhit hardest?',
          options: HardestTime.values,
          labelOf: (o) => o.label,
          selected: ref.watch(onboardingProvider).answers.hardestTime,
          onSelect: (o) => _selectAndAdvance(
            () => ref.read(onboardingProvider.notifier).selectHardestTime(o),
            _Step.attempts,
          ),
        ),
      _Step.attempts => _buildQuestion<PastAttempts>(
          question: 'Have you tried to\nquit before?',
          options: PastAttempts.values,
          labelOf: (o) => o.label,
          selected: ref.watch(onboardingProvider).answers.attempts,
          onSelect: (o) => _selectAndAdvance(
            () => ref.read(onboardingProvider.notifier).selectAttempts(o),
            _Step.response,
          ),
        ),
      _Step.response => _buildResponse(),
    };
  }

  Widget _buildPrivacy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(flex: 2),
        Icon(
          LucideIcons.lock,
          size: 34,
          color: AppColors.introEmber.withValues(alpha: 0.8),
        ),
        const SizedBox(height: 24),
        const Text('Before anything else', style: AppTypography.serifTitle),
        const SizedBox(height: 14),
        Text(
          'What you share stays on this phone until you say otherwise.\n'
          'No names. No feeds. No judgment.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.introText.withValues(alpha: 0.6),
          ),
        ),
        const Spacer(flex: 3),
        IntroButton(
          label: 'Understood',
          onPressed: () => setState(() => _step = _Step.goal),
        ),
        const SizedBox(height: 34),
      ],
    );
  }

  Widget _buildQuestion<T>({
    required String question,
    required List<T> options,
    required String Function(T) labelOf,
    required T? selected,
    required ValueChanged<T> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 64),
        Text(question, style: AppTypography.serifTitle),
        const SizedBox(height: 36),
        for (final option in options)
          OptionRow(
            label: labelOf(option),
            selected: option == selected,
            onTap: () => onSelect(option),
          ),
      ],
    );
  }

  Widget _buildResponse() {
    final attempts = ref.watch(onboardingProvider).answers.attempts;
    final line = switch (attempts) {
      PastAttempts.many =>
        'Good. Every attempt was a rep.\nThis time, you train differently.',
      PastAttempts.few =>
        "Then you already know how it starts.\nThis time you'll know how it holds.",
      PastAttempts.first =>
        "Then you're starting with a full tank.\nWe'll make it count.",
      null => "However you got here —\nthis time you won't do it alone.",
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(flex: 2),
        Text(line, style: AppTypography.serifTitle),
        const Spacer(flex: 3),
        IntroButton(
          label: 'Continue',
          onPressed: () => ref.read(onboardingProvider.notifier).next(),
        ),
        const SizedBox(height: 34),
      ],
    );
  }
}
