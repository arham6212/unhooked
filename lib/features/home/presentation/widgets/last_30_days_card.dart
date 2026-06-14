import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class Last30DaysCard extends StatelessWidget {
  const Last30DaysCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'LAST 30 DAYS',
            style: AppTypography.label.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Determine item size based on constraints
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 35, // 7x5
                  itemBuilder: (context, index) {
                    bool isRed = (index == 11 || index == 13 || index == 20);
                    bool isEmpty = index > 29;
                    if (isEmpty) return const SizedBox();
                    
                    return Container(
                      decoration: BoxDecoration(
                        color: isRed ? AppColors.error : AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
