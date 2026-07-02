import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../providers/posts_provider.dart';
import '../styles/community_palette.dart';
import '../utils/community_identity.dart';
import '../utils/community_topics.dart';
import '../widgets/avatar_widget.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _submitting = false;
  bool _canPost = false;
  CommunityTopic? _topic;

  @override
  void initState() {
    super.initState();
    _bodyController.addListener(() {
      final can = _bodyController.text.trim().isNotEmpty;
      if (can != _canPost) setState(() => _canPost = can);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final body = _bodyController.text.trim();
    if (body.isEmpty || _submitting) return;

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
            content: Text('Couldn\'t share your post: $e'),
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
    final palette = CommunityPalette.of(context);
    final myId = ref.watch(supabaseClientProvider).auth.currentUser?.id ?? 'me';
    final identity = CommunityIdentity.fromUserId(myId);

    return Scaffold(
      backgroundColor: palette.surface,
      appBar: AppBar(
        backgroundColor: palette.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: _submitting ? null : () => context.pop(),
          tooltip: 'Discard',
          icon: Icon(LucideIcons.x, size: 20, color: palette.textMuted),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Center(
              child: _PostButton(
                enabled: _canPost && !_submitting,
                submitting: _submitting,
                onTap: _submit,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _IdentityBanner(palette: palette, identity: identity),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.lg,
                  AppSpacing.xl,
                  AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      style: AppTypography.heading2.copyWith(
                        color: palette.textPrimary,
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Title (optional)',
                        hintStyle: AppTypography.heading2.copyWith(
                          color: palette.textSubtle,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _bodyController,
                      autofocus: true,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 16,
                        height: 1.6,
                        color: palette.textPrimary,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        hintText:
                            'Say it how it is — a win, a rough patch, a question…',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          fontSize: 16,
                          color: palette.textSubtle,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _TopicToolbar(
              palette: palette,
              selected: _topic,
              onChanged: (t) => setState(() => _topic = t),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reminds the writer they're safe here — and gives their anonymous
/// identity a face before they speak.
class _IdentityBanner extends StatelessWidget {
  const _IdentityBanner({required this.palette, required this.identity});

  final CommunityPalette palette;
  final CommunityIdentity identity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: identity.color.withValues(alpha: 0.07),
          borderRadius: AppRadius.medium,
        ),
        child: Row(
          children: [
            Avatar(initial: identity.initials, color: identity.color, size: 28),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: 'Posting as ',
                  style: AppTypography.caption.copyWith(
                    fontSize: 12.5,
                    color: palette.textMuted,
                  ),
                  children: [
                    TextSpan(
                      text: identity.name,
                      style: AppTypography.caption.copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: ' — always anonymous',
                      style: AppTypography.caption.copyWith(
                        fontSize: 12.5,
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(LucideIcons.lock, size: 13, color: palette.textSubtle),
          ],
        ),
      ),
    );
  }
}

class _PostButton extends StatelessWidget {
  const _PostButton({
    required this.enabled,
    required this.submitting,
    required this.onTap,
  });

  final bool enabled;
  final bool submitting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled || submitting ? 1 : 0.45,
      child: Material(
        color: AppColors.primary,
        borderRadius: AppRadius.circular,
        child: InkWell(
          borderRadius: AppRadius.circular,
          onTap: enabled
              ? () {
                  HapticFeedback.lightImpact();
                  onTap();
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg + AppSpacing.xs,
              vertical: AppSpacing.sm + 1,
            ),
            child: submitting
                ? const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.onPrimary),
                    ),
                  )
                : Text(
                    'Share',
                    style: AppTypography.button.copyWith(
                      fontSize: 14,
                      color: AppColors.onPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Topic picker above the keyboard. Client-side only for now — the posts
/// table has no topic column yet; the feed classifies from text.
class _TopicToolbar extends StatelessWidget {
  const _TopicToolbar({
    required this.palette,
    required this.selected,
    required this.onChanged,
  });

  final CommunityPalette palette;
  final CommunityTopic? selected;
  final ValueChanged<CommunityTopic?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.divider)),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              'WHAT KIND OF POST IS THIS?',
              style: AppTypography.label.copyWith(color: palette.textSubtle),
            ),
          ),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xxs),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              children: [
                for (final topic in CommunityTopic.values)
                  if (topic != CommunityTopic.story)
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onChanged(selected == topic ? null : topic);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: AppSpacing.sm),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md + 2,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected == topic
                              ? topic.background
                              : Colors.transparent,
                          borderRadius: AppRadius.circular,
                          border: Border.all(
                            color: selected == topic
                                ? topic.color.withValues(alpha: 0.35)
                                : palette.border,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: topic.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm - 2),
                            Text(
                              topic.label,
                              style: AppTypography.caption.copyWith(
                                fontSize: 12.5,
                                fontWeight: selected == topic
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected == topic
                                    ? topic.color
                                    : palette.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
