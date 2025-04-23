import 'package:flutter/material.dart';

class CheckOutP extends ChangeNotifier {
  String address = '';
  String userName = '';
  String userPhone = '';
  String price = '';
  String totalProducts = '';

  void addOrder(
      {required String address,
      required String userName,
      required String userPhone,
      required String totalAmount,
      required String totalItems}) {
    this.address = address;
    this.userName = userName;
    this.userPhone = userPhone;
    price = totalAmount;
    totalProducts = totalItems;
    notifyListeners();
  }
}
