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
      initialLocation: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = BottomTab.values[shell.currentIndex];
    final isHome = shell.currentIndex == 0;

    return Scaffold(
      extendBody: true,
      body: isHome
          ? Stack(
              children: [
                shell,
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: VerticalEdgeNavBar(
                    selectedTab: selectedTab,
                    onTap: (tab) => _onTabSelected(tab.index),
                  ),
                ),
              ],
            )
          : shell,
      bottomNavigationBar: isHome
          ? null
          : BottomNavBar(
              selectedTab: selectedTab,
              onTap: (tab) => _onTabSelected(tab.index),
            ),
    );
  }
}