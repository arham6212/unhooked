import 'package:flutter/material.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/post.dart';
import '../widgets/post_card_widget.dart';

class PostList extends StatelessWidget {
  const PostList({super.key, required this.posts, required this.onRefresh});

  final List<Post> posts;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        color: AppColors.primary,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
            120,
          ),
          children: const [SizedBox(height: 60), _EmptyState()],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      displacement: 60,
      child: ListView.builder(
        // Flat items own their internal padding — list stays edge-to-edge
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 120),
        itemCount: posts.length,
        itemBuilder: (context, i) => PostCard(post: posts[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Empty state
// ─────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Illustration placeholder
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.primary.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '💬',
              style: AppTypography.heading1.copyWith(fontSize: 44),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Be the first to share something 💬',
          textAlign: TextAlign.center,
          style: AppTypography.heading3.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Your community is here for you.\nShare a milestone, ask a question,\nor just say how you\'re doing.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}
