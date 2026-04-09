import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.15),
        borderRadius: AppRadius.large,
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTimerTap,
                borderRadius: AppRadius.large,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recovery Timer',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      RecoveryTimerDisplay(elapsed: elapsed),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: AppColors.onPrimary.withValues(alpha: 0.2),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onReset,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Icon(
                  Icons.refresh_rounded,
                  color: AppColors.onPrimary,
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
