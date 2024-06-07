import 'package:biouwa/screens/dashboard/account/account_screen.dart';
import 'package:biouwa/screens/dashboard/relocation/relocation_screen.dart';
import 'package:flutter/material.dart';

import '../../screens/dashboard/dashboard_screen.dart';



class BottomBarProvider with ChangeNotifier {
  int _myIndex = 0;
  List<Widget> _myList = [
     DashboardScreen(),
     DashboardScreen(),
    RelocationScreen(),
     AccountScreen(),
     DashboardScreen(),
  ];

  int get myIndex => _myIndex;

  List<Widget> get myList => _myList;

  void changeMyList(List<Widget> list) {
    _myList = list;
    notifyListeners();
  }

  void changeMyIndex(int index) {
    _myIndex = index;
    notifyListeners();
  }
}