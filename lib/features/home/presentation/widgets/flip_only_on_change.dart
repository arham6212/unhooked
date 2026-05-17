import 'dart:math' show pi;

import 'package:flutter/material.dart';

/// Slot-machine flip when [value] changes.
///
/// Phase 1 (t 0→0.5): current digit rotates upward   (rotateX  0 → -π/2)
/// Phase 2 (t 0.5→1): next digit unrolls from below  (rotateX π/2 →  0)
///
/// At t = 0.5 both positions are exactly ±π/2, so the digit is edge-on
/// (invisible) — the swap is imperceptible.
class FlipOnlyOnChange extends StatefulWidget {
  const FlipOnlyOnChange({
    super.key,
    required this.value,
    required this.textStyle,
    this.duration = const Duration(milliseconds: 260),
  });

  final int value;
  final TextStyle? textStyle;
  final Duration duration;

  @override
  State<FlipOnlyOnChange> createState() => _FlipOnlyOnChangeState();
}

class _FlipOnlyOnChangeState extends State<FlipOnlyOnChange>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  int _visible = 0; // digit currently on screen
  int _pending = 0; // digit we are flipping to

  @override
  void initState() {
    super.initState();
    _visible = widget.value;
    _pending = widget.value;
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _ctrl.addStatusListener(_onStatus);
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // Commit the new digit and reset so the next change can start fresh.
      if (mounted) setState(() => _visible = _pending);
      _ctrl.reset();
    }
  }

  @override
  void didUpdateWidget(FlipOnlyOnChange old) {
    super.didUpdateWidget(old);
    if (old.value == widget.value) return;

    _pending = widget.value;
    if (_ctrl.status != AnimationStatus.forward) {
      _ctrl.forward(from: 0.0);
    }
    // If already animating, _pending is updated and the current run will
    // land on the latest value at completion.
  }

  @override
  void dispose() {
    _ctrl.removeStatusListener(_onStatus);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;
        final isFirstHalf = t < 0.5;

        // Apply independent easing to each half so the motion feels snappy.
        final double angle;
        if (isFirstHalf) {
          // 0 → -π/2  (fold upward, easeIn so it accelerates into the fold)
          angle = Curves.easeIn.transform(t * 2) * (-pi / 2);
        } else {
          // π/2 → 0  (unfold downward, easeOut so it decelerates landing)
          angle = (1.0 - Curves.easeOut.transform((t - 0.5) * 2)) * (pi / 2);
        }

        final label = isFirstHalf ? _visible : _pending;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003) // mild perspective
            ..rotateX(angle),
          child: Text('$label', style: widget.textStyle),
        );
      },
    );
  }
}
