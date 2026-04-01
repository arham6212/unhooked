import 'package:flutter/material.dart';
import 'home_widgets.dart';

class RecoveryTimerDisplay extends StatelessWidget {
  const RecoveryTimerDisplay({super.key, required this.elapsed});

  final Duration elapsed;

  static const _tabularFigures = [FontFeature.tabularFigures()];

  @override
  Widget build(BuildContext context) {
    final d = elapsed.inDays;
    final h = elapsed.inHours % 24;
    final m = elapsed.inMinutes % 60;
    final s = elapsed.inSeconds % 60;
    final style = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: kOnPrimary,
      height: 1.0,
      fontFeatures: _tabularFigures,
    );
    final labelStyle = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: kOnPrimaryMuted,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        const Icon(
          Icons.schedule_rounded,
          color: kOnPrimaryMuted,
          size: 20,
        ),SizedBox(width: 10),
        SizedBox(
          child: Align(
            alignment: Alignment.centerLeft,
            child: FlipOnlyOnChange(
              value: d,
              textStyle: style,
              duration: const Duration(milliseconds: 320),
            ),
          ),
        ),
        Text('d', style: labelStyle),
        Text(':', style: labelStyle),
        FlipDigitPair(keyPrefix: 'th', value: h, textStyle: style),
        Text(':', style: labelStyle),
        FlipDigitPair(keyPrefix: 'tm', value: m, textStyle: style),
        Text(':', style: labelStyle),
        FlipDigitPair(keyPrefix: 'ts', value: s, textStyle: style),
      ],
    );
  }
}
