import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import '../widgets/post_card_widget.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';

class PostDetailsPage extends StatefulWidget {
  final String postId;
  final Post? post;

  const PostDetailsPage({super.key, required this.postId, this.post});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  // Mocking replies to instantly match the visual design goal
  late final List<Post> _mockReplies;

  @override
  void initState() {
    super.initState();
    _mockReplies = [
      Post(
        id: 'reply1',
        userId: 'user_a',
        body: 'Keep going! Every single day makes you stronger. 💪',
        likesCount: 12,
        commentsCount: 0,
        createdAt: DateTime.now().subtract(const Duration(minutes: 42)),
      ),
      Post(
        id: 'reply2',
        userId: 'user_b',
        body: 'I relate to this so much man, staying strong with you.',
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
  Widget build(BuildContext context) {
    if (widget.post == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text("Post not found")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Replies',
          style: AppTypography.heading3.copyWith(
            color: AppColors.textPrimary, 
            fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.textMuted.withValues(alpha: 0.12),
            height: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Top-Level Comment (The Post)
                PostCard(post: widget.post!, isDetail: true),
                
                // Replies (Indented directly matching YouTube UI)
                ..._mockReplies.map((reply) => Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.xxl),
                      child: PostCard(post: reply, isDetail: true),
                    )),
              ],
            ),
          ),
          
          // YouTube Style Bottom Input
          _buildReplyInput(),
        ],
      ),
    );
  }

  Widget _buildReplyInput() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final paddingBottom = bottomInset > 0 ? 10.0 : MediaQuery.of(context).padding.bottom + 10.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.textMuted.withValues(alpha: 0.12), width: 1.0)),
      ),
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.sm, paddingBottom),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Text(
                'Y', 
                style: AppTypography.bodyMedium.copyWith(color: AppColors.onPrimary),
              ), 
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(18),
              ),
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Add a reply...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                ),
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                maxLines: 4,
                minLines: 1,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded, 
                color: AppColors.textPrimary,
                size: 24
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
