import 'package:flutter/cupertino.dart';

class PasswordVisibleProvider extends ChangeNotifier{

  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  set setPasswordVisible(bool value){
    _isPasswordVisible = value;
    notifyListeners();
  }
}