import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/posts_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/new_post_sheet.dart';
import '../widgets/post_list_widget.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(postsProvider);

    return Scaffold(
      backgroundColor: kColorBgCream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref),
            const SizedBox(height: 20),
            Expanded(
              child: asyncPosts.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => ErrorView(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(postsProvider),
                ),
                data: (posts) => PostList(
                  posts: posts,
                  onRefresh: () async => ref.invalidate(postsProvider),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(context, ref),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),
      child: Text(
        'Community',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: kColorTextPrimary,
          height: 1.1,
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () => _showNewPostSheet(context, ref),
      backgroundColor: kColorTextPrimary,
      foregroundColor: kColorOnPrimary,
      elevation: 4,
      icon: const Icon(Icons.edit_rounded, size: 18),
      label: const Text(
        'New Post',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  void _showNewPostSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NewPostSheet(),
    );
  }
}