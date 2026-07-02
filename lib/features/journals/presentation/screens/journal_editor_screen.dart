import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/journal_entry.dart';
import '../providers/journal_providers.dart';
import '../styles/journal_styles.dart';
import '../utils/journal_dates.dart';
import '../widgets/journal_context_sheet.dart';
import '../widgets/journal_reflection_sheet.dart';

class JournalEditorArgs {
  final String? entryId;
  final String? prompt;
  const JournalEditorArgs({this.entryId, this.prompt});
}

enum _SaveStatus { hidden, saving, saved }

/// Words appear at this count before the reflection companion offers itself.
const _reflectionThreshold = 40;

/// The page itself: full-screen, chrome-free writing with quiet autosave.
class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({super.key, this.args});

  final JournalEditorArgs? args;

  @override
  ConsumerState<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  String? _entryId;
  DateTime? _createdAt;
  JournalMood? _mood;
  List<String> _tags = const [];
  String? _prompt;
  bool _isExistingEntry = false;

  int _wordCount = 0;
  String _lastText = '';
  _SaveStatus _saveStatus = _SaveStatus.hidden;
  Timer? _saveDebounce;
  Timer? _savedFade;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _dictationBase = '';

  @override
  void initState() {
    super.initState();
    final args = widget.args;
    _prompt = args?.prompt;
    if (args?.entryId != null) {
      final entry =
          ref.read(journalEntriesProvider.notifier).entryById(args!.entryId!);
      if (entry != null) {
        _isExistingEntry = true;
        _entryId = entry.id;
        _createdAt = entry.createdAt;
        _mood = entry.mood;
        _tags = entry.tags;
        _prompt = entry.prompt ?? _prompt;
        _controller.text = entry.body;
        _wordCount = entry.wordCount;
        _lastText = entry.body;
      }
    }
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    _savedFade?.cancel();
    _speech.stop();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Autosave ─────────────────────────────────────────────────
  void _onTextChanged() {
    // The listener also fires on cursor moves — only react to real edits.
    if (_controller.text == _lastText) return;
    _lastText = _controller.text;

    final text = _controller.text.trim();
    final count = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
    if (count != _wordCount) setState(() => _wordCount = count);

    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 700), _persist);
  }

  Future<void> _persist({bool silent = false}) async {
    final body = _controller.text;
    if (body.trim().isEmpty && _entryId == null) return;

    final now = DateTime.now();
    _entryId ??= now.microsecondsSinceEpoch.toString();
    _createdAt ??= now;

    if (!silent && mounted) {
      _savedFade?.cancel();
      setState(() => _saveStatus = _SaveStatus.saving);
    }

    await ref.read(journalEntriesProvider.notifier).upsert(
          JournalEntry(
            id: _entryId!,
            createdAt: _createdAt!,
            updatedAt: now,
            body: body,
            mood: _mood,
            tags: _tags,
            prompt: _prompt,
          ),
        );

    if (silent || !mounted) return;
    setState(() => _saveStatus = _SaveStatus.saved);
    _savedFade = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _saveStatus = _SaveStatus.hidden);
    });
  }

  /// Final write when leaving the page — no UI churn.
  void _flush() {
    _saveDebounce?.cancel();
    _persist(silent: true);
  }

  // ── Context (mood + tags) ────────────────────────────────────
  Future<void> _openContextSheet() async {
    _focusNode.unfocus();
    final result =
        await showJournalContextSheet(context, mood: _mood, tags: _tags);
    if (result == null || !mounted) return;
    setState(() {
      _mood = result.mood;
      _tags = result.tags;
    });
    _persist();
  }

  // ── Reflection ───────────────────────────────────────────────
  Future<void> _openReflection() async {
    HapticFeedback.lightImpact();
    _focusNode.unfocus();
    await _persist(silent: true);
    if (!mounted || _entryId == null) return;
    final entry = ref.read(journalEntriesProvider.notifier).entryById(_entryId!);
    if (entry == null) return;
    await showJournalReflectionSheet(context, entry);
  }

  // ── Dictation ────────────────────────────────────────────────
  Future<void> _toggleDictation() async {
    if (_isListening) {
      setState(() => _isListening = false);
      await _speech.stop();
      return;
    }
    final available = await _speech.initialize(
      onStatus: (status) {
        if ((status == 'notListening' || status == 'done') &&
            mounted &&
            _isListening) {
          setState(() => _isListening = false);
        }
      },
    );
    if (!available || !mounted) return;

    _dictationBase = _controller.text;
    if (_dictationBase.isNotEmpty &&
        !_dictationBase.endsWith(' ') &&
        !_dictationBase.endsWith('\n')) {
      _dictationBase += ' ';
    }
    setState(() => _isListening = true);
    _speech.listen(onResult: (result) {
      _controller.text = _dictationBase + result.recognizedWords;
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length);
    });
  }

  // ── Delete ───────────────────────────────────────────────────
  Future<void> _confirmDelete() async {
    final palette = JournalPalette.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.extraLarge),
        title: Text(
          'Let this page go?',
          style: AppTypography.heading3.copyWith(color: palette.textPrimary),
        ),
        content: Text(
          'This entry will be removed. This can\'t be undone.',
          style: AppTypography.bodyMedium.copyWith(color: palette.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Keep it',
              style: AppTypography.button.copyWith(color: palette.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: AppTypography.button.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted || _entryId == null) return;
    _saveDebounce?.cancel();
    await ref.read(journalEntriesProvider.notifier).remove(_entryId!);
    _entryId = null; // nothing left to flush on pop
    if (mounted) Navigator.of(context).pop();
  }

  String get _hint {
    if (_prompt != null) return 'Start anywhere…';
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'What\'s on your mind this morning?';
    if (hour >= 12 && hour < 17) return 'What\'s on your mind this afternoon?';
    if (hour >= 17 && hour < 22) return 'What\'s on your mind this evening?';
    return 'What\'s keeping you up tonight?';
  }

  @override
  Widget build(BuildContext context) {
    final palette = JournalPalette.of(context);

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _flush();
      },
      child: Scaffold(
        backgroundColor: palette.surface,
        body: SafeArea(
          child: Column(
            children: [
              _TopBar(
                palette: palette,
                date: _createdAt ?? DateTime.now(),
                saveStatus: _saveStatus,
                showDelete: _isExistingEntry,
                onClose: () => Navigator.of(context).pop(),
                onDelete: _confirmDelete,
              ),
              if (_prompt != null)
                _PromptBanner(
                  palette: palette,
                  prompt: _prompt!,
                  onDismiss: () => setState(() => _prompt = null),
                ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: !_isExistingEntry,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      cursorColor: AppColors.primary,
                      cursorWidth: 2,
                      cursorRadius: const Radius.circular(2),
                      style: JournalType.editorBody
                          .copyWith(color: palette.textPrimary),
                      decoration: InputDecoration(
                        hintText: _hint,
                        hintStyle:
                            JournalType.ghost.copyWith(color: palette.textSubtle),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.fromLTRB(
                          AppSpacing.xl,
                          AppSpacing.lg,
                          AppSpacing.xl,
                          AppSpacing.xl,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _Toolbar(
                palette: palette,
                mood: _mood,
                tags: _tags,
                wordCount: _wordCount,
                isListening: _isListening,
                showReflect: _wordCount >= _reflectionThreshold,
                onContextTap: _openContextSheet,
                onReflectTap: _openReflection,
                onMicTap: _toggleDictation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Top bar ─────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.palette,
    required this.date,
    required this.saveStatus,
    required this.showDelete,
    required this.onClose,
    required this.onDelete,
  });

  final JournalPalette palette;
  final DateTime date;
  final _SaveStatus saveStatus;
  final bool showDelete;
  final VoidCallback onClose;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        0,
      ),
      child: Row(
        children: [
          // Mirrors the right-side width so the date sits truly centered.
          SizedBox(
            width: 96,
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: onClose,
                tooltip: 'Close',
                icon: Icon(LucideIcons.chevronDown,
                    size: 22, color: palette.textMuted),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  JournalDates.smallCaps(date),
                  style: AppTypography.label.copyWith(color: palette.textSubtle),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 96,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _SaveIndicator(status: saveStatus, palette: palette),
                if (showDelete)
                  IconButton(
                    onPressed: onDelete,
                    tooltip: 'Delete entry',
                    icon: Icon(LucideIcons.trash2,
                        size: 17, color: palette.textSubtle),
                  )
                else
                  const SizedBox(width: AppSpacing.md),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Autosave whispers: a dot and one word, then fades away.
class _SaveIndicator extends StatelessWidget {
  const _SaveIndicator({required this.status, required this.palette});

  final _SaveStatus status;
  final JournalPalette palette;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: switch (status) {
        _SaveStatus.hidden => const SizedBox(key: ValueKey('hidden')),
        _SaveStatus.saving => _chip('Saving', palette.textSubtle, key: 'saving'),
        _SaveStatus.saved => _chip('Saved', AppColors.tealDark, key: 'saved'),
      },
    );
  }

  Widget _chip(String label, Color color, {required String key}) {
    return Row(
      key: ValueKey(key),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.caption.copyWith(fontSize: 11, color: color),
        ),
      ],
    );
  }
}

// ── Prompt banner ───────────────────────────────────────────────
class _PromptBanner extends StatelessWidget {
  const _PromptBanner({
    required this.palette,
    required this.prompt,
    required this.onDismiss,
  });

  final JournalPalette palette;
  final String prompt;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.lg,
            0,
          ),
          child: IntrinsicHeight(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                    child: Text(
                      prompt,
                      style: JournalType.prompt.copyWith(color: palette.textMuted),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onDismiss,
                  tooltip: 'Dismiss prompt',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(LucideIcons.x, size: 14, color: palette.textSubtle),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 350.ms);
  }
}

// ── Bottom toolbar ──────────────────────────────────────────────
class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.palette,
    required this.mood,
    required this.tags,
    required this.wordCount,
    required this.isListening,
    required this.showReflect,
    required this.onContextTap,
    required this.onReflectTap,
    required this.onMicTap,
  });

  final JournalPalette palette;
  final JournalMood? mood;
  final List<String> tags;
  final int wordCount;
  final bool isListening;
  final bool showReflect;
  final VoidCallback onContextTap;
  final VoidCallback onReflectTap;
  final VoidCallback onMicTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.divider)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          _ContextChip(
            palette: palette,
            mood: mood,
            tagCount: tags.length,
            onTap: onContextTap,
          ),
          const Spacer(),
          if (wordCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Text(
                '$wordCount words',
                style: AppTypography.caption.copyWith(
                  fontSize: 11,
                  color: palette.textSubtle,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          if (showReflect)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _ReflectChip(onTap: onReflectTap),
            ),
          _MicButton(
            palette: palette,
            isListening: isListening,
            onTap: onMicTap,
          ),
        ],
      ),
    );
  }
}

/// One chip for mood + tags — tapping opens the shared context sheet.
class _ContextChip extends StatelessWidget {
  const _ContextChip({
    required this.palette,
    required this.mood,
    required this.tagCount,
    required this.onTap,
  });

  final JournalPalette palette;
  final JournalMood? mood;
  final int tagCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasContext = mood != null || tagCount > 0;
    final label = switch ((mood, tagCount)) {
      (null, 0) => 'Mood & tags',
      (null, _) => '$tagCount tag${tagCount == 1 ? '' : 's'}',
      (final m?, 0) => m.label,
      (final m?, _) => '${m.label} · $tagCount',
    };

    return Semantics(
      button: true,
      label: 'Mood and tags',
      child: Material(
        color: hasContext && mood != null
            ? mood!.color.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: AppRadius.circular,
        child: InkWell(
          borderRadius: AppRadius.circular,
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.circular,
              border: hasContext && mood != null
                  ? null
                  : Border.all(color: palette.border),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm - 1,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (mood != null)
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: mood!.gradient,
                        ),
                      ),
                    )
                  else
                    Icon(LucideIcons.plus, size: 12, color: palette.textSubtle),
                  const SizedBox(width: AppSpacing.sm - 2),
                  Text(
                    label,
                    style: AppTypography.caption.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: mood?.color ?? palette.textMuted,
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

/// Appears only once the writing has enough substance to reflect on.
class _ReflectChip extends StatelessWidget {
  const _ReflectChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Reflect on this entry',
      child: Material(
        color: AppColors.tintBlue,
        borderRadius: AppRadius.circular,
        child: InkWell(
          borderRadius: AppRadius.circular,
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm - 1,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.sparkles, size: 12, color: AppColors.primary),
                SizedBox(width: AppSpacing.xs + 1),
                Text(
                  'Reflect',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 400.ms,
          curve: Curves.easeOutBack,
        )
        .shimmer(delay: 500.ms, duration: 1200.ms, color: Colors.white54);
  }
}

class _MicButton extends StatelessWidget {
  const _MicButton({
    required this.palette,
    required this.isListening,
    required this.onTap,
  });

  final JournalPalette palette;
  final bool isListening;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: isListening ? 'Stop dictation' : 'Dictate entry',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: SizedBox(
          width: 44,
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isListening)
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.sosStart.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.5, 1.5),
                      duration: 1.seconds,
                    )
                    .fadeOut(duration: 1.seconds),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isListening
                      ? AppColors.sosStart
                      : palette.textSubtle.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isListening ? LucideIcons.square : LucideIcons.mic,
                  size: 15,
                  color: isListening ? Colors.white : palette.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
