import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import 'package:lucide_icons/lucide_icons.dart';

// ── Mood model ────────────────────────────────────────────────
class _Mood {
  final String emoji;
  final String label;
  final Color color;
  const _Mood(this.emoji, this.label, this.color);
}

const _moods = [
  _Mood('😔', 'Struggling', AppColors.error),
  _Mood('😐', 'Neutral', AppColors.textMuted),
  _Mood('😊', 'Good', AppColors.info),
  _Mood('😄', 'Great', AppColors.success),
];

// ── Sample entry model ────────────────────────────────────────
class _JournalEntry {
  final String id;
  final DateTime date;
  final _Mood mood;
  final String body;
  final int streakDay;

  const _JournalEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.body,
    required this.streakDay,
  });
}

final _sampleEntries = [
  _JournalEntry(
    id: '1',
    date: DateTime.now().subtract(const Duration(days: 0)),
    mood: _moods[3],
    body:
        "Woke up feeling really clear-headed today. Had a tough moment around 3pm but I called a friend instead. Proud of that.",
    streakDay: 12,
  ),
  _JournalEntry(
    id: '2',
    date: DateTime.now().subtract(const Duration(days: 1)),
    mood: _moods[2],
    body:
        "Went for a run this morning. The routine is starting to feel natural. Still some cravings but they passed.",
    streakDay: 11,
  ),
  _JournalEntry(
    id: '3',
    date: DateTime.now().subtract(const Duration(days: 3)),
    mood: _moods[1],
    body: "Not a great day. Felt restless and irritable. Did some deep breathing. Tomorrow is a new start.",
    streakDay: 9,
  ),
];

// ─────────────────────────────────────────────────────────────
//  JournalScreen
// ─────────────────────────────────────────────────────────────
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final List<_JournalEntry> _entries = List.from(_sampleEntries);

  void _openCompose() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ComposeSheet(
        onSave: (mood, body) {
          if (body.trim().isEmpty) return;
          setState(() {
            _entries.insert(
              0,
              _JournalEntry(
                id: DateTime.now().toIso8601String(),
                date: DateTime.now(),
                mood: mood,
                body: body.trim(),
                streakDay: 12,
              ),
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _JournalHeader(onCompose: _openCompose),
            Expanded(
              child: _entries.isEmpty
                  ? _EmptyState(onCompose: _openCompose)
                  : _EntryList(entries: _entries),
            ),
          ],
        ),
      ),
      floatingActionButton: _entries.isEmpty
          ? null
          : _WriteFab(onPressed: _openCompose),
    );
  }
}

// ── Header ────────────────────────────────────────────────────
class _JournalHeader extends StatelessWidget {
  const _JournalHeader({required this.onCompose});
  final VoidCallback onCompose;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 18, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Journal',
                  style: AppTypography.heading1.copyWith(
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${months[now.month - 1]} ${now.year}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          _CircleBtn(
            icon: LucideIcons.pencil,
            onTap: onCompose,
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  const _CircleBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: AppColors.textPrimary),
      ),
    );
  }
}

// ── Empty State ────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCompose});
  final VoidCallback onCompose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.bookOpen,
                size: 38,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Your story starts here',
              style: AppTypography.heading3.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Write about your day, how you\'re feeling, or what\'s helping you stay on track.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            GestureDetector(
              onTap: onCompose,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppRadius.circular,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.pencil, color: AppColors.onPrimary, size: 18),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Write your first entry',
                      style: AppTypography.button.copyWith(color: AppColors.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.04, end: 0, duration: 400.ms);
  }
}

// ── Entry List ────────────────────────────────────────────────
class _EntryList extends StatelessWidget {
  const _EntryList({required this.entries});
  final List<_JournalEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 120),
      itemCount: entries.length,
      itemBuilder: (context, i) => _EntryCard(entry: entries[i], index: i),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry, required this.index});
  final _JournalEntry entry;
  final int index;

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final truncated = entry.body.length > 120
        ? '${entry.body.substring(0, 120)}…'
        : entry.body;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.extraLarge,
        child: InkWell(
          borderRadius: AppRadius.extraLarge,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.mood.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: entry.mood.color.withValues(alpha: 0.1),
                        borderRadius: AppRadius.circular,
                      ),
                      child: Text(
                        entry.mood.label,
                        style: AppTypography.caption.copyWith(
                          color: entry.mood.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(entry.date),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  truncated,
                  style: AppTypography.bodyMedium.copyWith(
                    height: 1.5,
                    color: AppColors.textBody,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(
                      LucideIcons.flame,
                      size: 13,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Day ${entry.streakDay}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: (60 * index).ms)
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.04, end: 0, duration: 350.ms, curve: Curves.easeOutCubic);
  }
}

// ── Write FAB ────────────────────────────────────────────────
class _WriteFab extends StatefulWidget {
  const _WriteFab({required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<_WriteFab> createState() => _WriteFabState();
}

class _WriteFabState extends State<_WriteFab> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 130),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadius.circular,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.40),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.pencil, color: AppColors.onPrimary, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Write',
                style: AppTypography.button.copyWith(color: AppColors.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Compose Sheet ─────────────────────────────────────────────
class _ComposeSheet extends StatefulWidget {
  const _ComposeSheet({required this.onSave});
  final void Function(_Mood mood, String body) onSave;

  @override
  State<_ComposeSheet> createState() => _ComposeSheetState();
}

class _ComposeSheetState extends State<_ComposeSheet> {
  final _controller = TextEditingController();
  _Mood _selectedMood = _moods[2];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.extraLarge,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.circular,
              ),
            ),
          ),

          // Title row
          Row(
            children: [
              Text(
                'How are you feeling?',
                style: AppTypography.heading3.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  widget.onSave(_selectedMood, _controller.text);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Save',
                  style: AppTypography.button.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Mood picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _moods.map((m) {
              final isSelected = _selectedMood == m;
              return GestureDetector(
                onTap: () => setState(() => _selectedMood = m),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? m.color.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: AppRadius.medium,
                    border: Border.all(
                      color: isSelected
                          ? m.color.withValues(alpha: 0.4)
                          : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(m.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 4),
                      Text(
                        m.label,
                        style: AppTypography.caption.copyWith(
                          color: isSelected ? m.color : AppColors.textMuted,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),

          // Text input
          TextField(
            controller: _controller,
            autofocus: true,
            maxLines: 6,
            minLines: 3,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Write about your day…',
              hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
