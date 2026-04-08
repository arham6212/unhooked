import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/post.dart';
import 'action_button.dart';
import 'avatar_widget.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  Color get _avatarColor {
    return kColorAvatarPalette[
        post.userId.hashCode.abs() % kColorAvatarPalette.length];
  }

  String get _avatarInitial {
    final id = post.userId;
    return id.isEmpty ? '?' : id[0].toUpperCase();
  }

  String get _timeAgo {
    final diff = DateTime.now().difference(post.createdAt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle =
        post.title != null && post.title!.isNotEmpty ? post.title! : null;

    return InkWell(
      onTap: (){
        context.push('/community/post/2');
      },
      child: Container(
        decoration: BoxDecoration(
          color: kColorCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (displayTitle != null) ...[
                    Text(
                      displayTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: kColorTextPrimary,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      Avatar(
                        initial: _avatarInitial,
                        color: _avatarColor,
                        size: 22,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Anonymous',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kColorTextPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _timeAgo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: kColorTextMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.body,
                    style: const TextStyle(
                      fontSize: 14,
                      color: kColorTextBody,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: kColorDivider, height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  ActionBtn(
                    icon: Icons.thumb_up_alt_outlined,
                    label: '${post.likesCount}',
                    onTap: () {},
                  ),
                  ActionBtn(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: '${post.commentsCount}',
                    onTap: () {},
                  ),
                  ActionBtn(
                    icon: Icons.reply_rounded,
                    label: 'Share',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
