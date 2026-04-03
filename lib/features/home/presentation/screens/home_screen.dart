import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/bottom_tab.dart';
import '../widgets/home_widgets.dart';

class NavigationShell extends StatelessWidget {
  const NavigationShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  void _onTabSelected(int index) {
    shell.goBranch(
      index,
      initialLocation: index == shell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = BottomTab.values[shell.currentIndex];

    return Scaffold(
      body: shell, // ✅ THIS replaces IndexedStack
      bottomNavigationBar: BottomNavBar(
        selectedTab: selectedTab,
        onTap: (tab) {
          _onTabSelected(tab.index);
        },
      ),
    );
  }
}