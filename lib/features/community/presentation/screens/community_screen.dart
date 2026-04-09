import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/posts_provider.dart';
import '../widgets/error_view.dart';
import '../widgets/new_post_sheet.dart';
import '../widgets/post_list_widget.dart';

// ─────────────────────────────────────────────────────────────
//  Feed filter options
// ─────────────────────────────────────────────────────────────
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
      backgroundColor: const Color(0xFFF4F2EF),
      body: Container(
        // Subtle warm gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F5F2), Color(0xFFEFEDEA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NewPostSheet(),
    );
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

// ─────────────────────────────────────────────────────────────
//  Header section
// ─────────────────────────────────────────────────────────────
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
                  children: const [
                    Text(
                      'Community',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: kColorTextPrimary,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Connect, share & grow together',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: kColorTextMuted,
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

        // ── Filter tabs ────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────
//  Filter chip
// ─────────────────────────────────────────────────────────────
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
          color: isActive ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? Colors.transparent : const Color(0xFFE2E8F0),
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
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Header icon button
// ─────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────
//  Gradient FAB
// ─────────────────────────────────────────────────────────────
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
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.40),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Create Post',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
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
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Search bottom sheet
// ─────────────────────────────────────────────────────────────
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
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const Text(
            'Search Community',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: kColorTextPrimary,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            autofocus: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded,
                  color: Color(0xFF94A3B8)),
              hintText: 'Search posts, topics…',
              hintStyle: const TextStyle(
                  color: Color(0xFFCBD5E1), fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Popular Tags',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kColorTextMuted,
            ),
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
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF475569),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}