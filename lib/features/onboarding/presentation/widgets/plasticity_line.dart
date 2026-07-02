import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';

/// Neuroplasticity in one animation: a jittery, scattered line of light
/// organizes itself into a calm sine pulse over ~4 seconds. No brain
/// diagrams, no statistics — the reader watches chaos become calm.
class PlasticityLine extends StatefulWidget {
  const PlasticityLine({super.key});

  @override
  State<PlasticityLine> createState() => _PlasticityLineState();
}

class _PlasticityLineState extends State<PlasticityLine>
    with TickerProviderStateMixin {
  late final AnimationController _organize;
  late final AnimationController _phase;

  @override
  void initState() {
    super.initState();
    _organize = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    _phase = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _organize.value = 1;
      _phase.stop();
    } else {
      _organize.forward();
      _phase.repeat();
    }
  }

  @override
  void dispose() {
    _organize.dispose();
    _phase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _PlasticityPainter(organize: _organize, phase: _phase),
        size: const Size(double.infinity, 96),
      ),
    );
  }
}

class _PlasticityPainter extends CustomPainter {
  final Animation<double> organize;
  final Animation<double> phase;

  _PlasticityPainter({required this.organize, required this.phase})
      : super(repaint: Listenable.merge([organize, phase]));

  @override
  void paint(Canvas canvas, Size size) {
    final mid = size.height / 2;
    final k = Curves.easeInOutCubic.transform(organize.value);
    final drift = phase.value * 2 * math.pi;

    final path = Path()..moveTo(0, mid + _yAt(0, size.width, mid, k, drift) - mid);
    for (double x = 0; x <= size.width; x += 3) {
      path.lineTo(x, _yAt(x, size.width, mid, k, drift));
    }

    // Soft halo pass under the crisp line.
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round
        ..color = AppColors.introEmber.withValues(alpha: 0.14),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = AppColors.introEmber.withValues(alpha: 0.85),
    );
  }

  double _yAt(double x, double width, double mid, double k, double drift) {
    // Deterministic jitter from stacked incommensurate sines.
    final chaos = math.sin(x * 0.19 + 7.3) * math.sin(x * 0.041 + 1.7) * 22 +
        math.sin(x * 0.53 + 2.9) * 6;
    final calm = math.sin(x / width * 4 * math.pi - drift) * 10;
    return mid + chaos * (1 - k) + calm * k;
  }

  @override
  bool shouldRepaint(_PlasticityPainter oldDelegate) => false;
}
