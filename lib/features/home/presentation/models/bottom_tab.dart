import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum BottomTab {
  home(LucideIcons.home, 'Home'),
  journal(LucideIcons.bookOpen, 'Journal'),
  community(LucideIcons.users, 'Community'),
  history(LucideIcons.history, 'History'),
  settings(LucideIcons.settings, 'Settings');

  final IconData icon;
  final String label;

  const BottomTab(this.icon, this.label);
}