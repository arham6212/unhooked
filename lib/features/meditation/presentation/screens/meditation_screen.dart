import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../domain/entities/meditation.dart';
import '../providers/meditation_provider.dart';
import '../widgets/meditation_card.dart';
import '../widgets/meditation_stats_header.dart';

class MeditationScreen extends ConsumerWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filtered = ref.watch(filteredMeditationsProvider);
    final quickStart = ref.watch(quickStartMeditationsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meditate',
                    style: AppTypography.heading1.copyWith(
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Train your mind, master your urges',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      child: const MeditationStatsHeader(),
                    ).animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: AppSpacing.xxl),

                    // Quick Start
                    _sectionLabel('QUICK START'),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 156,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        itemCount: quickStart.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                        itemBuilder: (context, index) {
                          return QuickStartCard(
                            meditation: quickStart[index],
                            onTap: () => context.push(
                              '/meditate/session/${quickStart[index].id}',
                            ),
                          );
                        },
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 100.ms)
                        .slideX(begin: 0.03, end: 0, duration: 400.ms, delay: 100.ms),

                    const SizedBox(height: AppSpacing.xxl),

                    // Category Chips
                    _sectionLabel('GUIDED SESSIONS'),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        itemCount: MeditationCategory.values.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final cat = MeditationCategory.values[index];
                          final isActive = cat == selectedCategory;
                          return _CategoryChip(
                            label: cat.label,
                            isActive: isActive,
                            onTap: () => ref.read(selectedCategoryProvider.notifier).select(cat),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Meditation List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final m = filtered[index];
                        return MeditationCard(
                          meditation: m,
                          onTap: () => context.push('/meditate/session/${m.id}'),
                        ).animate(delay: (50 * index).ms)
                            .fadeIn(duration: 350.ms)
                            .slideY(begin: 0.03, end: 0, duration: 350.ms);
                      },
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Text(
        text,
        style: AppTypography.label.copyWith(
          color: AppColors.textSubtle,
          letterSpacing: 1.5,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.textPrimary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isActive
                ? Colors.transparent
                : AppColors.textMuted.withValues(alpha: 0.2),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.surface : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
