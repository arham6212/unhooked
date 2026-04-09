import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/posts_provider.dart';

// ─────────────────────────────────────────────────────────────
//  Tag model
// ─────────────────────────────────────────────────────────────
class _Tag {
  final String label;
  final Color bgColor;
  final Color textColor;
  const _Tag(this.label, this.bgColor, this.textColor);
}

const _tags = <_Tag>[
  _Tag('Motivation', Color(0xFFEEF2FF), Color(0xFF4F46E5)),
  _Tag('Struggling', Color(0xFFFFF1F2), Color(0xFFE11D48)),
  _Tag('Winning',    Color(0xFFF0FDF4), Color(0xFF16A34A)),
  _Tag('Relapse',    Color(0xFFFFFBEB), Color(0xFFD97706)),
  _Tag('Question',   Color(0xFFF0F9FF), Color(0xFF0284C7)),
  _Tag('Milestone',  Color(0xFFFDF4FF), Color(0xFF9333EA)),
];

// ─────────────────────────────────────────────────────────────
//  Mood model
// ─────────────────────────────────────────────────────────────
class _Mood {
  final String emoji;
  final String label;
  const _Mood(this.emoji, this.label);
}

const _moods = <_Mood>[
  _Mood('😔', 'Struggling'),
  _Mood('😐', 'Neutral'),
  _Mood('😊', 'Good'),
  _Mood('😄', 'Great'),
];

// ─────────────────────────────────────────────────────────────
//  NewPostSheet
// ─────────────────────────────────────────────────────────────
class NewPostSheet extends ConsumerStatefulWidget {
  const NewPostSheet({super.key});

  @override
  ConsumerState<NewPostSheet> createState() => _NewPostSheetState();
}

class _NewPostSheetState extends ConsumerState<NewPostSheet> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _submitting = false;
  _Tag? _selectedTag;
  _Mood? _selectedMood;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final body = _bodyController.text.trim();
    if (body.isEmpty) return;

    setState(() => _submitting = true);
    try {
      await ref.read(createPostUseCaseProvider).execute(
            title: _titleController.text.trim(),
            body: body,
          );
      ref.invalidate(postsProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFE11D48),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle bar ─────────────────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // ── Title row ──────────────────────────────────────
          Row(
            children: [
              const Text(
                'Create Post',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: kColorTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 18, color: kColorTextMuted),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Title field ────────────────────────────────────
          TextField(
            controller: _titleController,
            style: const TextStyle(
                fontSize: 15, color: kColorTextPrimary),
            decoration: _inputDecoration('Title (optional)'),
          ),

          const SizedBox(height: 10),

          // ── Body field ─────────────────────────────────────
          TextField(
            controller: _bodyController,
            autofocus: true,
            maxLines: 4,
            style: const TextStyle(
                fontSize: 15, color: kColorTextPrimary),
            decoration: _inputDecoration(
                'Share your experience, milestone, or ask a question…'),
          ),

          const SizedBox(height: 16),

          // ── Mood selector ──────────────────────────────────
          const Text(
            'How are you feeling?',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kColorTextMuted,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _moods.map((m) {
                final isActive = _selectedMood == m;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedMood = isActive ? null : m),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF6366F1)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isActive
                            ? const Color(0xFF6366F1)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(m.emoji,
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 5),
                        Text(
                          m.label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 14),

          // ── Tag selector ───────────────────────────────────
          const Text(
            'Add a tag',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kColorTextMuted,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tags.map((t) {
              final isSelected = _selectedTag == t;
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedTag = isSelected ? null : t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? t.bgColor : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected
                          ? t.textColor.withValues(alpha: 0.4)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    t.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? t.textColor : const Color(0xFF64748B),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // ── Submit button ──────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: _submitting
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                color: _submitting ? const Color(0xFFE2E8F0) : null,
                borderRadius: BorderRadius.circular(16),
                boxShadow: _submitting
                    ? []
                    : [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Color(0xFF6366F1),
                        ),
                      )
                    : const Text(
                        'Publish Post',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(color: kColorTextMuted, fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
            color: Color(0xFF6366F1), width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
