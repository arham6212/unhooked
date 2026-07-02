import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';

/// The connective tissue of the intro: a warm light low on the screen,
/// breathing at ~6 breaths/min (one 9s cycle) — slow enough to entrain
/// the viewer's own breath. [boost] (0..1) brightens it during the vow hold.
class EmberBackground extends StatefulWidget {
  final ValueListenable<double> boost;

  const EmberBackground({super.key, required this.boost});

  @override
  State<EmberBackground> createState() => _EmberBackgroundState();
}

class _EmberBackgroundState extends State<EmberBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breath;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _breath.stop();
      _breath.value = 0.25; // hold mid-breath
    } else if (!_breath.isAnimating) {
      _breath.repeat();
    }
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _EmberPainter(
          breath: _breath,
          boost: widget.boost,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _EmberPainter extends CustomPainter {
  final Animation<double> breath;
  final ValueListenable<double> boost;

  _EmberPainter({required this.breath, required this.boost})
      : super(repaint: Listenable.merge([breath, boost]));

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.introInk);

    // Sine breath: 0..1..0 over one cycle.
    final wave = 0.5 - 0.5 * math.cos(2 * math.pi * breath.value);
    final glow = (0.55 + 0.35 * wave) + boost.value * 0.6;
    final radius = size.width * (0.78 + 0.09 * wave + 0.15 * boost.value);
    final center = Offset(size.width / 2, size.height + radius * 0.45);

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.introEmber.withValues(alpha: 0.30 * glow),
          AppColors.introEmber.withValues(alpha: 0.08 * glow),
          AppColors.introEmber.withValues(alpha: 0),
        ],
        stops: const [0.0, 0.45, 0.72],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_EmberPainter oldDelegate) => false;
}
