import 'package:flutter/material.dart';

import '../../../../core/design_system/tokens/app_colors.dart';

/// Anonymous-but-human identity derived deterministically from a user id.
/// The same person always shows up as the same name and color — familiar
/// faces without ever revealing anyone.
class CommunityIdentity {
  final String name;
  final String initials;
  final Color color;

  const CommunityIdentity({
    required this.name,
    required this.initials,
    required this.color,
  });

  static const _adjectives = [
    'Quiet', 'Steady', 'Bright', 'Patient', 'Gentle', 'Honest', 'Brave',
    'Calm', 'Early', 'Kind', 'Wandering', 'Rising', 'Mindful', 'Grounded',
    'Hopeful', 'Warm', 'Clear', 'Humble', 'Still', 'Bold',
  ];

  static const _nouns = [
    'River', 'Oak', 'Summit', 'Harbor', 'Cedar', 'Meadow', 'Ember', 'Trail',
    'Compass', 'Lantern', 'Willow', 'Falcon', 'Stone', 'Aspen', 'Horizon',
    'Juniper', 'Reed', 'Fern', 'Maple', 'Anchor',
  ];

  factory CommunityIdentity.fromUserId(String userId) {
    final hash = userId.hashCode.abs();
    final adjective = _adjectives[hash % _adjectives.length];
    final noun = _nouns[(hash ~/ _adjectives.length) % _nouns.length];
    return CommunityIdentity(
      name: '$adjective $noun',
      initials: '${adjective[0]}${noun[0]}',
      color: AppColors.avatarPalette[hash % AppColors.avatarPalette.length],
    );
  }

  /// Consistent (mock) streak day for a user until real streaks are wired up.
  static int streakDayFor(String userId) => (userId.hashCode.abs() % 90) + 1;
}
