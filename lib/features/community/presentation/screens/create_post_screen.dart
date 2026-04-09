import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/components/app_button.dart';
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
  _Tag('Motivation', AppColors.primaryLight, AppColors.primaryDark),
  _Tag('Struggling', AppColors.error, AppColors.surface),
  _Tag('Winning',    AppColors.success, AppColors.surface),
  _Tag('Relapse',    AppColors.error, AppColors.surface),
  _Tag('Question',   AppColors.primaryLight, AppColors.primaryDark),
  _Tag('Milestone',  AppColors.primaryLight, AppColors.primaryDark),
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
//  Full-Screen Create Post Screen
// ─────────────────────────────────────────────────────────────
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
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
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the body is empty to disable the post button
    final isBodyEmpty = _bodyController.text.trim().isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leadingWidth: 80,
        leading: Center(
          child: AppButton(
            text: 'Cancel',
            variant: AppButtonVariant.text,
            onPressed: () => _submitting ? null : context.pop(),
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: (isBodyEmpty && !_submitting) ? 0.5 : 1.0,
                child: AppButton(
                  text: 'Post',
                  isLoading: _submitting,
                  onPressed: (isBodyEmpty || _submitting) ? null : _submit,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Input - Notion style (large, bold)
                  TextField(
                    controller: _titleController,
                    style: AppTypography.heading1.copyWith(
                       color: AppColors.textPrimary,
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Title (optional)',
                      hintStyle: AppTypography.heading1.copyWith(color: AppColors.textMuted),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Body Input
                  TextField(
                    controller: _bodyController,
                    autofocus: true,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "What's on your mind? Share your progress...",
                      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Toolbar for Tags and Moods
          _buildToolbar(),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.backgroundLight)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Moods row
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _moods.map((m) {
                final isActive = _selectedMood == m;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = isActive ? null : m),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: isActive ? AppColors.primary : AppColors.textMuted.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(m.emoji, style: AppTypography.bodyMedium),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          m.label,
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isActive ? AppColors.onPrimary : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),

          // Tags row
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _tags.map((t) {
                final isSelected = _selectedTag == t;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTag = isSelected ? null : t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? t.bgColor : AppColors.backgroundLight,
                      borderRadius:BorderRadius.circular( AppRadius.pill),
                      border: Border.all(
                        color: isSelected
                            ? t.textColor.withValues(alpha: 0.4)
                            : AppColors.textMuted.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      t.label,
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? t.textColor : AppColors.textMuted,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
