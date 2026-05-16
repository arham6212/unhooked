import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';

// ── Data ──────────────────────────────────────────────────────
class _RelapseEvent {
  final DateTime date;
  final String note;
  const _RelapseEvent(this.date, this.note);
}

final _relapseEvents = [
  _RelapseEvent(
    DateTime.now().subtract(const Duration(days: 15)),
    'Stressful day at work. Fell back after 6 days clean.',
  ),
  _RelapseEvent(
    DateTime.now().subtract(const Duration(days: 44)),
    'Social pressure at a gathering. Lost 9-day streak.',
  ),
];

// ── Screen ────────────────────────────────────────────────────
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const int _totalDays = 27; // days tracked
  static const int _currentStreak = 12;
  static const int _bestStreak = 15;
  static const int _totalClean = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _Header(),
            ),
            SliverToBoxAdapter(
              child: _StatsRow(),
            ),
            SliverToBoxAdapter(
              child: _CalendarSection(),
            ),
            SliverToBoxAdapter(
              child: _RelapseLog(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History',
            style: AppTypography.heading1.copyWith(height: 1.1, letterSpacing: -0.5),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Track your progress over time',
            style: AppTypography.caption.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
      child: Row(
        children: [
          _StatCard(
            label: 'Current',
            value: '${HistoryScreen._currentStreak}',
            unit: 'days',
            color: AppColors.primary,
            icon: LucideIcons.flame,
            index: 0,
          ),
          const SizedBox(width: AppSpacing.sm),
          _StatCard(
            label: 'Best',
            value: '${HistoryScreen._bestStreak}',
            unit: 'days',
            color: AppColors.success,
            icon: LucideIcons.trophy,
            index: 1,
          ),
          const SizedBox(width: AppSpacing.sm),
          _StatCard(
            label: 'Clean',
            value: '${HistoryScreen._totalClean}',
            unit: 'total',
            color: AppColors.info,
            icon: LucideIcons.checkCircle,
            index: 2,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
    required this.index,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.large,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: AppRadius.small,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: AppTypography.heading2.copyWith(
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              unit,
              style: AppTypography.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      )
          .animate(delay: (80 * index).ms)
          .fadeIn(duration: 350.ms)
          .slideY(begin: 0.04, end: 0, duration: 350.ms, curve: Curves.easeOutCubic),
    );
  }
}

// ── Calendar Section ──────────────────────────────────────────
class _CalendarSection extends StatelessWidget {
  // Days since start; index 0 = oldest, last = today
  static final Set<int> _relapsedDays = {11, 27}; // 0-indexed from start

  @override
  Widget build(BuildContext context) {
    const total = HistoryScreen._totalDays;
    const cols = 7;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.extraLarge,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Last $total days',
                  style: AppTypography.heading3.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                _Legend(color: AppColors.primary, label: 'Clean'),
                const SizedBox(width: AppSpacing.md),
                _Legend(color: AppColors.error, label: 'Relapse'),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1,
              ),
              itemCount: total,
              itemBuilder: (context, i) {
                final isToday = i == total - 1;
                final isRelapsed = _relapsedDays.contains(i);

                Color cellColor;
                Color borderColor;

                if (isRelapsed) {
                  cellColor = AppColors.error.withValues(alpha: 0.15);
                  borderColor = AppColors.error.withValues(alpha: 0.4);
                } else {
                  cellColor = AppColors.primary.withValues(alpha: 0.12);
                  borderColor = AppColors.primary.withValues(alpha: 0.25);
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: cellColor,
                    borderRadius: BorderRadius.circular(5),
                    border: isToday
                        ? Border.all(color: AppColors.primary, width: 2)
                        : Border.all(color: borderColor, width: 1),
                  ),
                  child: isRelapsed
                      ? Center(
                          child: Icon(
                            LucideIcons.x,
                            size: 10,
                            color: AppColors.error,
                          ),
                        )
                      : isToday
                          ? Center(
                              child: Icon(
                                LucideIcons.circle,
                                size: 6,
                                color: AppColors.primary,
                              ),
                            )
                          : null,
                );
              },
            ),
          ],
        ),
      )
          .animate(delay: 100.ms)
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.04, end: 0, duration: 400.ms),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: color.withValues(alpha: 0.5)),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// ── Relapse Log ───────────────────────────────────────────────
class _RelapseLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.md),
            child: Text(
              'Relapse log',
              style: AppTypography.heading3.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          if (_relapseEvents.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.extraLarge,
              ),
              child: Center(
                child: Text(
                  'No relapses recorded',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                ),
              ),
            )
          else
            ..._relapseEvents.asMap().entries.map(
              (e) => _RelapseCard(event: e.value, index: e.key),
            ),
        ],
      ),
    );
  }
}

class _RelapseCard extends StatelessWidget {
  const _RelapseCard({required this.event, required this.index});
  final _RelapseEvent event;
  final int index;

  String _formatDate(DateTime d) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: AppRadius.small,
            ),
            child: const Icon(LucideIcons.alertCircle, size: 16, color: AppColors.error),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(event.date),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  event.note,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textBody,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: (120 + 60 * index).ms)
        .fadeIn(duration: 350.ms)
        .slideX(begin: 0.04, end: 0, duration: 350.ms, curve: Curves.easeOutCubic);
  }
}
