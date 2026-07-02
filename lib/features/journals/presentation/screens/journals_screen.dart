import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/journal_entry.dart';
import '../providers/journal_providers.dart';
import '../styles/journal_styles.dart';
import '../widgets/entry_timeline.dart';
import '../widgets/journal_empty_state.dart';
import '../widgets/journal_header.dart';
import '../widgets/today_page_card.dart';
import '../widgets/writing_sparks.dart';
import 'journal_editor_screen.dart';

/// The journal tab — a quiet page, not a feed.
class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  void _openEditor(BuildContext context, {String? entryId, String? prompt}) {
    context.push(
      '/journal/write',
      extra: JournalEditorArgs(entryId: entryId, prompt: prompt),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = JournalPalette.of(context);
    final entriesAsync = ref.watch(journalEntriesProvider);

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: switch (entriesAsync) {
          AsyncData(:final value) => value.isEmpty
              ? JournalEmptyState(
                  onBegin: () => _openEditor(context),
                  onGratitudePrompt: () => _openEditor(
                    context,
                    prompt: sparksForToday().first.text,
                  ),
                )
              : _JournalBody(
                  entries: value,
                  onWriteToday: (entryId) =>
                      _openEditor(context, entryId: entryId),
                  onSparkTap: (spark) =>
                      _openEditor(context, prompt: spark.text),
                  onEntryTap: (entry) =>
                      _openEditor(context, entryId: entry.id),
                ),
          AsyncError() => _LoadFailed(
              palette: palette,
              onRetry: () => ref.invalidate(journalEntriesProvider),
            ),
          _ => const _CalmLoading(),
        },
      ),
    );
  }
}

class _JournalBody extends StatelessWidget {
  const _JournalBody({
    required this.entries,
    required this.onWriteToday,
    required this.onSparkTap,
    required this.onEntryTap,
  });

  final List<JournalEntry> entries;
  final ValueChanged<String?> onWriteToday;
  final ValueChanged<JournalSpark> onSparkTap;
  final ValueChanged<JournalEntry> onEntryTap;

  @override
  Widget build(BuildContext context) {
    final palette = JournalPalette.of(context);

    JournalEntry? todayEntry;
    final now = DateTime.now();
    for (final entry in entries) {
      final d = entry.createdAt;
      if (d.year == now.year && d.month == now.month && d.day == now.day) {
        todayEntry = entry;
        break;
      }
    }
    final earlier =
        entries.where((e) => e.id != todayEntry?.id).toList(growable: false);

    const hPad = EdgeInsets.symmetric(horizontal: AppSpacing.lg + AppSpacing.xs);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: hPad, child: JournalHeader())
                  .animate()
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: AppSpacing.xl),
              Padding(
                padding: hPad,
                child: TodayPageCard(
                  todayEntry: todayEntry,
                  onTap: () => onWriteToday(todayEntry?.id),
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
              const SizedBox(height: AppSpacing.xxl),
              Padding(
                padding: hPad,
                child: Text(
                  'SPARKS',
                  style: AppTypography.label.copyWith(color: palette.textSubtle),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              WritingSparks(onSparkTap: onSparkTap)
                  .animate(delay: 120.ms)
                  .fadeIn(duration: 400.ms)
                  .slideX(
                    begin: 0.02,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),
              if (earlier.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxl),
                Padding(
                  padding: hPad,
                  child: Text(
                    'EARLIER',
                    style:
                        AppTypography.label.copyWith(color: palette.textSubtle),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: hPad,
                  child: EntryTimeline(
                    entries: earlier,
                    onEntryTap: onEntryTap,
                  ),
                ).animate(delay: 180.ms).fadeIn(duration: 450.ms).slideY(
                      begin: 0.02,
                      end: 0,
                      duration: 450.ms,
                      curve: Curves.easeOutCubic,
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A breathing dot instead of a spinner — nothing here should feel busy.
class _CalmLoading extends StatelessWidget {
  const _CalmLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          color: AppColors.primaryLight,
          shape: BoxShape.circle,
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(0.7, 0.7),
            end: const Offset(1.2, 1.2),
            duration: 800.ms,
            curve: Curves.easeInOut,
          )
          .fade(begin: 0.4, end: 1, duration: 800.ms),
    );
  }
}

class _LoadFailed extends StatelessWidget {
  const _LoadFailed({required this.palette, required this.onRetry});

  final JournalPalette palette;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your journal couldn\'t be opened',
            style: AppTypography.heading3.copyWith(color: palette.textPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your entries are safe. Give it another try.',
            style: AppTypography.bodyMedium.copyWith(color: palette.textMuted),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Try again',
              style: AppTypography.button.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
