import 'package:biouwa/db_key.dart';
import 'package:biouwa/model/product/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constant.dart';
import '../../model/product/product_image_model.dart';

class ProductProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<ProductModel>> getMyProducts() {
    String? userUID = auth.currentUser?.uid.toString();
    return _firestore
        .collection('items')
        .where(DbKey.k_userUID, isEqualTo: userUID)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Stream<List<ProductImageModel>> getProductImages({required docID}) {
    return _firestore
        .collection('items')
        .doc(docID)
        .collection("images")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductImageModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Stream<List<ProductModel>> getProducts() {
    String? userUID = auth.currentUser?.uid.toString();
    return _firestore
        .collection('items')
        .where(DbKey.k_userUID, isNotEqualTo: userUID)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deleteProduct({required productId, required imageUrl}) async {
    try {
      await _storage.refFromURL(imageUrl).delete();
      await _firestore
          .collection('items')
          .doc(productId)
          .delete()
          .whenComplete(() {
        deleteSubCollection(productId, "images");
      });
      notifyListeners();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Future<void> deleteSubCollection(
      String productId, String subCollectionName) async {
    try {
      var subCollection = _firestore
          .collection('items')
          .doc(productId)
          .collection(subCollectionName);
      var snapshots = await subCollection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      showSnackBar(title: "Product Deleted", subtitle: "");
      notifyListeners();
    } catch (e) {
      print('Error deleting subcollection: $e');
    }
  }

  final Set<String> _savedIds = {};

  bool isProductSavedSync(String productId) => _savedIds.contains(productId);

  Future<void> saveProduct(String productId, [ProductModel? product]) async {
    try {
      String? userUID = auth.currentUser?.uid;
      if (userUID == null) return;

      Map<String, dynamic> data = {
        'productId': productId,
        'timestamp': FieldValue.serverTimestamp(),
      };
      if (product != null) {
        data.addAll(product.toMap());
      }

      _savedIds.add(productId);
      notifyListeners();

      await _firestore
          .collection('users')
          .doc(userUID)
          .collection('savedItems')
          .doc(productId)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error saving product: $e');
    }
  }

  Future<void> unsaveProduct(String productId) async {
    try {
      String? userUID = auth.currentUser?.uid;
      if (userUID == null) return;

      _savedIds.remove(productId);
      notifyListeners();

      await _firestore
          .collection('users')
          .doc(userUID)
          .collection('savedItems')
          .doc(productId)
          .delete();
    } catch (e) {
      print('Error unsaving product: $e');
    }
  }

  Future<bool> isProductSaved(String productId) async {
    String? userUID = auth.currentUser?.uid;
    if (userUID == null) return false;
    var doc = await _firestore
        .collection('users')
        .doc(userUID)
        .collection('savedItems')
        .doc(productId)
        .get();
    final exists = doc.exists;
    if (exists) {
      _savedIds.add(productId);
    } else {
      _savedIds.remove(productId);
    }
    return exists;
  }

  Stream<List<ProductModel>> getSavedProducts() {
    String? userUID = auth.currentUser?.uid;
    if (userUID == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(userUID)
        .collection('savedItems')
        .snapshots()
        .asyncMap((snapshot) async {
      List<ProductModel> savedProducts = [];
      _savedIds.clear();

      for (var doc in snapshot.docs) {
        _savedIds.add(doc.id);
        final data = doc.data();

        // If product fields are saved directly in savedItems
        if (data.containsKey('title') &&
            data['title'] != null &&
            data['title'].toString().isNotEmpty) {
          savedProducts.add(ProductModel.fromMap(data, doc.id));
        } else {
          // Otherwise fetch from items collection
          try {
            var productDoc =
                await _firestore.collection('items').doc(doc.id).get();
            if (productDoc.exists && productDoc.data() != null) {
              savedProducts
                  .add(ProductModel.fromMap(productDoc.data()!, productDoc.id));
            }
          } catch (e) {
            print('Error fetching saved item details: $e');
          }
        }
      }
      return savedProducts;
    });
  }
}
