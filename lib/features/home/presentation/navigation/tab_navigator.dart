import 'package:flutter/material.dart';
import 'package:test4/features/auth/presentation/screens/login_screen.dart';
import '../models/bottom_tab.dart';
import '../screens/home_screen_body.dart';
import 'navigator_keys.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({super.key, required this.tab});

  final BottomTab tab;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKeys[tab],
      onGenerateRoute: (settings) {
        Widget page;

        switch (tab) {
          case BottomTab.home:
            page = const HomeScreenBody();
            break;
          case BottomTab.journal:
            page = const HomeScreenBody();
            break;
          case BottomTab.community:
            page = const HomeScreenBody();
            break;
          case BottomTab.history:
            page = const HomeScreenBody();
            break;
          case BottomTab.settings:
            page = const LoginScreen();
            break;
        }

        return MaterialPageRoute(builder: (_) => page);
      },
    );
  }
}