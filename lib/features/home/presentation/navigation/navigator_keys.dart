import 'package:flutter/material.dart';

import '../models/bottom_tab.dart';

final navigatorKeys = {
  BottomTab.home: GlobalKey<NavigatorState>(),
  BottomTab.journal: GlobalKey<NavigatorState>(),
  BottomTab.community: GlobalKey<NavigatorState>(),
  BottomTab.meditate: GlobalKey<NavigatorState>(),
  BottomTab.profile: GlobalKey<NavigatorState>(),
};