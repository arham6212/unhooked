import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/post.dart';
import 'avatar_widget.dart';

// ═══════════════════════════════════════════════════════════════
//  Exact YouTube Comments Style
//  Adapted for NoFap Community (Minimal, Flat, Compact)
// ═══════════════════════════════════════════════════════════════

// ── Tokens (Based on YouTube Web & Mobile spacing) ─────────────
const double _kAvatarSz  = 32.0;   // Strict 32px
const double _kAvatarGap = 12.0;   // Space between avatar and content
const double _kPadH      = 16.0;   // Side margins
const double _kPadV      = 12.0;   // Top/bottom margins per item

// Typography — Strict YouTube Comment Scale
const double _kNameSz    = 13.0;   // Bold
const double _kMetaSz    = 12.0;   // Regular, muted
const double _kTitleSz   = 14.0;   // Bold body
const double _kBodySz    = 14.0;   // Regular body
const double _kTagSz     = 11.0;
const double _kActionSz  = 12.0;

// Colors — Strict YouTube Neutrals
const Color _cName       = Color(0xFF0F0F0F);   // Solid dark
const Color _cMeta       = Color(0xFF606060);   // YT Gray
const Color _cBody       = Color(0xFF0F0F0F);   // Text color
const Color _cReadMore   = Color(0xFF606060);   // YT Read more is gray
const Color _cActionIcon = Color(0xFF0F0F0F);   // Default icon
const Color _cActionText = Color(0xFF606060);   // Action counts
const Color _cHairline   = Color(0x1F000000);   // 12% black divider

// Active accent colors
const Color _cLikeActive = Color(0xFF0F0F0F);   // Filled black

// ── Tag catalogue ───────────────────────────────────────────────
class _Tag {
  final String label;
  final Color dot; 
  const _Tag(this.label, this.dot);
}

const _kTags = <_Tag>[
  _Tag('Motivation', Color(0xFF6366F1)),
  _Tag('Struggling', Color(0xFFE11D48)),
  _Tag('Winning',    Color(0xFF16A34A)),
  _Tag('Relapse',    Color(0xFFD97706)),
  _Tag('Question',   Color(0xFF0284C7)),
  _Tag('Milestone',  Color(0xFF9333EA)),
];

// ═══════════════════════════════════════════════════════════════
//  _ActionIcon — YouTube-style action (minimal tap zone)
// ═══════════════════════════════════════════════════════════════
class _ActionIcon extends StatefulWidget {
  const _ActionIcon({
    required this.icon,
    required this.activeIcon,
    this.label,
    this.count,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String? label; 
  final int? count;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_ActionIcon> createState() => _ActionIconState();
}

class _ActionIconState extends State<_ActionIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0, upperBound: 1,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _tap() {
    HapticFeedback.selectionClick();
    _ctrl.forward().then((_) => _ctrl.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) =>
              Transform.scale(scale: _scale.value, child: child),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isActive ? widget.activeIcon : widget.icon,
                key: ValueKey(widget.isActive),
                size: 16,
                color: widget.isActive ? _cLikeActive : _cActionIcon,
              ),
              if (widget.label != null) ...[
                const SizedBox(width: 6),
                Text(
                  widget.label!,
                  style: const TextStyle(
                    fontSize: _kActionSz,
                    fontWeight: FontWeight.w500,
                    color: _cActionText,
                    height: 1.0,
                  ),
                ),
              ] else if ((widget.count ?? 0) > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '${widget.count}',
                  style: const TextStyle(
                    fontSize: _kActionSz,
                    fontWeight: FontWeight.w400,
                    color: _cActionText,
                    height: 1.0,
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

// ═══════════════════════════════════════════════════════════════
//  _PostMenu — minimal 3-dot, aligned top right
// ═══════════════════════════════════════════════════════════════
class _PostMenu extends StatelessWidget {
  const _PostMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      icon: const Icon(Icons.more_vert_rounded, size: 16, color: _cActionIcon),
      onSelected: (_) {},
      itemBuilder: (_) => [
        _item(Icons.flag_outlined,           'Report'),
        _item(Icons.visibility_off_outlined, 'Hide'),
        _item(Icons.link_rounded,            'Copy link'),
      ],
    );
  }

  PopupMenuItem<String> _item(IconData ic, String txt) => PopupMenuItem(
    value: txt,
    height: 40,
    child: Row(children: [
      Icon(ic, size: 18, color: _cActionIcon),
      const SizedBox(width: 12),
      Text(txt, style: const TextStyle(fontSize: 14, color: _cBody)),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
//  PostCard — Exact YouTube layout
// ═══════════════════════════════════════════════════════════════
class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.post, this.isDetail = false});
  final Post post;
  final bool isDetail;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _liked    = false;
  bool _expanded = false;

  static const int _truncAt = 220;

  Color get _avatarColor => kColorAvatarPalette[
      widget.post.userId.hashCode.abs() % kColorAvatarPalette.length];

  String get _initial =>
      widget.post.userId.isEmpty ? '?' : widget.post.userId[0].toUpperCase();

  String get _ago {
    final d = DateTime.now().difference(widget.post.createdAt);
    if (d.inSeconds < 60)  return 'now';
    if (d.inMinutes < 60)  return '${d.inMinutes} minutes ago';
    if (d.inHours < 24)    return '${d.inHours} hours ago';
    if (d.inDays < 7)      return '${d.inDays} days ago';
    return '${(d.inDays / 7).floor()} weeks ago';
  }

  int get _streak => (widget.post.userId.hashCode.abs() % 90) + 1;

  _Tag? get _tag {
    final i = widget.post.body.hashCode.abs() % (_kTags.length + 2);
    return i < _kTags.length ? _kTags[i] : null;
  }

  int get _likes => widget.post.likesCount + (_liked ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    final title = (widget.post.title?.isNotEmpty ?? false)
        ? widget.post.title!
        : null;
    final raw  = widget.post.body;
    final long = raw.length > _truncAt;
    final body = (long && !_expanded)
        ? '${raw.substring(0, _truncAt)}...'
        : raw;
    final tag  = _tag;

    return InkWell(
      onTap: widget.isDetail ? null : () => context.push('/community/post/${widget.post.id}', extra: widget.post),
      splashColor: Colors.black.withValues(alpha: 0.05),
      highlightColor: Colors.black.withValues(alpha: 0.05),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(_kPadH, _kPadV, _kPadH, _kPadV),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 1. Avatar (Left Column)
                  Avatar(
                    initial: _initial,
                    color: _avatarColor,
                    size: _kAvatarSz,
                  ),

                  const SizedBox(width: _kAvatarGap),

                  // 2. Content (Right Column)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row: Username + Meta + Menu
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1), // Align with avatar center visually
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: '@anonymous   ',
                                        style: TextStyle(
                                          fontSize: _kNameSz,
                                          fontWeight: FontWeight.w600,
                                          color: _cName,
                                        ),
                                      ),
                                      // Extremely subtle streak & time
                                      TextSpan(
                                        text: '🔥 Day $_streak   •   $_ago',
                                        style: const TextStyle(
                                          fontSize: _kMetaSz,
                                          fontWeight: FontWeight.w400,
                                          color: _cMeta,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // 3 Dots Menu
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: _PostMenu(),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Body Content
                        if (title != null) ...[
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: _kTitleSz,
                              fontWeight: FontWeight.w600,
                              color: _cBody,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],

                        Text(
                          body,
                          style: const TextStyle(
                            fontSize: _kBodySz,
                            fontWeight: FontWeight.w400,
                            color: _cBody,
                            height: 1.4,
                          ),
                        ),

                        // Read more inline
                        if (long) ...[
                          const SizedBox(height: 2),
                          GestureDetector(
                            onTap: () => setState(() => _expanded = !_expanded),
                            child: Text(
                              _expanded ? 'Show less' : 'Read more',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: _cReadMore,
                              ),
                            ),
                          ),
                        ],

                        // Subtler Tag (Notion / YT blend)
                        if (tag != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: tag.dot.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tag.label,
                                style: const TextStyle(
                                  fontSize: _kTagSz,
                                  fontWeight: FontWeight.w400,
                                  color: _cMeta,
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 8),

                        // Action Row (Spacing perfectly tight)
                        Row(
                          children: [
                            _ActionIcon(
                              icon: Icons.thumb_up_alt_outlined,
                              activeIcon: Icons.thumb_up_alt,
                              count: _likes,
                              isActive: _liked,
                              onTap: () => setState(() => _liked = !_liked),
                            ),
                            const SizedBox(width: 16),

                            _ActionIcon(
                              icon: Icons.chat_bubble_outline,
                              activeIcon: Icons.chat_bubble,
                              count: widget.post.commentsCount,
                              isActive: false,
                              onTap: widget.isDetail ? () {} : () => context.push('/community/post/${widget.post.id}', extra: widget.post),
                            ),
                            const SizedBox(width: 16),

                            _ActionIcon(
                              icon: Icons.ios_share_outlined,
                              activeIcon: Icons.ios_share,
                              label: null,
                              isActive: false,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Hairline Divider (Indented to match YouTube layout)
            const Divider(
              height: 1,
              thickness: 0.5,
              color: _cHairline,
              indent: _kAvatarSz + _kAvatarGap + _kPadH, // Lines up exactly with content
              endIndent: _kPadH,
            ),
          ],
        ),
      ),
    );
  }
}