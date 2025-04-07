import 'package:flutter/cupertino.dart';

class DropdownProvider extends ChangeNotifier{
  String? _selectedAccountType = "User";
  final List<String> _items = ['User', 'Driver'];

  String? get selectedAccountType => _selectedAccountType;
  List<String> get items => _items;

  void setSelectedItem(String item) {
    _selectedAccountType = item;
    notifyListeners();
  }
}