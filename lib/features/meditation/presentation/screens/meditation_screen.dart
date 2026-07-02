import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/meditation.dart';
import '../providers/meditation_provider.dart';
import '../styles/meditation_palette.dart';
import '../widgets/meditation_card.dart';
import '../widgets/meditation_hero.dart';

enum _Section { guided, breathing, sounds }

extension _SectionX on _Section {
  String get label => switch (this) {
        _Section.guided => 'Guided',
        _Section.breathing => 'Breathing',
        _Section.sounds => 'Sounds',
      };
}

/// The still room: one recommended session breathing at the top, the
/// emergency lifeline underneath, everything else a calm shelf below.
class MeditationScreen extends ConsumerStatefulWidget {
  const MeditationScreen({super.key});

  @override
  ConsumerState<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends ConsumerState<MeditationScreen> {
  _Section _section = _Section.guided;

  static const _hPad =
      EdgeInsets.symmetric(horizontal: AppSpacing.lg + AppSpacing.xs);

  ({String label, String id}) get _heroPick {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) {
      return (label: 'For this morning', id: 'morning_intention');
    }
    if (hour >= 11 && hour < 15) return (label: 'For midday', id: 'focus_clarity');
    if (hour >= 15 && hour < 19) {
      return (label: 'For this afternoon', id: 'stress_release');
    }
    if (hour >= 19 && hour < 23) return (label: 'For this evening', id: 'gratitude');
    return (label: 'For tonight', id: 'sleep_meditation');
  }

  void _openSession(String id) => context.push('/meditate/session/$id');

  @override
  Widget build(BuildContext context) {
    final palette = MeditationPalette.of(context);
    final meditations = ref.watch(meditationsProvider);

    final pick = _heroPick;
    final hero = meditations.firstWhere(
      (m) => m.id == pick.id,
      orElse: () => meditations.first,
    );

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: 120),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: _hPad, child: _Header(palette: palette))
                      .animate()
                      .fadeIn(duration: 400.ms),
                  const SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: _hPad,
                    child: MeditationHero(
                      label: pick.label,
                      meditation: hero,
                      onTap: () => _openSession(hero.id),
                    ),
                  )
                      .animate(delay: 60.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(
                        begin: 0.03,
                        end: 0,
                        duration: 400.ms,
                        curve: Curves.easeOutCubic,
                      ),
                  const SizedBox(height: AppSpacing.md),
                  Padding(
                    padding: _hPad,
                    child: SosStrip(onTap: () => _openSession('emergency_calm')),
                  ).animate(delay: 120.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: AppSpacing.xl),
                  Padding(
                    padding: _hPad,
                    child: _Segments(
                      palette: palette,
                      selected: _section,
                      onChanged: (s) => setState(() => _section = s),
                    ),
                  ).animate(delay: 180.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: AppSpacing.lg),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    layoutBuilder: (currentChild, previousChildren) => Stack(
                      alignment: Alignment.topCenter,
                      children: [...previousChildren, ?currentChild],
                    ),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.015),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(_section),
                      child: switch (_section) {
                        _Section.guided => _GuidedSection(
                            palette: palette,
                            onOpen: _openSession,
                          ),
                        _Section.breathing => _CardListSection(
                            meditations: meditations
                                .where((m) => m.type == MeditationType.exercise)
                                .toList(growable: false),
                            onOpen: _openSession,
                          ),
                        _Section.sounds => _SoundsSection(
                            meditations: meditations
                                .where((m) => m.type == MeditationType.soundscape)
                                .toList(growable: false),
                            onOpen: _openSession,
                          ),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Header ──────────────────────────────────────────────────────
class _Header extends ConsumerWidget {
  const _Header({required this.palette});

  final MeditationPalette palette;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(meditationStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meditate',
          style: AppTypography.heading1.copyWith(
            fontSize: 28,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Ten quiet minutes can defuse the loudest urge.',
          style: AppTypography.caption.copyWith(
            fontSize: 13,
            color: palette.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Practice history as a sentence, not a dashboard.
        Row(
          children: [
            const Icon(LucideIcons.sprout, size: 14, color: AppColors.tealDark),
            const SizedBox(width: AppSpacing.sm - 2),
            Expanded(
              child: stats.totalSessions == 0
                  ? Text(
                      'Your first still minutes are waiting.',
                      style: AppTypography.caption.copyWith(
                        fontSize: 12.5,
                        color: palette.textMuted,
                      ),
                    )
                  : Text.rich(
                      TextSpan(
                        text: '${stats.totalMinutes} mindful minutes',
                        style: AppTypography.caption.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.tealDark,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '  ·  ${stats.totalSessions} session${stats.totalSessions == 1 ? '' : 's'}'
                                '${stats.currentStreak > 0 ? '  ·  ${stats.currentStreak}-day streak' : ''}',
                            style: AppTypography.caption.copyWith(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: palette.textMuted,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Segmented control ───────────────────────────────────────────
class _Segments extends StatelessWidget {
  const _Segments({
    required this.palette,
    required this.selected,
    required this.onChanged,
  });

  final MeditationPalette palette;
  final _Section selected;
  final ValueChanged<_Section> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: palette.surfaceSunken,
        borderRadius: AppRadius.circular,
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            alignment: Alignment(-1 + selected.index * 1.0, 0),
            child: FractionallySizedBox(
              widthFactor: 1 / _Section.values.length,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: palette.surface,
                  borderRadius: AppRadius.circular,
                  boxShadow: AppShadows.sm,
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (final section in _Section.values)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: section == selected,
                    label: '${section.label} sessions',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onChanged(section);
                      },
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: AppTypography.caption.copyWith(
                            fontSize: 12.5,
                            fontWeight: section == selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: section == selected
                                ? palette.textPrimary
                                : palette.textMuted,
                          ),
                          child: Text(section.label),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Guided section (topics + list) ──────────────────────────────
class _GuidedSection extends ConsumerWidget {
  const _GuidedSection({required this.palette, required this.onOpen});

  final MeditationPalette palette;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider);
    final filtered = ref.watch(filteredMeditationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg + AppSpacing.xs,
            ),
            itemCount: MeditationCategory.values.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, i) {
              final category = MeditationCategory.values[i];
              return _TopicChip(
                palette: palette,
                category: category,
                isActive: category == selected,
                onTap: () =>
                    ref.read(selectedCategoryProvider.notifier).select(category),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _CardListSection(meditations: filtered, onOpen: onOpen),
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.palette,
    required this.category,
    required this.isActive,
    required this.onTap,
  });

  final MeditationPalette palette;
  final MeditationCategory category;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? palette.textPrimary : palette.surface,
          borderRadius: AppRadius.circular,
          border: Border.all(
            color: isActive ? Colors.transparent : palette.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 12,
              color: isActive ? palette.surface : palette.textSubtle,
            ),
            const SizedBox(width: AppSpacing.xs + 1),
            Text(
              category.label,
              style: AppTypography.caption.copyWith(
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? palette.surface : palette.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared card list ────────────────────────────────────────────
class _CardListSection extends StatelessWidget {
  const _CardListSection({required this.meditations, required this.onOpen});

  final List<Meditation> meditations;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg + AppSpacing.xs),
      child: Column(
        children: [
          for (final (i, m) in meditations.indexed)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == meditations.length - 1 ? 0 : AppSpacing.md,
              ),
              child: PracticeCard(meditation: m, onTap: () => onOpen(m.id))
                  .animate(delay: (45 * i).ms)
                  .fadeIn(duration: 320.ms)
                  .slideY(
                    begin: 0.03,
                    end: 0,
                    duration: 320.ms,
                    curve: Curves.easeOutCubic,
                  ),
            ),
        ],
      ),
    );
  }
}

// ── Sounds section ──────────────────────────────────────────────
class _SoundsSection extends StatelessWidget {
  const _SoundsSection({required this.meditations, required this.onOpen});

  final List<Meditation> meditations;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg + AppSpacing.xs),
      child: Column(
        children: [
          for (final (i, m) in meditations.indexed)
            Padding(
              padding: EdgeInsets.only(
                bottom: i == meditations.length - 1 ? 0 : AppSpacing.md,
              ),
              child: SoundscapeCard(meditation: m, onTap: () => onOpen(m.id))
                  .animate(delay: (45 * i).ms)
                  .fadeIn(duration: 320.ms)
                  .slideY(
                    begin: 0.03,
                    end: 0,
                    duration: 320.ms,
                    curve: Curves.easeOutCubic,
                  ),
            ),
        ],
      ),
    );
  }
}
