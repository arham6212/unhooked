import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/journal_entry.dart';
import '../styles/journal_styles.dart';
import '../utils/journal_dates.dart';

/// Past entries strung along a quiet vertical spine with mood-tinted dots —
/// a visual thread through the writer's days.
class EntryTimeline extends StatelessWidget {
  const EntryTimeline({super.key, required this.entries, required this.onEntryTap});

  final List<JournalEntry> entries;
  final ValueChanged<JournalEntry> onEntryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < entries.length; i++)
          _TimelineRow(
            entry: entries[i],
            isFirst: i == 0,
            isLast: i == entries.length - 1,
            onTap: () {
              HapticFeedback.selectionClick();
              onEntryTap(entries[i]);
            },
          ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.entry,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  final JournalEntry entry;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = JournalPalette.of(context);
    final moodColor = entry.mood?.color ?? palette.textSubtle;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Spine: hairline + mood dot.
          SizedBox(
            width: 24,
            child: Column(
              children: [
                SizedBox(
                  height: 26,
                  child: isFirst
                      ? null
                      : VerticalDivider(width: 1, thickness: 1, color: palette.divider),
                ),
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: entry.mood == null ? Colors.transparent : null,
                    gradient: entry.mood == null
                        ? null
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: entry.mood!.gradient,
                          ),
                    border: entry.mood == null
                        ? Border.all(color: palette.textSubtle, width: 1.5)
                        : null,
                  ),
                ),
                Expanded(
                  child: isLast
                      ? const SizedBox.shrink()
                      : VerticalDivider(width: 1, thickness: 1, color: palette.divider),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: _EntryCard(
                entry: entry,
                moodColor: moodColor,
                palette: palette,
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.entry,
    required this.moodColor,
    required this.palette,
    required this.onTap,
  });

  final JournalEntry entry;
  final Color moodColor;
  final JournalPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Journal entry from ${JournalDates.relative(entry.createdAt)}',
      child: Material(
        color: palette.surface,
        borderRadius: AppRadius.large,
        child: InkWell(
          borderRadius: AppRadius.large,
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.large,
              border: Border.all(color: palette.border, width: 1),
              boxShadow: AppShadows.sm,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        JournalDates.relative(entry.createdAt),
                        style: AppTypography.caption.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Icon(LucideIcons.clock, size: 11, color: palette.textSubtle),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${entry.readingMinutes} min',
                        style: AppTypography.caption.copyWith(
                          fontSize: 11,
                          color: palette.textSubtle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    entry.body.trim(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: JournalType.preview.copyWith(color: palette.textBody),
                  ),
                  if (entry.mood != null || entry.tags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        if (entry.mood != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm + AppSpacing.xxs,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: moodColor.withValues(alpha: 0.1),
                              borderRadius: AppRadius.circular,
                            ),
                            child: Text(
                              entry.mood!.label,
                              style: AppTypography.caption.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: moodColor,
                              ),
                            ),
                          ),
                        if (entry.mood != null && entry.tags.isNotEmpty)
                          const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            entry.tags.take(3).map((t) => '#$t').join('  '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.caption.copyWith(
                              fontSize: 11,
                              color: palette.textSubtle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
