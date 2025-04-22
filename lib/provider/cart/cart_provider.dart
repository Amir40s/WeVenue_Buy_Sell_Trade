import 'package:biouwa/model/product/product_model.dart';
import 'package:flutter/material.dart';

import '../../model/cart/cart_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addProduct(ProductModel product) {
    int index =
        _items.indexWhere((item) => item.product.docID == product.docID);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  bool isInCart(ProductModel product) {
    return _items.any((item) => item.product.docID == product.docID);
  }

  int get itemCount {
    return _items.fold(0, (total, current) => total + current.quantity);
  }

  void removeProduct(ProductModel product) {
    int index =
        _items.indexWhere((item) => item.product.docID == product.docID);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalAmount {
    return _items.fold(
        0.0, (sum, item) => sum + item.product.cost * item.quantity);
  }
}
