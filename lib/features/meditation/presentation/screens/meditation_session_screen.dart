import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../domain/entities/meditation.dart';
import '../providers/meditation_provider.dart';
import '../widgets/breathing_circle.dart';

class MeditationSessionScreen extends ConsumerStatefulWidget {
  const MeditationSessionScreen({super.key, required this.meditationId});

  final String meditationId;

  @override
  ConsumerState<MeditationSessionScreen> createState() =>
      _MeditationSessionScreenState();
}

class _MeditationSessionScreenState
    extends ConsumerState<MeditationSessionScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  int _currentStepIndex = 0;
  int _stepElapsed = 0;
  bool _isPaused = false;
  bool _isStarted = false;
  Meditation? _meditation;

  int get _totalDurationSeconds =>
      _meditation?.steps.fold(0, (sum, s) => sum! + s.durationSeconds) ?? 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meditations = ref.read(meditationsProvider);
      final m = meditations.firstWhere((m) => m.id == widget.meditationId);
      setState(() => _meditation = m);
    });
  }

  void _startSession() {
    setState(() => _isStarted = true);
    HapticFeedback.mediumImpact();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isPaused || _meditation == null) return;

      setState(() {
        _elapsedSeconds++;
        _stepElapsed++;

        final currentStep = _meditation!.steps[_currentStepIndex];
        if (_stepElapsed >= currentStep.durationSeconds) {
          if (_currentStepIndex < _meditation!.steps.length - 1) {
            _currentStepIndex++;
            _stepElapsed = 0;
            HapticFeedback.selectionClick();
          } else {
            _completeSession();
          }
        }
      });
    });
  }

  void _togglePause() {
    HapticFeedback.lightImpact();
    setState(() => _isPaused = !_isPaused);
  }

  void _completeSession() {
    _timer?.cancel();
    HapticFeedback.heavyImpact();

    ref.read(meditationStatsProvider.notifier).addSession(
      (_elapsedSeconds ~/ 60).clamp(1, 999),
    );

    context.pushReplacement(
      '/meditate/complete',
      extra: {
        'title': _meditation!.title,
        'duration': _elapsedSeconds,
        'color': _meditation!.accentColor,
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_meditation == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0E1A),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final m = _meditation!;
    final totalSec = _totalDurationSeconds;
    final progress = totalSec > 0 ? _elapsedSeconds / totalSec : 0.0;
    final remaining = totalSec - _elapsedSeconds;
    final remainMin = (remaining ~/ 60).toString().padLeft(2, '0');
    final remainSec = (remaining % 60).toString().padLeft(2, '0');

    final currentStep = m.steps[_currentStepIndex];
    final stepProgress = currentStep.durationSeconds > 0
        ? _stepElapsed / currentStep.durationSeconds
        : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/mountain_lake.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0A0E1A).withValues(alpha: 0.7),
                    const Color(0xFF0A0E1A).withValues(alpha: 0.85),
                    const Color(0xFF0A0E1A).withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      _CircleIconButton(
                        icon: LucideIcons.x,
                        onTap: () {
                          _timer?.cancel();
                          context.pop();
                        },
                      ),
                      const Spacer(),
                      if (_isStarted)
                        Text(
                          '$remainMin:$remainSec',
                          style: AppTypography.mono.copyWith(
                            color: Colors.white70,
                            fontSize: 16,
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                        ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                if (!_isStarted) ...[
                  // Pre-session view
                  Icon(
                    m.category.icon,
                    size: 48,
                    color: m.accentColor.withValues(alpha: 0.7),
                  ).animate().fadeIn(duration: 600.ms).scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                        duration: 600.ms,
                      ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    m.title,
                    style: AppTypography.heading1.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${m.durationMinutes} minutes',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white54,
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
                  const SizedBox(height: AppSpacing.xl),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
                    child: Text(
                      m.description,
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white38,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
                ] else ...[
                  // Active session
                  if (m.breathingPattern != null)
                    BreathingCircle(
                      pattern: m.breathingPattern!,
                      isActive: !_isPaused,
                      color: m.accentColor,
                    ).animate().fadeIn(duration: 800.ms),

                  const SizedBox(height: AppSpacing.xxl),

                  // Step instruction
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      key: ValueKey(_currentStepIndex),
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        currentStep.instruction,
                        style: AppTypography.bodyLarge.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.6,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Step progress
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: ClipRRect(
                      borderRadius: AppRadius.circular,
                      child: LinearProgressIndicator(
                        value: stepProgress.clamp(0.0, 1.0),
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation(
                          m.accentColor.withValues(alpha: 0.6),
                        ),
                        minHeight: 3,
                      ),
                    ),
                  ),
                ],

                const Spacer(flex: 2),

                // Bottom controls
                if (!_isStarted)
                  _StartButton(
                    color: m.accentColor,
                    onTap: _startSession,
                  ).animate().fadeIn(delay: 500.ms, duration: 500.ms)
                      .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 500.ms)
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CircleIconButton(
                        icon: _isPaused ? LucideIcons.play : LucideIcons.pause,
                        size: 64,
                        iconSize: 28,
                        onTap: _togglePause,
                      ),
                    ],
                  ),

                const SizedBox(height: AppSpacing.xxl),

                // Overall progress
                if (_isStarted)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: AppRadius.circular,
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            backgroundColor: Colors.white.withValues(alpha: 0.08),
                            valueColor: AlwaysStoppedAnimation(
                              m.accentColor.withValues(alpha: 0.4),
                            ),
                            minHeight: 2,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Step ${_currentStepIndex + 1} of ${m.steps.length}',
                          style: AppTypography.caption.copyWith(
                            color: Colors.white30,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.size = 40,
    this.iconSize = 20,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Icon(icon, size: iconSize, color: Colors.white70),
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: AppRadius.circular,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          'Begin Session',
          style: AppTypography.button.copyWith(
            color: Colors.white,
            fontSize: 17,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
