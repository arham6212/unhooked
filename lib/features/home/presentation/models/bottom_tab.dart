import 'package:flutter/material.dart';

enum BottomTab {
  home(Icons.home_outlined, 'Home'),
  journal(Icons.menu_book_outlined, 'Journal'),
  community(Icons.people_outline_outlined, 'Community'),
  history(Icons.history_outlined, 'History'),
  settings(Icons.settings_outlined, 'Settings');

  final IconData icon;
  final String label;

  const BottomTab(this.icon, this.label);
}