import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class StreakDisplaySection extends StatelessWidget {
  const StreakDisplaySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 380,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/stepping_stones_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      // Fade edges
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.background.withValues(alpha: 0.0),
            AppColors.background.withValues(alpha: 0.0),
            AppColors.background,
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Text(
            '127',
            style: AppTypography.display.copyWith(
              color: AppColors.primaryDark,
              fontSize: 96,
              height: 1.0,
            ),
          ),
          Text(
            'DAYS CLEAN',
            style: AppTypography.label.copyWith(
              color: AppColors.primaryDark,
              letterSpacing: 2.0,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeBlock('14', 'HRS'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(':', style: TextStyle(fontSize: 24, color: AppColors.textPrimary)),
              ),
              _buildTimeBlock('22', 'MINS'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(':', style: TextStyle(fontSize: 24, color: AppColors.textPrimary)),
              ),
              _buildTimeBlock('08', 'SECS'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.9),
              borderRadius: AppRadius.extraLarge,
            ),
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Record Relapse'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textBody,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.extraLarge,
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBlock(String value, String label) {
    return Column(
      children: [
        Text(value, style: AppTypography.heading2.copyWith(fontWeight: FontWeight.w400)),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: AppTypography.label.copyWith(fontSize: 10)),
      ],
    );
  }
}
