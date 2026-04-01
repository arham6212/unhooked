import 'package:flutter/material.dart';
import 'home_constants.dart';
import 'home_widgets.dart';

class CurrentBenefitsRow extends StatelessWidget {
  const CurrentBenefitsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Icon(
              Icons.self_improvement_rounded,
              color: kOnPrimaryMuted,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Current Benefits',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: kOnPrimary,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kBenefitsGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '21',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: kOnPrimaryMuted,
            ),
          ],
        ),
      ),
    );
  }
}
