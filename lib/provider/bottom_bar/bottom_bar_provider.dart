import 'dart:developer';
import 'dart:io';

import 'package:biouwa/screens/chat/chat_list_screen.dart';
import 'package:biouwa/screens/dashboard/account/account_screen.dart';
import 'package:biouwa/screens/dashboard/relocation/relocation_screen.dart';
import 'package:biouwa/screens/uploadItems/items_upload_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/dashboard/dashboard_screen.dart';

class BottomBarProvider with ChangeNotifier {
  int _myIndex = 0;
  List<Widget> _myList = Platform.isAndroid
      ? [
          const DashboardScreen(),
          const ChatListScreen(),
          RelocationScreen(),
          AccountScreen(type: 'bottom'),
          const DashboardScreen(),
        ]
      : [
          const DashboardScreen(),
          ItemsUploadScreen(),
          const ChatListScreen(),
          RelocationScreen(),
          AccountScreen(type: 'bottom'),
          const DashboardScreen(),
        ];

  BottomBarProvider() {
    log('Constructor Called');
    _init();
  }

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void _init() {
    final user = FirebaseAuth.instance.currentUser;
    _isLoggedIn = user != null;
    notifyListeners();
  }

  void refreshStatus() {
    _init();
  }

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
