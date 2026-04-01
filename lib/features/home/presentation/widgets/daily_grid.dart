import 'package:flutter/material.dart';
import 'home_widgets.dart';

class DailyGrid extends StatelessWidget {
  const DailyGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const int cols = 6;
    const int total = 30;
    final relapsedIndices = {total - 3, total - 1};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          '$total Days',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kOnPrimaryMuted,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 96,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: total,
            itemBuilder: (context, index) {
              final isRelapsed = relapsedIndices.contains(index);
              return Container(
                decoration: BoxDecoration(
                  color: isRelapsed ? kRelapsedDay : kCleanDay,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    if (!isRelapsed)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 2,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LegendDot(color: kCleanDay, label: 'Clean'),
            const SizedBox(width: 8),
            LegendDot(color: kRelapsedDay, label: 'Relapsed'),
          ],
        ),
      ],
    );
  }
}
