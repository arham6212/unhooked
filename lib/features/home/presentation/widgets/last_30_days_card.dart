import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/components/app_card.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Last30DaysCard extends StatelessWidget {
  const Last30DaysCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => HapticFeedback.lightImpact(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.calendar, size: 16, color: AppColors.textMuted),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'LAST 30 DAYS',
                style: AppTypography.label.copyWith(color: AppColors.textMuted, letterSpacing: 1.2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: 35, // 7x5
            itemBuilder: (context, index) {
              bool isRed = (index == 11 || index == 13 || index == 20);
              bool isEmpty = index > 29;
              
              if (isEmpty) {
                 return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSunken,
                      borderRadius: AppRadius.xSmall,
                    ),
                 );
              }
              
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 20)),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isRed ? AppColors.error : AppColors.primary,
                    borderRadius: AppRadius.xSmall,
                    boxShadow: [
                       BoxShadow(
                          color: (isRed ? AppColors.error : AppColors.primary).withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                       ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
