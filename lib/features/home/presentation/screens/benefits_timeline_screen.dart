import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

class RecoveryBenefit {
  const RecoveryBenefit({
    required this.days,
    required this.timeLabel,
    required this.title,
    required this.description,
    this.icon = LucideIcons.partyPopper,
    this.color = AppColors.primary,
  });

  final int days;
  final String timeLabel;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

const List<RecoveryBenefit> _kBenefits = [
  RecoveryBenefit(
    days: 0,
    timeLabel: 'Day 0',
    title: 'You started',
    description: 'The moment you chose recovery. Every benefit from here builds on this.',
    icon: LucideIcons.flag,
    color: Color(0xFF2563FF),
  ),
  RecoveryBenefit(
    days: 1,
    timeLabel: '24 Hours',
    title: 'First day clear',
    description: 'Your body begins to clear the substance. Hydration and rest help.',
    icon: LucideIcons.sun,
    color: AppColors.warning,
  ),
  RecoveryBenefit(
    days: 3,
    timeLabel: '72 Hours',
    title: 'Detox in motion',
    description: 'Acute withdrawal often peaks and starts to ease. Sleep may still be rough.',
    icon: LucideIcons.shieldCheck,
    color: Color(0xFF10B981),
  ),
  RecoveryBenefit(
    days: 7,
    timeLabel: '1 Week',
    title: 'Sleep & mood shift',
    description: 'Many notice better sleep and more stable mood. Cravings can still spike.',
    icon: LucideIcons.moon,
    color: Color(0xFF8B5CF6),
  ),
  RecoveryBenefit(
    days: 14,
    timeLabel: '2 Weeks',
    title: 'Energy & focus',
    description: 'Mental clarity and energy improve. Routine starts to feel possible.',
    icon: LucideIcons.brain,
    color: Color(0xFF06B6D4),
  ),
  RecoveryBenefit(
    days: 30,
    timeLabel: '1 Month',
    title: 'Stronger foundation',
    description: 'Physical and mental gains become clearer. New habits take root.',
    icon: LucideIcons.leaf,
    color: Color(0xFF10B981),
  ),
  RecoveryBenefit(
    days: 90,
    timeLabel: '90 Days',
    title: 'Brain rewiring',
    description: 'Neural pathways shift. Cravings reduce; sober identity feels natural.',
    icon: LucideIcons.brainCircuit,
    color: Color(0xFF2563FF),
  ),
  RecoveryBenefit(
    days: 180,
    timeLabel: '6 Months',
    title: 'New identity',
    description: 'You\'re not "quitting" — you\'re someone who lives without it.',
    icon: LucideIcons.user,
    color: Color(0xFFEC4899),
  ),
  RecoveryBenefit(
    days: 365,
    timeLabel: '1 Year',
    title: 'Major milestone',
    description: 'A full year of choices. Celebrate and keep building.',
    icon: LucideIcons.partyPopper,
    color: AppColors.warning,
  ),
  RecoveryBenefit(
    days: 730,
    timeLabel: '2 Years',
    title: 'Deep stability',
    description: 'Recovery is part of who you are. Keep your practices and community.',
    icon: LucideIcons.anchor,
    color: Color(0xFF2563FF),
  ),
];

class BenefitsTimelineScreen extends StatelessWidget {
  const BenefitsTimelineScreen({super.key, required this.currentDays});

  final int currentDays;

  @override
  Widget build(BuildContext context) {
    final achievedCount =
        _kBenefits.where((b) => currentDays >= b.days).length;
    final progress = achievedCount / _kBenefits.length;

    // Index of the next upcoming milestone
    final nextIndex = _kBenefits.indexWhere((b) => currentDays < b.days);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Hero header ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: _HeroHeader(
              currentDays: currentDays,
              achievedCount: achievedCount,
              total: _kBenefits.length,
              progress: progress,
              onBack: () => Navigator.of(context).pop(),
            ),
          ),

          // ── Timeline ─────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              MediaQuery.paddingOf(context).bottom + AppSpacing.xxl,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final benefit = _kBenefits[index];
                  final achieved = currentDays >= benefit.days;
                  final isCurrent = index == nextIndex - 1 ||
                      (nextIndex == -1 && index == _kBenefits.length - 1);
                  final isNext = index == nextIndex;
                  final isLast = index == _kBenefits.length - 1;

                  return _TimelineRow(
                    benefit: benefit,
                    achieved: achieved,
                    isCurrent: isCurrent,
                    isNext: isNext,
                    isFirst: index == 0,
                    isLast: isLast,
                    index: index,
                    currentDays: currentDays,
                  );
                },
                childCount: _kBenefits.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero Header ────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.currentDays,
    required this.achievedCount,
    required this.total,
    required this.progress,
    required this.onBack,
  });

  final int currentDays;
  final int achievedCount;
  final int total;
  final double progress;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            AppSpacing.lg, topPad + AppSpacing.sm, AppSpacing.xl, AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withValues(alpha: 0.18),
                  borderRadius: AppRadius.medium,
                ),
                child: const Icon(
                  LucideIcons.arrowLeft,
                  color: AppColors.onPrimary,
                  size: 18,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(
              'Recovery Journey',
              style: AppTypography.heading2.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'What your body and mind gain over time.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onPrimary.withValues(alpha: 0.75),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Stats row
            Row(
              children: [
                _StatChip(
                  value: '$currentDays',
                  label: 'Days sober',
                  icon: LucideIcons.flame,
                ),
                const SizedBox(width: AppSpacing.md),
                _StatChip(
                  value: '$achievedCount / $total',
                  label: 'Milestones',
                  icon: LucideIcons.trophy,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$achievedCount milestones reached',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.80),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: AppRadius.circular,
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.onPrimary.withValues(alpha: 0.20),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.16),
        borderRadius: AppRadius.large,
        border: Border.all(
          color: AppColors.onPrimary.withValues(alpha: 0.20),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.onPrimary),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.caption.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.70),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Timeline Row ───────────────────────────────────────────────
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.benefit,
    required this.achieved,
    required this.isCurrent,
    required this.isNext,
    required this.isFirst,
    required this.isLast,
    required this.index,
    required this.currentDays,
  });

  final RecoveryBenefit benefit;
  final bool achieved;
  final bool isCurrent;
  final bool isNext;
  final bool isFirst;
  final bool isLast;
  final int index;
  final int currentDays;

  @override
  Widget build(BuildContext context) {
    final nodeColor = achieved
        ? AppColors.success
        : isNext
            ? AppColors.primary
            : AppColors.border;

    final lineColor = achieved ? AppColors.success : AppColors.border;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Track column ──────────────────────────────────────
        SizedBox(
          width: 40,
          child: Column(
            children: [
              // Top connector line
              if (!isFirst)
                Container(
                  width: 2,
                  height: 16,
                  color: lineColor,
                ),

              // Node circle
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: achieved
                      ? AppColors.success
                      : isNext
                          ? AppColors.primaryXLight
                          : AppColors.surface,
                  border: Border.all(
                    color: nodeColor,
                    width: achieved ? 0 : 2,
                  ),
                  boxShadow: [
                    if (achieved)
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.30),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 3),
                      ),
                    if (isNext)
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.20),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 3),
                      ),
                  ],
                ),
                child: Icon(
                  achieved ? LucideIcons.check : benefit.icon,
                  size: 16,
                  color: achieved
                      ? Colors.white
                      : isNext
                          ? AppColors.primary
                          : AppColors.textMuted,
                ),
              ),

              // Bottom connector line
              if (!isLast)
                Container(
                  width: 2,
                  height: 24,
                  color: lineColor,
                ),
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.md),

        // ── Card ──────────────────────────────────────────────
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: isLast ? 0 : AppSpacing.md,
              top: isFirst ? 0 : 8,
            ),
            child: _MilestoneCard(
              benefit: benefit,
              achieved: achieved,
              isCurrent: isCurrent,
              isNext: isNext,
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 380.ms, delay: (60 * index).ms, curve: Curves.easeOut)
        .slideX(
          begin: 0.04,
          end: 0,
          duration: 380.ms,
          delay: (60 * index).ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({
    required this.benefit,
    required this.achieved,
    required this.isCurrent,
    required this.isNext,
  });

  final RecoveryBenefit benefit;
  final bool achieved;
  final bool isCurrent;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final cardColor = achieved
        ? AppColors.surface
        : isNext
            ? AppColors.surface
            : AppColors.surface;

    final borderColor = isCurrent
        ? AppColors.primary.withValues(alpha: 0.40)
        : achieved
            ? AppColors.success.withValues(alpha: 0.20)
            : AppColors.border;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: AppRadius.large,
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          if (isCurrent || achieved)
            BoxShadow(
              color: (isCurrent ? AppColors.primary : AppColors.success)
                  .withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: time chip + icon + optional badge
            Row(
              children: [
                // Time chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: achieved
                        ? AppColors.success.withValues(alpha: 0.10)
                        : isNext
                            ? AppColors.primaryXLight
                            : AppColors.backgroundLight,
                    borderRadius: AppRadius.circular,
                  ),
                  child: Text(
                    benefit.timeLabel,
                    style: AppTypography.caption.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: achieved
                          ? AppColors.success
                          : isNext
                              ? AppColors.primary
                              : AppColors.textMuted,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                const Spacer(),

                // "Up next" or "Achieved" badge
                if (isNext)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.circular,
                    ),
                    child: Text(
                      'Up next',
                      style: AppTypography.caption.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),

                if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      borderRadius: AppRadius.circular,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.check, size: 10, color: AppColors.success),
                        const SizedBox(width: 3),
                        Text(
                          'Current',
                          style: AppTypography.caption.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Benefit icon in colored bg (top right)
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: benefit.color.withValues(
                      alpha: achieved ? 0.12 : 0.07,
                    ),
                    borderRadius: AppRadius.medium,
                  ),
                  child: Icon(
                    benefit.icon,
                    size: 15,
                    color: achieved
                        ? benefit.color
                        : benefit.color.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Title
            Text(
              benefit.title,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: achieved || isNext
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
                letterSpacing: -0.2,
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            // Description
            Text(
              benefit.description,
              style: AppTypography.caption.copyWith(
                color: achieved || isNext
                    ? AppColors.textBody
                    : AppColors.textMuted,
                height: 1.5,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
