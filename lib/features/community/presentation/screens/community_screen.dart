import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/components/app_text_field.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/post.dart';
import '../providers/posts_provider.dart';
import '../styles/community_palette.dart';
import '../utils/community_topics.dart';
import '../widgets/error_view.dart';
import '../widgets/post_list_widget.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  /// null means "All".
  CommunityTopic? _activeTopic;

  void _openCreate() => context.push('/community/create');

  void _openSearch() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SearchSheet(
        onTopicPicked: (topic) => setState(() => _activeTopic = topic),
      ),
    );
  }

  List<Post> _filtered(List<Post> posts) {
    final topic = _activeTopic;
    if (topic == null) return posts;
    return posts.where((p) => topicForPost(p) == topic).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final palette = CommunityPalette.of(context);
    final asyncPosts = ref.watch(postsProvider);

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              palette: palette,
              onCreate: _openCreate,
              onSearch: _openSearch,
            ),
            const SizedBox(height: AppSpacing.lg),
            _TopicChips(
              palette: palette,
              active: _activeTopic,
              onChanged: (topic) => setState(() => _activeTopic = topic),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: asyncPosts.when(
                loading: () => const _LoadingFeed(),
                error: (e, _) => ErrorView(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(postsProvider),
                ),
                data: (posts) {
                  final visible = _filtered(posts);
                  if (posts.isNotEmpty && visible.isEmpty) {
                    return _TopicEmpty(
                      palette: palette,
                      topic: _activeTopic!,
                      onShare: _openCreate,
                      onShowAll: () => setState(() => _activeTopic = null),
                    );
                  }
                  return PostList(
                    posts: visible,
                    onRefresh: () async => ref.invalidate(postsProvider),
                    onSayHello: _openCreate,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ──────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header({
    required this.palette,
    required this.onCreate,
    required this.onSearch,
  });

  final CommunityPalette palette;
  final VoidCallback onCreate;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg + AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.lg + AppSpacing.xs,
        0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HighlightedTitle(text: 'Community', palette: palette),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Anonymous voices, honest support.',
                  style: AppTypography.caption.copyWith(
                    fontSize: 13,
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: 'Share a post',
            child: Material(
              color: AppColors.primary,
              borderRadius: AppRadius.circular,
              child: InkWell(
                borderRadius: AppRadius.circular,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onCreate();
                },
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.circular,
                    boxShadow: AppShadows.primary(intensity: 0.7),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm + AppSpacing.xxs,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.plus, size: 15, color: AppColors.onPrimary),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          'Share',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xxs),
          Semantics(
            button: true,
            label: 'Search community',
            child: Material(
              color: palette.surface,
              shape: CircleBorder(side: BorderSide(color: palette.border)),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onSearch,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(LucideIcons.search, size: 18, color: palette.textMuted),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Community" with a marker-pen swipe under the word — a human touch,
/// no gradients required.
class _HighlightedTitle extends StatelessWidget {
  const _HighlightedTitle({required this.text, required this.palette});

  final String text;
  final CommunityPalette palette;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -3,
          right: -3,
          bottom: 2,
          height: 11,
          child: Transform.rotate(
            angle: -0.012,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F)
                    .withValues(alpha: isDark ? 0.28 : 0.45),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        Text(
          text,
          style: AppTypography.heading1.copyWith(
            fontSize: 28,
            color: palette.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Topic chips ─────────────────────────────────────────────────
class _TopicChips extends StatelessWidget {
  const _TopicChips({
    required this.palette,
    required this.active,
    required this.onChanged,
  });

  final CommunityPalette palette;
  final CommunityTopic? active;
  final ValueChanged<CommunityTopic?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + AppSpacing.xs,
        ),
        children: [
          _AllChip(
            palette: palette,
            isActive: active == null,
            onTap: () => onChanged(null),
          ),
          for (final topic in CommunityTopic.values)
            if (topic != CommunityTopic.story)
              _TopicChip(
                palette: palette,
                topic: topic,
                isActive: active == topic,
                onTap: () => onChanged(active == topic ? null : topic),
              ),
        ],
      ),
    );
  }
}

class _AllChip extends StatelessWidget {
  const _AllChip({
    required this.palette,
    required this.isActive,
    required this.onTap,
  });

  final CommunityPalette palette;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? palette.textPrimary : palette.surface,
          borderRadius: AppRadius.circular,
          border: Border.all(
            color: isActive ? Colors.transparent : palette.border,
          ),
        ),
        child: Text(
          'All',
          style: AppTypography.caption.copyWith(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isActive ? palette.surface : palette.textMuted,
          ),
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.palette,
    required this.topic,
    required this.isActive,
    required this.onTap,
  });

  final CommunityPalette palette;
  final CommunityTopic topic;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? topic.background : palette.surface,
          borderRadius: AppRadius.circular,
          border: Border.all(
            color: isActive ? topic.color.withValues(alpha: 0.35) : palette.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: topic.color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.sm - 2),
            Text(
              topic.label,
              style: AppTypography.caption.copyWith(
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? topic.color : palette.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Topic-filtered empty ────────────────────────────────────────
class _TopicEmpty extends StatelessWidget {
  const _TopicEmpty({
    required this.palette,
    required this.topic,
    required this.onShare,
    required this.onShowAll,
  });

  final CommunityPalette palette;
  final CommunityTopic topic;
  final VoidCallback onShare;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: topic.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration:
                      BoxDecoration(color: topic.color, shape: BoxShape.circle),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Nothing in ${topic.label} yet',
              style: AppTypography.heading3.copyWith(color: palette.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Yours could be the post that starts it.',
              style: AppTypography.bodyMedium.copyWith(color: palette.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: onShowAll,
                  child: Text(
                    'Show all',
                    style: AppTypography.button.copyWith(color: palette.textMuted),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                TextButton(
                  onPressed: onShare,
                  child: Text(
                    'Write one →',
                    style: AppTypography.button.copyWith(color: topic.color),
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }
}

// ── Loading feed (pulsing card skeletons) ───────────────────────
class _LoadingFeed extends StatelessWidget {
  const _LoadingFeed();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg + AppSpacing.xs,
        AppSpacing.xs,
        AppSpacing.lg + AppSpacing.xs,
        120,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, i) => const _SkeletonCard()
          .animate(delay: (120 * i).ms, onPlay: (c) => c.repeat(reverse: true))
          .fade(begin: 0.45, end: 1, duration: 750.ms, curve: Curves.easeInOut),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final palette = CommunityPalette.of(context);
    final block = palette.divider;

    Widget bar(double width, double height) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: block,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: AppRadius.large,
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: block,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bar(110, 12),
                  const SizedBox(height: AppSpacing.sm),
                  bar(70, 10),
                ],
              ),
              const Spacer(),
              bar(60, 20),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          bar(double.infinity, 12),
          const SizedBox(height: AppSpacing.sm),
          bar(double.infinity, 12),
          const SizedBox(height: AppSpacing.sm),
          bar(180, 12),
        ],
      ),
    );
  }
}

// ── Search sheet ────────────────────────────────────────────────
class _SearchSheet extends StatelessWidget {
  const _SearchSheet({required this.onTopicPicked});

  final ValueChanged<CommunityTopic> onTopicPicked;

  @override
  Widget build(BuildContext context) {
    final palette = CommunityPalette.of(context);

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.xl + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: palette.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Find a voice',
            style: AppTypography.heading3.copyWith(color: palette.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(
            autofocus: true,
            hintText: 'Search posts…',
            prefixIcon: Icon(LucideIcons.search),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'BROWSE TOPICS',
            style: AppTypography.label.copyWith(color: palette.textSubtle),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final topic in CommunityTopic.values)
                if (topic != CommunityTopic.story)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.of(context).pop();
                      onTopicPicked(topic);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md + 2,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: topic.background,
                        borderRadius: AppRadius.circular,
                      ),
                      child: Text(
                        topic.label,
                        style: AppTypography.caption.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: topic.color,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
