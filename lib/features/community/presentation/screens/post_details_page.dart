import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import '../widgets/post_card_widget.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PostDetailsPage extends StatefulWidget {
  final String postId;
  final Post? post;

  const PostDetailsPage({super.key, required this.postId, this.post});

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
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
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundDark : AppColors.background,
        body: const Center(child: Text("Post not found")),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        title: Text(
          'Discussion',
          style: AppTypography.heading3.copyWith(
            color: isDark ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: isDark ? AppColors.borderDark : AppColors.textMuted.withValues(alpha: 0.12),
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
                
                // Replies
                ..._mockReplies.map((reply) => Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.xl),
                      child: PostCard(post: reply, isDetail: true),
                    )),
              ],
            ),
          ),
          
          _buildReplyInput(isDark),
        ],
      ),
    );
  }

  Widget _buildReplyInput(bool isDark) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final paddingBottom = bottomInset > 0 ? 10.0 : MediaQuery.of(context).padding.bottom + 10.0;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.border, width: 1.0)),
      ),
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.sm, paddingBottom),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: CircleAvatar(
              radius: 18,
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
                color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
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
                style: AppTypography.bodyMedium.copyWith(color: isDark ? Colors.white : AppColors.textPrimary),
                maxLines: 4,
                minLines: 1,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  LucideIcons.send, 
                  color: AppColors.onPrimary,
                  size: 18
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
