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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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

              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: const MeditationStatsHeader(),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: AppSpacing.xl),

              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: isDark ? Colors.white : Colors.black,
                  labelStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  unselectedLabelColor: AppColors.textMuted,
                  tabs: const [
                    Tab(text: 'Guided'),
                    Tab(text: 'Exercises'),
                    Tab(text: 'Music'),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Tab Content
              Expanded(
                child: TabBarView(
                  children: [
                    _buildGuidedTab(context, ref),
                    _buildExercisesTab(context, ref),
                    _buildMusicTab(context, ref),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidedTab(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filtered = ref.watch(filteredMeditationsProvider);
    final quickStart = ref.watch(quickStartMeditationsProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          // Quick Start
          _sectionLabel('QUICK START'),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 156,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              itemCount: quickStart.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                return QuickStartCard(
                  meditation: quickStart[index],
                  onTap: () => context.push('/meditate/session/${quickStart[index].id}'),
                );
              },
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms)
              .slideX(begin: 0.03, end: 0, duration: 400.ms, delay: 100.ms),

          const SizedBox(height: AppSpacing.xxl),

          // Category Chips
          _sectionLabel('TOPICS'),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              itemCount: MeditationCategory.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
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
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
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
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildExercisesTab(BuildContext context, WidgetRef ref) {
    final exercisesList = ref.watch(meditationsProvider)
        .where((m) => m.type == MeditationType.exercise)
        .toList();

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: AppSpacing.xl, right: AppSpacing.xl, top: AppSpacing.md, bottom: AppSpacing.lg),
      itemCount: exercisesList.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final m = exercisesList[index];
        return MeditationCard(
          meditation: m,
          onTap: () => context.push('/meditate/session/${m.id}'),
        ).animate(delay: (50 * index).ms)
            .fadeIn(duration: 350.ms)
            .slideY(begin: 0.03, end: 0, duration: 350.ms);
      },
    );
  }

  Widget _buildMusicTab(BuildContext context, WidgetRef ref) {
    final musicList = ref.watch(meditationsProvider)
        .where((m) => m.type == MeditationType.soundscape)
        .toList();

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: AppSpacing.xl, right: AppSpacing.xl, top: AppSpacing.md, bottom: AppSpacing.lg),
      itemCount: musicList.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final m = musicList[index];
        return MeditationCard(
          meditation: m,
          onTap: () => context.push('/meditate/session/${m.id}'),
        ).animate(delay: (50 * index).ms)
            .fadeIn(duration: 350.ms)
            .slideY(begin: 0.03, end: 0, duration: 350.ms);
      },
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
