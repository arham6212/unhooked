import 'package:flutter/material.dart';

enum BottomTab {
  home(Icons.home_rounded, 'Home'),
  journal(Icons.menu_book_rounded, 'Journal'),
  community(Icons.people_rounded, 'Community'),
  history(Icons.history_rounded, 'History'),
  settings(Icons.settings_rounded, 'Settings');

  final IconData icon;
  final String label;

  const BottomTab(this.icon, this.label);
}