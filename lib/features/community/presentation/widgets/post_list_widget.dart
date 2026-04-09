import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/post.dart';
import '../widgets/post_card_widget.dart';

class PostList extends StatelessWidget {
  const PostList({
    super.key,
    required this.posts,
    required this.onRefresh,
  });

  final List<Post> posts;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        color: const Color(0xFF6366F1),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
          children: const [
            SizedBox(height: 60),
            _EmptyState(),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: const Color(0xFF6366F1),
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
            gradient: const LinearGradient(
              colors: [Color(0xFFEEF2FF), Color(0xFFF5F3FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text('💬', style: TextStyle(fontSize: 44)),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Be the first to share something 💬',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kColorTextPrimary,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Your community is here for you.\nShare a milestone, ask a question,\nor just say how you\'re doing.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: kColorTextMuted,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
