import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/journal_entry.dart';
import '../styles/journal_styles.dart';

const journalSuggestedTags = [
  'Gratitude', 'Cravings', 'Sleep', 'Family', 'Work', 'Health', 'Wins', 'Recovery',
];

class JournalContextResult {
  final JournalMood? mood;
  final List<String> tags;
  const JournalContextResult({this.mood, this.tags = const []});
}

/// Mood + tags in one calm sheet — context without the form-filling feel.
Future<JournalContextResult?> showJournalContextSheet(
  BuildContext context, {
  JournalMood? mood,
  List<String> tags = const [],
}) {
  return showModalBottomSheet<JournalContextResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ContextSheet(initialMood: mood, initialTags: tags),
  );
}

class _ContextSheet extends StatefulWidget {
  const _ContextSheet({this.initialMood, required this.initialTags});

  final JournalMood? initialMood;
  final List<String> initialTags;

  @override
  State<_ContextSheet> createState() => _ContextSheetState();
}

class _ContextSheetState extends State<_ContextSheet> {
  JournalMood? _mood;
  late final Set<String> _tags;

  @override
  void initState() {
    super.initState();
    _mood = widget.initialMood;
    _tags = {...widget.initialTags};
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
          Text(
            'How does it feel?',
            style: AppTypography.heading3.copyWith(color: palette.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tap again to clear — this is optional.',
            style: AppTypography.caption.copyWith(color: palette.textSubtle),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final mood in JournalMood.values)
                _MoodOrb(
                  mood: mood,
                  selected: _mood == mood,
                  palette: palette,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() => _mood = _mood == mood ? null : mood);
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'ADD CONTEXT',
            style: AppTypography.label.copyWith(color: palette.textSubtle),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final tag in journalSuggestedTags)
                _TagChip(
                  label: tag,
                  selected: _tags.contains(tag),
                  palette: palette,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _tags.contains(tag) ? _tags.remove(tag) : _tags.add(tag);
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: AppColors.primary,
              borderRadius: AppRadius.circular,
              child: InkWell(
                borderRadius: AppRadius.circular,
                onTap: () => Navigator.of(context).pop(
                  JournalContextResult(mood: _mood, tags: _tags.toList()),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg - 2),
                  child: Center(
                    child: Text(
                      'Done',
                      style: AppTypography.button.copyWith(color: AppColors.onPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A gradient orb per mood — no emoji, no grinning faces. Selection grows the
/// orb and draws a soft halo ring in the mood's color.
class _MoodOrb extends StatelessWidget {
  const _MoodOrb({
    required this.mood,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final JournalMood mood;
  final bool selected;
  final JournalPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Mood: ${mood.label}',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 56,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutBack,
                    width: selected ? 44 : 34,
                    height: selected ? 44 : 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: mood.gradient,
                      ),
                      border: selected
                          ? Border.all(color: palette.surface, width: 3)
                          : null,
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: mood.color.withValues(alpha: 0.45),
                                blurRadius: 14,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTypography.caption.copyWith(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? mood.color : palette.textSubtle,
                ),
                child: Text(mood.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final JournalPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md + AppSpacing.xxs,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryXLight : Colors.transparent,
          borderRadius: AppRadius.circular,
          border: Border.all(
            color: selected ? AppColors.primary.withValues(alpha: 0.4) : palette.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            fontSize: 12.5,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.primaryDark : palette.textMuted,
          ),
        ),
      ),
    );
  }
}
