import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bottom_tab.dart';

final bottomNavProvider =
NotifierProvider<BottomNavNotifier, BottomTab>(
    BottomNavNotifier.new);

class BottomNavNotifier extends Notifier<BottomTab> {
  @override
  BottomTab build() => BottomTab.home;

  void changeTab(BottomTab tab) {
    state = tab;
  }
}