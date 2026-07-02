import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/post.dart';
import '../providers/posts_provider.dart';
import '../styles/community_palette.dart';
import '../utils/community_identity.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/post_card_widget.dart';

class PostDetailsPage extends ConsumerStatefulWidget {
  const PostDetailsPage({super.key, required this.postId, this.post});

  final String postId;
  final Post? post;

  @override
  ConsumerState<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends ConsumerState<PostDetailsPage> {
  final _replyController = TextEditingController();
  bool _canSend = false;
  late final List<Post> _replies;

  @override
  void initState() {
    super.initState();
    _replyController.addListener(() {
      final can = _replyController.text.trim().isNotEmpty;
      if (can != _canSend) setState(() => _canSend = can);
    });
    // Mock replies until a comments table exists.
    _replies = [
      Post(
        id: 'reply1',
        userId: 'user_a',
        body: 'Keep going! Every single day makes you stronger.',
        likesCount: 12,
        commentsCount: 0,
        createdAt: DateTime.now().subtract(const Duration(minutes: 42)),
      ),
      Post(
        id: 'reply2',
        userId: 'user_b',
        body: 'I relate to this so much, staying strong with you.',
        likesCount: 4,
        commentsCount: 0,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Post(
        id: 'reply3',
        userId: 'user_c',
        body: 'This community has your back. Don\'t hesitate to reach out if it gets hard!',
        likesCount: 1,
        commentsCount: 0,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _sendReply() {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    final myId =
        ref.read(supabaseClientProvider).auth.currentUser?.id ?? 'me-local';
    setState(() {
      _replies.add(
        Post(
          id: 'local-${DateTime.now().microsecondsSinceEpoch}',
          userId: myId,
          body: text,
          likesCount: 0,
          commentsCount: 0,
          createdAt: DateTime.now(),
        ),
      );
      _replyController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = CommunityPalette.of(context);
    final post = widget.post;

    if (post == null) {
      return Scaffold(
        backgroundColor: palette.background,
        appBar: AppBar(
          backgroundColor: palette.background,
          elevation: 0,
          iconTheme: IconThemeData(color: palette.textPrimary),
        ),
        body: Center(
          child: Text(
            'This post is no longer here.',
            style: AppTypography.bodyMedium.copyWith(color: palette.textMuted),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        title: Text(
          'Thread',
          style: AppTypography.heading3.copyWith(color: palette.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: palette.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: palette.textPrimary),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg + AppSpacing.xs,
                AppSpacing.xs,
                AppSpacing.lg + AppSpacing.xs,
                AppSpacing.xl,
              ),
              children: [
                PostCard(post: post, isDetail: true),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Text(
                      'REPLIES',
                      style: AppTypography.label.copyWith(color: palette.textSubtle),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tintBlue,
                        borderRadius: AppRadius.circular,
                      ),
                      child: Text(
                        '${_replies.length}',
                        style: AppTypography.caption.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                for (final (i, reply) in _replies.indexed)
                  _ReplyTile(
                    reply: reply,
                    isLast: i == _replies.length - 1,
                    palette: palette,
                  ),
              ],
            ),
          ),
          _ReplyInput(
            palette: palette,
            controller: _replyController,
            canSend: _canSend,
            onSend: _sendReply,
          ),
        ],
      ),
    );
  }
}

/// A reply hanging off the thread line — small avatar, name, words.
class _ReplyTile extends StatelessWidget {
  const _ReplyTile({
    required this.reply,
    required this.isLast,
    required this.palette,
  });

  final Post reply;
  final bool isLast;
  final CommunityPalette palette;

  String get _ago {
    final d = DateTime.now().difference(reply.createdAt);
    if (d.inSeconds < 60) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    final identity = CommunityIdentity.fromUserId(reply.userId);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Thread spine.
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Avatar(initial: identity.initials, color: identity.color, size: 28),
                if (!isLast)
                  Expanded(
                    child: VerticalDivider(
                      width: 1,
                      thickness: 1.5,
                      color: palette.divider,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          identity.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '  ·  $_ago',
                        style: AppTypography.caption.copyWith(
                          fontSize: 11.5,
                          color: palette.textSubtle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    reply.body,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 14,
                      height: 1.5,
                      color: palette.textBody,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _ReplyInput extends StatelessWidget {
  const _ReplyInput({
    required this.palette,
    required this.controller,
    required this.canSend,
    required this.onSend,
  });

  final CommunityPalette palette;
  final TextEditingController controller;
  final bool canSend;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final paddingBottom =
        bottomInset > 0 ? 10.0 : MediaQuery.of(context).padding.bottom + 10.0;

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.divider)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.md,
        paddingBottom,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: palette.background,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: palette.border),
              ),
              child: TextField(
                controller: controller,
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 14.5,
                  color: palette.textPrimary,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Add a kind word…',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    fontSize: 14.5,
                    color: palette.textSubtle,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Semantics(
            button: true,
            label: 'Send reply',
            child: AnimatedScale(
              scale: canSend ? 1 : 0.92,
              duration: const Duration(milliseconds: 180),
              child: Material(
                color: canSend ? AppColors.primary : palette.divider,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: canSend ? onSend : null,
                  child: SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(
                      LucideIcons.send,
                      size: 17,
                      color: canSend ? AppColors.onPrimary : palette.textSubtle,
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
