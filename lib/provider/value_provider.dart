import 'package:flutter/cupertino.dart';

class ValueProvider extends ChangeNotifier{
  bool _isChecked = false;
  bool _isloading = false;

  bool get isChecked => _isChecked;
  bool get isLoading => _isloading;


  void setChecked(bool value){
    _isChecked = value;
    notifyListeners();
  }

  void setLoading(bool value){
    _isloading = value;
    notifyListeners();
  }
}