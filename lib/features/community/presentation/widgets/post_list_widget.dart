import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/post.dart';
import '../styles/community_palette.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/post_card_widget.dart';

class PostList extends StatelessWidget {
  const PostList({
    super.key,
    required this.posts,
    required this.onRefresh,
    this.onSayHello,
  });

  final List<Post> posts;
  final Future<void> Function() onRefresh;
  final VoidCallback? onSayHello;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        color: AppColors.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
            120,
          ),
          children: [
            const SizedBox(height: 40),
            _EmptyState(onSayHello: onSayHello),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      displacement: 50,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg + AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.lg + AppSpacing.xs,
          120,
        ),
        itemCount: posts.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, i) {
          final card = PostCard(post: posts[i]);
          // Stagger only the first screenful; further cards appear instantly.
          if (i > 5) return card;
          return card
              .animate(delay: (50 * i).ms)
              .fadeIn(duration: 350.ms, curve: Curves.easeOut)
              .slideY(
                begin: 0.03,
                end: 0,
                duration: 350.ms,
                curve: Curves.easeOutCubic,
              );
        },
      ),
    );
  }
}

/// No stock illustration, no emoji-in-a-circle: a small crowd of empty
/// chairs — avatar tiles waiting for their first voices.
class _EmptyState extends StatelessWidget {
  const _EmptyState({this.onSayHello});

  final VoidCallback? onSayHello;

  @override
  Widget build(BuildContext context) {
    final palette = CommunityPalette.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _AvatarCrowd(),
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'It\'s quiet in here',
          style: AppTypography.heading2.copyWith(color: palette.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Someone out there needs to read\nexactly what you\'d write.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: palette.textMuted,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Semantics(
          button: true,
          child: Material(
            color: AppColors.primary,
            borderRadius: AppRadius.circular,
            child: InkWell(
              borderRadius: AppRadius.circular,
              onTap: () {
                HapticFeedback.lightImpact();
                onSayHello?.call();
              },
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: AppRadius.circular,
                  boxShadow: AppShadows.primary(intensity: 0.8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md + AppSpacing.xxs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.megaphone,
                          size: 16, color: AppColors.onPrimary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Say hello',
                        style: AppTypography.button
                            .copyWith(color: AppColors.onPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 450.ms).slideY(
          begin: 0.03,
          end: 0,
          duration: 450.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _AvatarCrowd extends StatelessWidget {
  const _AvatarCrowd();

  @override
  Widget build(BuildContext context) {
    final palette = CommunityPalette.of(context);
    const tiles = [
      (letter: 'S', color: Color(0xFF3B82F6), dy: 10.0, angle: -0.10),
      (letter: 'R', color: Color(0xFF10B981), dy: -4.0, angle: 0.06),
      (letter: 'M', color: Color(0xFFFFC107), dy: 6.0, angle: -0.04),
      (letter: 'H', color: Color(0xFF8B5CF6), dy: -8.0, angle: 0.09),
      (letter: 'J', color: Color(0xFFEC4899), dy: 4.0, angle: -0.07),
    ];

    return SizedBox(
      height: 84,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final (i, tile) in tiles.indexed)
            Align(
              widthFactor: 0.78, // overlap the crowd
              child: Transform.translate(
                offset: Offset(0, tile.dy),
                child: Transform.rotate(
                  angle: tile.angle,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: palette.surface, width: 3),
                      boxShadow: AppShadows.sm,
                    ),
                    child: Avatar(
                      initial: tile.letter,
                      color: tile.color,
                      size: 46,
                    ),
                  ),
                ),
              ),
            )
                .animate(delay: (80 * i).ms)
                .fadeIn(duration: 350.ms)
                .scale(
                  begin: const Offset(0.7, 0.7),
                  end: const Offset(1, 1),
                  duration: 400.ms,
                  curve: Curves.easeOutBack,
                ),
        ],
      ),
    );
  }
}
