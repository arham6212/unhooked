import 'package:flutter/material.dart';

class FlipOnlyOnChange extends StatelessWidget {
  const FlipOnlyOnChange({super.key, 
    required this.value,
    required this.textStyle,
    this.duration = const Duration(milliseconds: 700),
  });

  final int value;
  final TextStyle? textStyle;
  final Duration duration;

  static const double _pi2 = 1.5707963267948966;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? _) {
            final angle = (1.0 - animation.value) * _pi2;
            return Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(angle),
              child: child,
            );
          },
          child: child,
        );
      },
      child: Text(
        '$value',
        key: ValueKey<int>(value),
        style: textStyle,
      ),
    );
  }
}
