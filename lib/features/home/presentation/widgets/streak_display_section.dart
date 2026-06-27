import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class StreakDisplaySection extends StatefulWidget {
  const StreakDisplaySection({super.key});

  @override
  State<StreakDisplaySection> createState() => _StreakDisplaySectionState();
}

class _StreakDisplaySectionState extends State<StreakDisplaySection> {
  late Timer _timer;
  int _totalSeconds = (14 * 3600) + (22 * 60) + 8;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _totalSeconds++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _showRelapseSheet() {
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Record a Relapse',
              style: AppTypography.heading2.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'This will reset your streak counter. Recovery is not linear — every restart is progress.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
                ),
                child: const Text('Reset Streak'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours = (_totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_totalSeconds % 60).toString().padLeft(2, '0');

    return GestureDetector(
      onLongPress: _showRelapseSheet,
      child: Container(
        width: double.infinity,
        height: 320,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mountain_lake.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
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
            const SizedBox(height: AppSpacing.xxl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMinimalTimeBlock(hours, 'h'),
                const SizedBox(width: AppSpacing.lg),
                _buildMinimalTimeBlock(minutes, 'm'),
                const SizedBox(width: AppSpacing.lg),
                _buildMinimalTimeBlock(seconds, 's'),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalTimeBlock(String value, String unit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: AppTypography.heading1.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 2),
        Text(
          unit,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
