import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';

/// The vow ritual: press and hold for 3 seconds while the ring fills
/// and haptic heartbeats accelerate. Releasing early lets the ring
/// decay silently — no error, it just waits. With assistive navigation
/// active, a single tap commits instead.
class HoldToCommit extends StatefulWidget {
  final VoidCallback onCommitted;
  final ValueChanged<double>? onProgress;

  const HoldToCommit({super.key, required this.onCommitted, this.onProgress});

  @override
  State<HoldToCommit> createState() => _HoldToCommitState();
}

class _HoldToCommitState extends State<HoldToCommit>
    with SingleTickerProviderStateMixin {
  // Accelerating heartbeat: gaps shrink from ~25% to ~8% of the hold.
  static const _ticks = [0.08, 0.26, 0.44, 0.6, 0.73, 0.84, 0.93];

  late final AnimationController _hold;
  int _lastTick = -1;
  bool _committed = false;

  @override
  void initState() {
    super.initState();
    _hold = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
      reverseDuration: const Duration(milliseconds: 500),
    );
    _hold.addListener(_handleProgress);
    _hold.addStatusListener(_handleStatus);
  }

  void _handleProgress() {
    widget.onProgress?.call(_hold.value);
    while (_lastTick + 1 < _ticks.length && _hold.value >= _ticks[_lastTick + 1]) {
      _lastTick++;
      HapticFeedback.lightImpact();
    }
    if (_hold.value == 0) _lastTick = -1;
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_committed) {
      _commit();
    }
  }

  void _commit() {
    setState(() => _committed = true);
    HapticFeedback.heavyImpact();
    widget.onProgress?.call(1);
    widget.onCommitted();
  }

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assistive = MediaQuery.of(context).accessibleNavigation;

    return Semantics(
      button: true,
      label: 'Commit to your vow',
      hint: assistive ? 'Double tap to commit' : 'Press and hold for three seconds',
      child: GestureDetector(
        onTap: assistive && !_committed ? _commit : null,
        onTapDown: assistive || _committed ? null : (_) => _hold.forward(),
        onTapUp: assistive || _committed ? null : (_) => _hold.reverse(),
        onTapCancel: assistive || _committed ? null : () => _hold.reverse(),
        child: SizedBox(
          width: 104,
          height: 104,
          child: AnimatedBuilder(
            animation: _hold,
            builder: (context, _) {
              return CustomPaint(
                painter: _RingPainter(
                  progress: _committed ? 1 : _hold.value,
                ),
                child: Icon(
                  LucideIcons.fingerprint,
                  size: 30,
                  color: _committed
                      ? AppColors.introEmber
                      : AppColors.introText.withValues(alpha: 0.6),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 3;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.introText.withValues(alpha: 0.16),
    );

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..color = AppColors.introEmber,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) => oldDelegate.progress != progress;
}
