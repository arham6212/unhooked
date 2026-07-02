import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/journal_reflection.dart';
import '../providers/journal_providers.dart';
import '../styles/journal_styles.dart';

/// A thoughtful companion, not a chatbot: reads the entry, mirrors it back,
/// and leaves one open question on the table.
Future<void> showJournalReflectionSheet(BuildContext context, JournalEntry entry) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ReflectionSheet(entry: entry),
  );
}

class _ReflectionSheet extends ConsumerStatefulWidget {
  const _ReflectionSheet({required this.entry});

  final JournalEntry entry;

  @override
  ConsumerState<_ReflectionSheet> createState() => _ReflectionSheetState();
}

class _ReflectionSheetState extends ConsumerState<_ReflectionSheet> {
  JournalReflection? _reflection;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result =
        await ref.read(journalReflectionServiceProvider).reflect(widget.entry);
    if (!mounted) return;
    result.fold(
      (reflection) => setState(() => _reflection = reflection),
      (failure) => setState(() => _error = failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = JournalPalette.of(context);
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.xl + bottomInset,
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: palette.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.tintBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.sparkles,
                      size: 15, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'REFLECTION',
                  style: AppTypography.label.copyWith(color: palette.textSubtle),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            if (_reflection == null && _error == null)
              _LoadingState(palette: palette)
            else if (_error != null)
              Text(
                'Couldn\'t read your words just now. Your writing is safe — try again in a moment.',
                style: AppTypography.bodyMedium.copyWith(color: palette.textMuted),
              )
            else
              _ReflectionBody(reflection: _reflection!, palette: palette),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Keep writing',
                  style: AppTypography.button.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.palette});

  final JournalPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.7, 0.7),
                end: const Offset(1.15, 1.15),
                duration: 700.ms,
                curve: Curves.easeInOut,
              )
              .fade(begin: 0.4, end: 1, duration: 700.ms),
          const SizedBox(width: AppSpacing.md),
          Text(
            'Reading your words…',
            style: AppTypography.bodyMedium.copyWith(color: palette.textMuted),
          ),
        ],
      ),
    );
  }
}

class _ReflectionBody extends StatelessWidget {
  const _ReflectionBody({required this.reflection, required this.palette});

  final JournalReflection reflection;
  final JournalPalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reflection.summary,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 15.5,
            color: palette.textBody,
            height: 1.6,
          ),
        ),
        if (reflection.themes.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final theme in reflection.themes)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs + 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tintBlue,
                    borderRadius: AppRadius.circular,
                  ),
                  child: Text(
                    theme,
                    style: AppTypography.caption.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        // The open question — set apart with a thin rule, like a margin note.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 2.5,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  reflection.question,
                  style: JournalType.prompt.copyWith(
                    fontSize: 16,
                    color: palette.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          reflection.affirmation,
          style: AppTypography.caption.copyWith(
            fontSize: 12.5,
            color: palette.textSubtle,
            height: 1.5,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 450.ms, curve: Curves.easeOut)
        .slideY(begin: 0.02, end: 0, duration: 450.ms, curve: Curves.easeOutCubic);
  }
}
