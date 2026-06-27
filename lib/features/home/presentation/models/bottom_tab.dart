import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum BottomTab {
  home     (LucideIcons.home,      'Home'),
  journal  (LucideIcons.bookOpen,  'Journal'),
  meditate (LucideIcons.cloudSun,  'Meditate'),
  community(LucideIcons.users,     'Community'),
  profile  (LucideIcons.user,      'Profile');

  final IconData icon;
  final String label;

  const BottomTab(this.icon, this.label);
}