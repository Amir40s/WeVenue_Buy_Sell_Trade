import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../model/cart/cart_model.dart';
import '../../model/product/product_model.dart';

class CartProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<CartItem> _items = [];
  bool _isLoading = false;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _cartSubscription;

  CartProvider() {
    _initAuthListener();
  }

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;

  /// Initializes auth state listener to automatically attach/detach
  /// Firestore real-time cart stream for the current user.
  void _initAuthListener() {
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToCart(user.uid);
      } else {
        _cartSubscription?.cancel();
        _items.clear();
        _isLoading = false;
        notifyListeners();
      }
    });

    // If already logged in on startup
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _subscribeToCart(currentUser.uid);
    }
  }

  /// Listens to real-time cart updates from Firestore under `users/{uid}/cart`
  void _subscribeToCart(String uid) {
    _cartSubscription?.cancel();
    _isLoading = true;
    notifyListeners();

    _cartSubscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        _items.clear();
        for (var doc in snapshot.docs) {
          final data = doc.data();
          final product = ProductModel.fromMap(data, doc.id);
          final rawQty = data['quantity'];
          final int quantity = (rawQty is num)
              ? rawQty.toInt()
              : (int.tryParse(rawQty?.toString() ?? '1') ?? 1);

          _items.add(CartItem(
            product: product,
            quantity: quantity > 0 ? quantity : 1,
          ));
        }
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Firebase Cart stream error: $error');
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Adds a product to the cart (incrementing quantity if already present)
  /// and persists it in Firebase Firestore.
  Future<void> addProduct(ProductModel product, {int quantity = 1}) async {
    final user = _auth.currentUser;

    int index = _items.indexWhere((item) => item.product.docID == product.docID);
    int newQuantity = quantity;

    if (index >= 0) {
      newQuantity = _items[index].quantity + quantity;
      _items[index].quantity = newQuantity;
    } else {
      _items.add(CartItem(product: product, quantity: newQuantity));
    }
    notifyListeners();

    if (user != null) {
      try {
        final data = product.toMap();
        data['quantity'] = newQuantity;
        data['updatedAt'] = FieldValue.serverTimestamp();

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(product.docID)
            .set(data, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Error writing cart item to Firebase: $e');
      }
    }
  }

  /// Decrements product quantity or removes it completely when quantity <= 1.
  /// Synchronizes change with Firebase Firestore.
  Future<void> removeProduct(ProductModel product) async {
    final user = _auth.currentUser;

    int index = _items.indexWhere((item) => item.product.docID == product.docID);
    if (index < 0) return;

    final currentQty = _items[index].quantity;

    if (currentQty > 1) {
      _items[index].quantity -= 1;
      notifyListeners();

      if (user != null) {
        try {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .doc(product.docID)
              .update({
            'quantity': currentQty - 1,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          debugPrint('Error decrementing cart item in Firebase: $e');
        }
      }
    } else {
      _items.removeAt(index);
      notifyListeners();

      if (user != null) {
        try {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .doc(product.docID)
              .delete();
        } catch (e) {
          debugPrint('Error deleting cart item from Firebase: $e');
        }
      }
    }
  }

  /// Removes a product entirely from the cart and Firebase Firestore.
  Future<void> deleteProduct(ProductModel product) async {
    final user = _auth.currentUser;
    _items.removeWhere((item) => item.product.docID == product.docID);
    notifyListeners();

    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .doc(product.docID)
            .delete();
      } catch (e) {
        debugPrint('Error deleting product from Firebase cart: $e');
      }
    }
  }

  /// Clears the entire cart locally and deletes all items in Firebase Firestore.
  Future<void> clearCart() async {
    final user = _auth.currentUser;
    _items.clear();
    notifyListeners();

    if (user != null) {
      try {
        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .get();

        if (snapshot.docs.isNotEmpty) {
          final batch = _firestore.batch();
          for (var doc in snapshot.docs) {
            batch.delete(doc.reference);
          }
          await batch.commit();
        }
      } catch (e) {
        debugPrint('Error clearing Firebase cart: $e');
      }
    }
  }

  /// Checks if a product is currently in the cart.
  bool isInCart(ProductModel product) {
    return _items.any((item) => item.product.docID == product.docID);
  }

  /// Total count of all items (sum of quantities).
  int get itemCount {
    return _items.fold(0, (total, current) => total + current.quantity);
  }

  /// Total price amount for checkout.
  double get totalAmount {
    return _items.fold(
      0.0,
      (total, item) => total + item.product.cost * item.quantity,
    );
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}
