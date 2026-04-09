import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
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
        Text(
          '$total Days',
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onPrimary.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: 96,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: AppSpacing.xs,
              crossAxisSpacing: AppSpacing.xs,
              childAspectRatio: 1,
            ),
            itemCount: total,
            itemBuilder: (context, index) {
              final isRelapsed = relapsedIndices.contains(index);
              return Container(
                decoration: BoxDecoration(
                  color: isRelapsed ? AppColors.error : AppColors.onPrimary,
                  borderRadius: AppRadius.small,
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
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LegendDot(color: AppColors.onPrimary, label: 'Clean'),
            const SizedBox(width: AppSpacing.sm),
            const LegendDot(color: AppColors.error, label: 'Relapsed'),
          ],
        ),
      ],
    );
  }
}
