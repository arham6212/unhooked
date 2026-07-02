import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/post.dart';
import '../styles/community_palette.dart';
import '../utils/community_identity.dart';
import '../utils/community_topics.dart';
import 'avatar_widget.dart';

const _heartColor = Color(0xFFE11D48); // rose — warmer than a thumbs-up

/// A voice in the circle: anonymous name, streak, topic, words, support.
class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.post, this.isDetail = false});

  final Post post;
  final bool isDetail;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _hearted = false;
  bool _expanded = false;

  static const _truncAt = 240;

  String get _ago {
    final d = DateTime.now().difference(widget.post.createdAt);
    if (d.inSeconds < 60) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    if (d.inDays < 7) return '${d.inDays}d';
    return '${(d.inDays / 7).floor()}w';
  }

  void _openDetails() {
    context.push('/community/post/${widget.post.id}', extra: widget.post);
  }

  @override
  Widget build(BuildContext context) {
    final palette = CommunityPalette.of(context);
    final identity = CommunityIdentity.fromUserId(widget.post.userId);
    final topic = topicForPost(widget.post);
    final streakDay = CommunityIdentity.streakDayFor(widget.post.userId);

    final title = (widget.post.title?.isNotEmpty ?? false) ? widget.post.title : null;
    final raw = widget.post.body.trim();
    final long = !widget.isDetail && raw.length > _truncAt;
    final body = long && !_expanded ? '${raw.substring(0, _truncAt).trimRight()}…' : raw;

    return Semantics(
      button: !widget.isDetail,
      label: 'Post by ${identity.name}',
      child: Material(
        color: palette.surface,
        borderRadius: AppRadius.large,
        child: InkWell(
          borderRadius: AppRadius.large,
          onTap: widget.isDetail ? null : _openDetails,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.large,
              border: Border.all(color: palette.border),
              boxShadow: AppShadows.sm,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Identity row ────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Avatar(
                        initial: identity.initials,
                        color: identity.color,
                        size: 38,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              identity.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: palette.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(LucideIcons.flame,
                                    size: 11, color: AppColors.warmAmber),
                                const SizedBox(width: 3),
                                Text(
                                  'Day $streakDay',
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.warmAmber,
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
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _TopicPill(topic: topic),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Words ───────────────────────────────────────
                  if (title != null) ...[
                    Text(
                      title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                  Text(
                    body,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 14.5,
                      height: 1.55,
                      color: palette.textBody,
                    ),
                  ),
                  if (long) ...[
                    const SizedBox(height: AppSpacing.xs),
                    GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: Text(
                        _expanded ? 'Show less' : 'Read more',
                        style: AppTypography.caption.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),

                  // ── Actions ─────────────────────────────────────
                  Row(
                    children: [
                      _ActionPill(
                        icon: LucideIcons.heart,
                        count: widget.post.likesCount + (_hearted ? 1 : 0),
                        active: _hearted,
                        activeColor: _heartColor,
                        activeBackground: const Color(0xFFFFF1F2),
                        palette: palette,
                        semanticLabel: _hearted ? 'Remove heart' : 'Send a heart',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() => _hearted = !_hearted);
                        },
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _ActionPill(
                        icon: LucideIcons.messageCircle,
                        count: widget.post.commentsCount,
                        active: false,
                        activeColor: AppColors.primary,
                        activeBackground: AppColors.tintBlue,
                        palette: palette,
                        semanticLabel: 'Replies',
                        onTap: widget.isDetail ? null : _openDetails,
                      ),
                      const Spacer(),
                      _PostMenu(palette: palette),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicPill extends StatelessWidget {
  const _TopicPill({required this.topic});

  final CommunityTopic topic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + AppSpacing.xxs,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: topic.background,
        borderRadius: AppRadius.circular,
      ),
      child: Text(
        topic.label,
        style: AppTypography.caption.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: topic.color,
        ),
      ),
    );
  }
}

/// Compact action with a springy pop on toggle; fills with flat color
/// when active.
class _ActionPill extends StatefulWidget {
  const _ActionPill({
    required this.icon,
    required this.count,
    required this.active,
    required this.activeColor,
    required this.activeBackground,
    required this.palette,
    required this.semanticLabel,
    required this.onTap,
  });

  final IconData icon;
  final int count;
  final bool active;
  final Color activeColor;
  final Color activeBackground;
  final CommunityPalette palette;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  State<_ActionPill> createState() => _ActionPillState();
}

class _ActionPillState extends State<_ActionPill>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  );
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 40),
    TweenSequenceItem(
      tween: Tween(begin: 1.25, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOutBack)),
      weight: 60,
    ),
  ]).animate(_ctrl);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap == null) return;
    _ctrl.forward(from: 0);
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.active ? widget.activeColor : widget.palette.textMuted;

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm - 1,
          ),
          decoration: BoxDecoration(
            color: widget.active ? widget.activeBackground : Colors.transparent,
            borderRadius: AppRadius.circular,
            border: Border.all(
              color: widget.active
                  ? widget.activeColor.withValues(alpha: 0.25)
                  : widget.palette.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _scale,
                child: Icon(widget.icon, size: 14, color: color),
              ),
              if (widget.count > 0) ...[
                const SizedBox(width: AppSpacing.xs + 1),
                Text(
                  '${widget.count}',
                  style: AppTypography.caption.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PostMenu extends StatelessWidget {
  const _PostMenu({required this.palette});

  final CommunityPalette palette;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: palette.surface,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      icon: Icon(LucideIcons.moreHorizontal, size: 16, color: palette.textSubtle),
      tooltip: 'Post options',
      onSelected: (_) {},
      itemBuilder: (_) => [
        _item(LucideIcons.flag, 'Report'),
        _item(LucideIcons.eyeOff, 'Hide'),
        _item(LucideIcons.link, 'Copy link'),
      ],
    );
  }

  PopupMenuItem<String> _item(IconData icon, String label) => PopupMenuItem(
        value: label,
        height: 40,
        child: Row(
          children: [
            Icon(icon, size: 16, color: palette.textMuted),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
      );
}
