import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/components/app_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/posts_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/post_list_widget.dart';


enum _FeedFilter { latest, trending, following }

extension _FeedFilterLabel on _FeedFilter {
  String get label {
    switch (this) {
      case _FeedFilter.latest:
        return 'Latest';
      case _FeedFilter.trending:
        return '🔥 Trending';
      case _FeedFilter.following:
        return 'Following';
    }
  }
}

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  _FeedFilter _activeFilter = _FeedFilter.latest;

  @override
  Widget build(BuildContext context) {
    final asyncPosts = ref.watch(postsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CommunityHeader(
                activeFilter: _activeFilter,
                onFilterChanged: (f) => setState(() => _activeFilter = f),
                onSearch: () => _showSearchSheet(context),
              ),
              Expanded(
                child: asyncPosts.when(
                  loading: () => const _LoadingState(),
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
      ),
      floatingActionButton: _GradientFab(
        onPressed: () => _showNewPostSheet(context),
      ),
    );
  }

  void _showNewPostSheet(BuildContext context) {
    context.push('/community/create');
  }

  void _showSearchSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SearchSheet(),
    );
  }
}


class _CommunityHeader extends StatelessWidget {
  const _CommunityHeader({
    required this.activeFilter,
    required this.onFilterChanged,
    required this.onSearch,
  });

  final _FeedFilter activeFilter;
  final ValueChanged<_FeedFilter> onFilterChanged;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title row ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 14, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Community',
                      style: AppTypography.heading1.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Connect, share & grow together',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Search icon button
              _IconBtn(
                icon: Icons.search_rounded,
                onTap: onSearch,
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),


        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            children: _FeedFilter.values.map((f) {
              final isActive = f == activeFilter;
              return _FilterChip(
                label: f.label,
                isActive: isActive,
                onTap: () => onFilterChanged(f),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.textPrimary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isActive ? Colors.transparent : AppColors.textMuted.withValues(alpha: 0.2),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: isActive ? AppColors.surface : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}


class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: kColorTextPrimary),
      ),
    );
  }
}


class _GradientFab extends StatefulWidget {
  const _GradientFab({required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<_GradientFab> createState() => _GradientFabState();
}

class _GradientFabState extends State<_GradientFab> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 130),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.40),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, color: AppColors.onPrimary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Create Post',
                style: AppTypography.button.copyWith(
                  color: AppColors.onPrimary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Loading state (shimmer-like)
// ─────────────────────────────────────────────────────────────
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 120),
      itemCount: 4,
      itemBuilder: (_, i) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + name row
            Row(
              children: [
                _Shimmer(width: 46, height: 46, radius: 23),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Shimmer(width: 120, height: 14, radius: 7),
                    const SizedBox(height: 8),
                    _Shimmer(width: 80, height: 12, radius: 6),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _Shimmer(width: double.infinity, height: 14, radius: 7),
            const SizedBox(height: 10),
            _Shimmer(width: 240, height: 14, radius: 7),
          ],
        ),
      ),
    );
  }
}

class _Shimmer extends StatelessWidget {
  const _Shimmer({
    required this.width,
    required this.height,
    required this.radius,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}


class _SearchSheet extends StatelessWidget {
  const _SearchSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Text(
            'Search Community',
            style: AppTypography.heading3.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(
            autofocus: true,
            hintText: 'Search posts, topics…',
            prefixIcon: Icon(Icons.search_rounded),
          ),
          const SizedBox(height: 16),
          const Text(
            'Popular Tags',
            style: AppTypography.caption,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              '#Day7', '#Motivation', '#Relapse', '#Winning',
              '#Struggling', '#Milestone', '#Progress',
            ].map((t) => _SearchTag(label: t)).toList(),
          ),
        ],
      ),
    );
  }
}

class _SearchTag extends StatelessWidget {
  const _SearchTag({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: AppTypography.caption,
      ),
    );
  }
}