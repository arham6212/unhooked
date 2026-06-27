import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../providers/meditation_provider.dart';

class MeditationStatsHeader extends ConsumerWidget {
  const MeditationStatsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(meditationStatsProvider);

    return Row(
      children: [
        _StatPill(
          icon: LucideIcons.brain,
          value: '${stats.totalSessions}',
          label: 'Sessions',
          color: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.sm),
        _StatPill(
          icon: LucideIcons.clock,
          value: '${stats.totalMinutes}',
          label: 'Minutes',
          color: AppColors.teal,
        ),
        const SizedBox(width: AppSpacing.sm),
        _StatPill(
          icon: LucideIcons.flame,
          value: '${stats.currentStreak}',
          label: 'Day Streak',
          color: AppColors.warning,
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: AppRadius.medium,
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: AppTypography.heading3.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
