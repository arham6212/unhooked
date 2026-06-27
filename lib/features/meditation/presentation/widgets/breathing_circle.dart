import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/meditation.dart';

enum BreathingPhase { inhale, holdIn, exhale, holdOut }

class BreathingCircle extends StatefulWidget {
  const BreathingCircle({
    super.key,
    required this.pattern,
    required this.isActive,
    required this.color,
  });

  final BreathingPattern pattern;
  final bool isActive;
  final Color color;

  @override
  State<BreathingCircle> createState() => _BreathingCircleState();
}

class _BreathingCircleState extends State<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  BreathingPhase _phase = BreathingPhase.inhale;
  String _phaseLabel = 'Breathe In';
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (widget.pattern.cycleDuration * 1000).toInt(),
      ),
    );

    _controller.addListener(_updatePhase);

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(BreathingCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
    }
  }

  void _updatePhase() {
    final total = widget.pattern.cycleDuration;
    final t = _controller.value * total;

    final inhaleEnd = widget.pattern.inhaleSeconds;
    final holdEnd = inhaleEnd + widget.pattern.holdSeconds;
    final exhaleEnd = holdEnd + widget.pattern.exhaleSeconds;

    BreathingPhase newPhase;
    String newLabel;
    double newProgress;

    if (t < inhaleEnd) {
      newPhase = BreathingPhase.inhale;
      newLabel = 'Breathe In';
      newProgress = t / inhaleEnd;
    } else if (t < holdEnd) {
      newPhase = BreathingPhase.holdIn;
      newLabel = 'Hold';
      newProgress = 1.0;
    } else if (t < exhaleEnd) {
      newPhase = BreathingPhase.exhale;
      newLabel = 'Breathe Out';
      newProgress = 1.0 - ((t - holdEnd) / widget.pattern.exhaleSeconds);
    } else {
      newPhase = BreathingPhase.holdOut;
      newLabel = 'Hold';
      newProgress = 0.0;
    }

    if (newPhase != _phase) {
      HapticFeedback.selectionClick();
    }

    setState(() {
      _phase = newPhase;
      _phaseLabel = newLabel;
      _progress = newProgress;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updatePhase);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minSize = 100.0;
    final maxSize = 180.0;
    final currentSize = minSize + (maxSize - minSize) * _progress;

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          CustomPaint(
            size: const Size(200, 200),
            painter: _RingPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          ),
          // Breathing circle
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: currentSize,
            height: currentSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.color.withValues(alpha: 0.3),
                  widget.color.withValues(alpha: 0.1),
                ],
              ),
              border: Border.all(
                color: widget.color.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.2 + (0.2 * _progress)),
                  blurRadius: 30 + (20 * _progress),
                  spreadRadius: 5 + (10 * _progress),
                ),
              ],
            ),
            child: Center(
              child: AnimatedScale(
                scale: 1.0 + (0.15 * _progress),
                duration: const Duration(milliseconds: 100),
                child: Text(
                  _phaseLabel,
                  style: AppTypography.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Track
    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
