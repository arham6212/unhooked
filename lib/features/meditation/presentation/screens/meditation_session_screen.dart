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
  Timer? _uiTimer;
  int _elapsedSeconds = 0;
  int _currentStepIndex = 0;
  int _stepElapsed = 0;
  bool _isPaused = false;
  bool _isStarted = false;
  bool _isUIVisible = true;
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
    _resetUiTimer();
    
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
    _resetUiTimer();
  }
  
  void _seekTo(int seconds) {
    if (_meditation == null) return;
    int target = seconds.clamp(0, _totalDurationSeconds);
    
    int acc = 0;
    int targetStep = 0;
    int targetStepElapsed = 0;
    
    for (int i = 0; i < _meditation!.steps.length; i++) {
      int stepDur = _meditation!.steps[i].durationSeconds;
      if (acc + stepDur > target) {
        targetStep = i;
        targetStepElapsed = target - acc;
        break;
      }
      acc += stepDur;
    }
    
    if (target == _totalDurationSeconds) {
       _completeSession();
       return;
    }
    
    setState(() {
      _elapsedSeconds = target;
      _currentStepIndex = targetStep;
      _stepElapsed = targetStepElapsed;
    });
    _resetUiTimer();
  }

  void _resetUiTimer() {
    _uiTimer?.cancel();
    if (!_isStarted || _isPaused) {
       setState(() => _isUIVisible = true);
       return;
    }
    setState(() => _isUIVisible = true);
    _uiTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _isStarted && !_isPaused) {
        setState(() => _isUIVisible = false);
      }
    });
  }

  void _toggleUI() {
    if (!_isStarted) return;
    if (!_isUIVisible) {
      _resetUiTimer();
    } else {
      setState(() => _isUIVisible = false);
      _uiTimer?.cancel();
    }
  }

  void _completeSession() {
    _timer?.cancel();
    _uiTimer?.cancel();
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
    _uiTimer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString();
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
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
    final remainSec = totalSec - _elapsedSeconds;
    final currentStep = m.steps[_currentStepIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: GestureDetector(
        onTap: _toggleUI,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/mountain_lake.jpeg',
                fit: BoxFit.cover,
              ).animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              ).scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.05, 1.05),
                duration: 15.seconds,
                curve: Curves.easeInOutSine,
              ),
            ),
            // Dark overlay
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0A0E1A).withValues(alpha: _isUIVisible ? 0.3 : 0.6),
                      const Color(0xFF0A0E1A).withValues(alpha: _isUIVisible ? 0.6 : 0.8),
                      const Color(0xFF0A0E1A).withValues(alpha: _isUIVisible ? 0.95 : 0.98),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top bar
                  AnimatedOpacity(
                    opacity: _isUIVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          _CircleIconButton(
                            icon: LucideIcons.x,
                            onTap: () {
                              if (!_isUIVisible) return;
                              _timer?.cancel();
                              context.pop();
                            },
                          ),
                          const Spacer(),
                          Text(
                            'Donate',
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          _CircleIconButton(
                            icon: LucideIcons.share,
                            onTap: () {
                               if (!_isUIVisible) return;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Pre-session view or Active Session Breathing Circle
                  if (!_isStarted) ...[
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
                    AnimatedOpacity(
                      opacity: _isUIVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: m.breathingPattern != null
                          ? BreathingCircle(
                              pattern: m.breathingPattern!,
                              isActive: !_isPaused && _isUIVisible,
                              color: m.accentColor,
                            ).animate().fadeIn(duration: 800.ms)
                          : const SizedBox.shrink(),
                    ),
                  ],

                  const Spacer(),

                  // Bottom Section
                  if (!_isStarted)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _StartButton(
                            color: m.accentColor,
                            onTap: _startSession,
                          ).animate().fadeIn(delay: 500.ms, duration: 500.ms)
                           .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 500.ms),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Large Timer (Always visible or visible based on user preference - here we keep it always visible as per "only timer" request)
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 500),
                            alignment: _isUIVisible ? Alignment.centerLeft : Alignment.center,
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 500),
                              scale: _isUIVisible ? 1.0 : 1.5,
                              child: Text(
                                _formatTime(_elapsedSeconds),
                                style: AppTypography.heading1.copyWith(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: -1,
                                  fontFeatures: [const FontFeature.tabularFigures()],
                                ),
                              ),
                            ),
                          ),
                          
                          // Hide everything else when UI is not visible
                          AnimatedOpacity(
                            opacity: _isUIVisible ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  m.title,
                                  style: AppTypography.heading2.copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xxs),
                                Text(
                                  m.category.label,
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: Colors.white54,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                
                                // Scrubber & Progress
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: AppRadius.circular,
                                        child: LinearProgressIndicator(
                                          value: progress.clamp(0.0, 1.0),
                                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                                          valueColor: AlwaysStoppedAnimation(
                                            Colors.white.withValues(alpha: 0.8),
                                          ),
                                          minHeight: 4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatTime(_elapsedSeconds),
                                      style: AppTypography.caption.copyWith(color: Colors.white54),
                                    ),
                                    Text(
                                      '-${_formatTime(remainSec)}',
                                      style: AppTypography.caption.copyWith(color: Colors.white54),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: AppSpacing.lg),
                                
                                // Player Controls
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: const Icon(LucideIcons.music),
                                      color: Colors.white54,
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(LucideIcons.rotateCcw),
                                      color: Colors.white70,
                                      iconSize: 28,
                                      onPressed: () {
                                        if (_isUIVisible) _seekTo(_elapsedSeconds - 15);
                                      },
                                    ),
                                    _CircleIconButton(
                                      icon: _isPaused ? LucideIcons.play : LucideIcons.pause,
                                      size: 72,
                                      iconSize: 32,
                                      onTap: () {
                                        if (_isUIVisible) _togglePause();
                                      },
                                      color: Colors.white,
                                    ),
                                    IconButton(
                                      icon: const Icon(LucideIcons.rotateCw),
                                      color: Colors.white70,
                                      iconSize: 28,
                                      onPressed: () {
                                        if (_isUIVisible) _seekTo(_elapsedSeconds + 15);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(LucideIcons.repeat),
                                      color: Colors.white54,
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: AppSpacing.xxl),
                                
                                // Current step instruction ("How are you feeling?" equivalent space)
                                Center(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    child: Text(
                                      currentStep.instruction,
                                      key: ValueKey(_currentStepIndex),
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: Colors.white.withValues(alpha: 0.7),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xl),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
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
    this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (color ?? Colors.white).withValues(alpha: 0.1),
          border: Border.all(
            color: (color ?? Colors.white).withValues(alpha: 0.15),
          ),
        ),
        child: Icon(icon, size: iconSize, color: color ?? Colors.white70),
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
