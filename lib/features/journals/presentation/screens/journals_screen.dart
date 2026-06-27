import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
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
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => _ComposeScreen(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
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
          _PillButton(
            icon: LucideIcons.plus,
            label: 'Write',
            onTap: onCompose,
          ),
        ],
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppRadius.circular,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.onPrimary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.button.copyWith(
                color: AppColors.onPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
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
        
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
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


// ── Compose Screen ─────────────────────────────────────────────
class _ComposeScreen extends StatefulWidget {
  const _ComposeScreen({required this.onSave});
  final void Function(_Mood mood, String body) onSave;

  @override
  State<_ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<_ComposeScreen> {
  final _controller = TextEditingController();
  _Mood _selectedMood = _moods[2];

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
          if (mounted && _isListening) {
            setState(() => _isListening = false);
          }
        }
      },
    );
  }

  void _startDictation() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _previousText = _controller.text;
        if (_previousText.isNotEmpty && !_previousText.endsWith(' ') && !_previousText.endsWith('\n')) {
          _previousText += ' ';
        }
      });
      _speechToText.listen(
        onResult: (val) {
          setState(() {
            _controller.text = _previousText + val.recognizedWords;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          });
        },
      );
    }
  }

  void _stopDictation() {
    setState(() => _isListening = false);
    _speechToText.stop();
  }

  void _cancelDictation() {
    setState(() {
      _isListening = false;
      _controller.text = _previousText;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
    _speechToText.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${now.day} ${months[now.month - 1]} ${now.year}';

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.x, color: isDark ? Colors.white70 : Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: TextButton(
              onPressed: () {
                widget.onSave(_selectedMood, _controller.text);
                Navigator.of(context).pop();
              },
              child: Text(
                'Save',
                style: AppTypography.button.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date and Mood
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Row(
                children: [
                  Text(
                    dateStr,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  // Minimal mood selector dropdown
                  _MinimalMoodSelector(
                    selected: _selectedMood,
                    onSelected: (m) => setState(() => _selectedMood = m),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Text Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  style: AppTypography.heading3.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                    color: isDark ? Colors.white.withValues(alpha: 0.9) : Colors.black.withValues(alpha: 0.8),
                  ),
                  decoration: InputDecoration(
                    hintText: 'What\'s on your mind?',
                    hintStyle: AppTypography.heading3.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _DictationMicButton(
        isListening: _isListening,
        onStart: _startDictation,
        onStop: _stopDictation,
        onCancel: _cancelDictation,
      ),
    );
  }
}

class _MinimalMoodSelector extends StatelessWidget {
  const _MinimalMoodSelector({required this.selected, required this.onSelected});
  final _Mood selected;
  final ValueChanged<_Mood> onSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PopupMenuButton<_Mood>(
      initialValue: selected,
      onSelected: onSelected,
      color: isDark ? AppColors.surfaceDark : AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      offset: const Offset(0, 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(selected.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              selected.label,
              style: AppTypography.caption.copyWith(
                color: selected.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      itemBuilder: (context) {
        return _moods.map((m) {
          return PopupMenuItem<_Mood>(
            value: m,
            child: Row(
              children: [
                Text(m.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: AppSpacing.md),
                Text(
                  m.label,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: selected == m ? FontWeight.w600 : FontWeight.w400,
                    color: selected == m ? m.color : null,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

enum _MicState { idle, holding, locked }

class _DictationMicButton extends StatefulWidget {
  final bool isListening;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onCancel;

  const _DictationMicButton({
    required this.isListening,
    required this.onStart,
    required this.onStop,
    required this.onCancel,
  });

  @override
  State<_DictationMicButton> createState() => _DictationMicButtonState();
}

class _DictationMicButtonState extends State<_DictationMicButton> {
  _MicState _uiState = _MicState.idle;
  double _dragY = 0;
  double _dragX = 0;

  @override
  void didUpdateWidget(_DictationMicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isListening && !widget.isListening) {
      setState(() {
        _uiState = _MicState.idle;
        _dragX = 0;
        _dragY = 0;
      });
    }
  }

  void _handlePanStart(DragStartDetails details) {
    if (_uiState != _MicState.idle) return;
    setState(() {
      _uiState = _MicState.holding;
      _dragY = 0;
      _dragX = 0;
    });
    widget.onStart();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_uiState != _MicState.holding) return;
    
    _dragY += details.delta.dy;
    _dragX += details.delta.dx;

    // Slide up to lock
    if (_dragY < -60) {
      setState(() {
        _uiState = _MicState.locked;
        _dragY = 0;
        _dragX = 0;
      });
      return;
    }

    // Slide left to cancel
    if (_dragX < -60) {
      setState(() {
        _uiState = _MicState.idle;
        _dragY = 0;
        _dragX = 0;
      });
      widget.onCancel();
      return;
    }
    
    setState((){});
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_uiState == _MicState.holding) {
      setState(() {
        _uiState = _MicState.idle;
        _dragY = 0;
        _dragX = 0;
      });
      widget.onStop();
    }
  }

  void _handleTap() {
    if (_uiState == _MicState.locked || _uiState == _MicState.holding) {
      setState(() {
        _uiState = _MicState.idle;
        _dragY = 0;
        _dragX = 0;
      });
      widget.onStop();
    } else {
      // Tap to toggle lock directly
      setState(() {
        _uiState = _MicState.locked;
      });
      widget.onStart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = _uiState == _MicState.idle;
    final isHolding = _uiState == _MicState.holding;
    final isLocked = _uiState == _MicState.locked;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Lock Indicator (above)
          if (isHolding)
            Positioned(
              bottom: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.lock, color: isDark ? Colors.white70 : Colors.black54, size: 20),
                  const SizedBox(height: 4),
                  Icon(LucideIcons.chevronUp, color: isDark ? Colors.white70 : Colors.black54, size: 16)
                      .animate(onPlay: (c) => c.repeat())
                      .slideY(begin: 0.5, end: -0.5, duration: 800.ms)
                      .fadeOut(duration: 800.ms),
                ],
              ).animate().fadeIn().slideY(begin: 0.2, end: 0),
            ),

          // Cancel Indicator (left)
          if (isHolding)
            Positioned(
              right: 80,
              bottom: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.chevronLeft, color: isDark ? Colors.white70 : Colors.black54, size: 16)
                      .animate(onPlay: (c) => c.repeat())
                      .slideX(begin: 0.5, end: -0.5, duration: 800.ms)
                      .fadeOut(duration: 800.ms),
                  const SizedBox(width: 4),
                  Text('Cancel', style: AppTypography.caption.copyWith(color: isDark ? Colors.white70 : Colors.black54)),
                ],
              ).animate().fadeIn().slideX(begin: 0.2, end: 0),
            ),
            
          // Ripple effect
          if (!isIdle)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.error, width: 2),
                  ),
                ).animate(onPlay: (c) => c.repeat())
                 .scale(begin: const Offset(1, 1), end: const Offset(1.8, 1.8), duration: 1.seconds)
                 .fadeOut(duration: 1.seconds),
              ),
            ),

          // Main button
          GestureDetector(
            onPanStart: _handlePanStart,
            onPanUpdate: _handlePanUpdate,
            onPanEnd: _handlePanEnd,
            onTap: _handleTap,
            child: Transform.translate(
              offset: Offset(isHolding ? _dragX : 0, isHolding ? _dragY : 0),
              child: AnimatedContainer(
                duration: isHolding ? Duration.zero : const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isIdle ? AppColors.primary : AppColors.error,
                  shape: BoxShape.circle,
                  boxShadow: isIdle ? [] : [
                    BoxShadow(
                      color: AppColors.error.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 4,
                    )
                  ],
                ),
                child: Icon(
                  isLocked ? LucideIcons.square : LucideIcons.mic,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
