import 'package:flutter/material.dart';
import 'home_widgets.dart';

class RecoveryTimerSection extends StatelessWidget {
  const RecoveryTimerSection({super.key, 
    required this.elapsed,
    required this.onReset,
    this.onTimerTap,
  });

  final Duration elapsed;
  final VoidCallback onReset;
  final VoidCallback? onTimerTap;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(kCardRadiusSmall),
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTimerTap,
                borderRadius: BorderRadius.circular(kCardRadiusSmall),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recovery Timer',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kOnPrimaryMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RecoveryTimerDisplay(elapsed: elapsed),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: Colors.white.withValues(alpha: 0.2),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onReset,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.refresh_rounded,
                  color: kOnPrimary,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
