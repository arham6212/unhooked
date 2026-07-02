import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../domain/entities/post.dart';

/// Flat, lively topic colors — tinted background + saturated foreground.
/// No gradients anywhere.
enum CommunityTopic { support, wins, milestones, questions, gratitude, story }

extension CommunityTopicX on CommunityTopic {
  String get label => switch (this) {
        CommunityTopic.support => 'Support',
        CommunityTopic.wins => 'Wins',
        CommunityTopic.milestones => 'Milestones',
        CommunityTopic.questions => 'Questions',
        CommunityTopic.gratitude => 'Gratitude',
        CommunityTopic.story => 'Story',
      };

  Color get color => switch (this) {
        CommunityTopic.support => const Color(0xFFE11D48), // rose
        CommunityTopic.wins => const Color(0xFF059669), // emerald
        CommunityTopic.milestones => const Color(0xFFD97706), // amber
        CommunityTopic.questions => const Color(0xFF7C3AED), // violet
        CommunityTopic.gratitude => const Color(0xFF0D9488), // teal
        CommunityTopic.story => AppColors.primary, // blue
      };

  Color get background => switch (this) {
        CommunityTopic.support => const Color(0xFFFFF1F2),
        CommunityTopic.wins => const Color(0xFFECFDF5),
        CommunityTopic.milestones => const Color(0xFFFEF3E2),
        CommunityTopic.questions => const Color(0xFFF3EEFF),
        CommunityTopic.gratitude => const Color(0xFFF0FDFA),
        CommunityTopic.story => AppColors.tintBlue,
      };
}

final _supportPattern = RegExp(
  r'\b(struggl|urge|craving|relapse|slipped|rough|hard time|help me|falling|tempted)',
  caseSensitive: false,
);
final _questionPattern = RegExp(
  r'\b(how do|how did|any advice|anyone else|any tips|what helps|question)',
  caseSensitive: false,
);
final _milestonePattern = RegExp(
  r'\b(day \d+|\d+ days|week \d+|\d+ weeks|\d+ months|milestone|streak|clean for)',
  caseSensitive: false,
);
final _winsPattern = RegExp(
  r'\b(win|won|proud|finally|did it|nailed|success|victor)',
  caseSensitive: false,
);
final _gratitudePattern = RegExp(
  r'\b(grateful|thankful|thank you|appreciate|blessed)',
  caseSensitive: false,
);

/// Best-effort topic classification from the post text. Posts don't carry a
/// topic column yet — when they do, read it and keep this as the fallback.
CommunityTopic topicForPost(Post post) {
  final text = '${post.title ?? ''} ${post.body}';
  if (_supportPattern.hasMatch(text)) return CommunityTopic.support;
  if (_questionPattern.hasMatch(text) || text.contains('?')) {
    return CommunityTopic.questions;
  }
  if (_milestonePattern.hasMatch(text)) return CommunityTopic.milestones;
  if (_winsPattern.hasMatch(text)) return CommunityTopic.wins;
  if (_gratitudePattern.hasMatch(text)) return CommunityTopic.gratitude;
  return CommunityTopic.story;
}
