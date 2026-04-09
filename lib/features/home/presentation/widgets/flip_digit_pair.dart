import 'package:flutter/material.dart';
import 'home_widgets.dart';

const kClockPairWidth = 36.0;
const kClockDigitWidth = 18.0;
const kClockDigitHeight = 32.0;

class FlipDigitPair extends StatelessWidget {
  const FlipDigitPair({super.key, 
    required this.keyPrefix,
    required this.value,
    required this.textStyle,
  });

  final String keyPrefix;
  final int value;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final tens = value ~/ 10;
    final ones = value % 10;
    return SizedBox(
      width: kClockPairWidth,
      height: kClockDigitHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: kClockDigitWidth,
            height: kClockDigitHeight,
            child: Center(
              child: KeyedSubtree(
                key: ValueKey('${keyPrefix}_tens'),
                child: FlipOnlyOnChange(
                  value: tens,
                  textStyle: textStyle,
                  duration: const Duration(milliseconds: 220),
                ),
              ),
            ),
          ),
          SizedBox(
            width: kClockDigitWidth,
            height: kClockDigitHeight,
            child: Center(
              child: KeyedSubtree(
                key: ValueKey('${keyPrefix}_ones'),
                child: FlipOnlyOnChange(
                  value: ones,
                  textStyle: textStyle,
                  duration: const Duration(milliseconds: 220),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
