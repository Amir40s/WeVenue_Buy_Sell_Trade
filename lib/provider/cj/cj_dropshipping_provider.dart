import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../model/product/cj_product_model.dart';
import '../../services/cj_dropshipping_service.dart';

enum CJSortOption {
  featured('Featured'),
  priceLowHigh('Price: Low to High'),
  priceHighLow('Price: High to Low'),
  nameAZ('Name: A to Z');

  final String label;
  const CJSortOption(this.label);
}

class CJDropshippingProvider extends ChangeNotifier {
  final CJDropshippingService _service = CJDropshippingService.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Master product list
  final List<CJProductModel> _products = [];

  // State flags
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  // Pagination
  int _currentPage = 1;
  static const int _pageSize = 20;

  // Filtering & Sorting
  String _searchQuery = '';
  String _selectedCategory = 'All';
  CJSortOption _sortOption = CJSortOption.featured;

  // Wishlist / Saved items in Firebase
  final Set<String> _favoriteIds = {};
  final List<CJProductModel> _favoriteProducts = [];
  bool _isLoadingFavorites = false;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _wishlistSubscription;

  CJDropshippingProvider() {
    _initAuthAndWishlist();
  }

  void _initAuthAndWishlist() {
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToWishlist(user.uid);
      } else {
        _wishlistSubscription?.cancel();
        _favoriteIds.clear();
        _favoriteProducts.clear();
        _isLoadingFavorites = false;
        notifyListeners();
      }
    });

    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _subscribeToWishlist(currentUser.uid);
    }
  }

  void _subscribeToWishlist(String uid) {
    _wishlistSubscription?.cancel();
    _isLoadingFavorites = true;
    notifyListeners();

    _wishlistSubscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('wishlist')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        _favoriteIds.clear();
        _favoriteProducts.clear();
        for (var doc in snapshot.docs) {
          final data = doc.data();
          _favoriteIds.add(doc.id);
          try {
            _favoriteProducts.add(CJProductModel.fromMap(data));
          } catch (e) {
            debugPrint('Error parsing CJ wishlist product from Firebase: $e');
          }
        }
        _isLoadingFavorites = false;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Firebase wishlist stream error: $e');
        _isLoadingFavorites = false;
        notifyListeners();
      },
    );
  }

  // Available categories
  final List<String> categories = const [
    'All',
    'Trending',
    'Electronics',
    'Fashion',
    'Home & Living',
    'Beauty',
    'Jewelry',
    'Sports',
  ];

  // Getters
  List<CJProductModel> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  CJSortOption get sortOption => _sortOption;
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  /// Returns filtered and sorted products for display
  List<CJProductModel> get filteredProducts {
    var list = _products.where((product) {
      // Category filter
      if (_selectedCategory != 'All' && _selectedCategory != 'Trending') {
        final catLower = _selectedCategory.toLowerCase();
        final prodCat = product.category.toLowerCase();
        final prodName = product.name.toLowerCase();
        final matchesCategory = prodCat.contains(catLower) || prodName.contains(catLower);
        if (!matchesCategory) return false;
      }

      // Search query filter
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.trim().toLowerCase();
        final matchesQuery = product.name.toLowerCase().contains(query) ||
            product.sku.toLowerCase().contains(query) ||
            product.id.toLowerCase().contains(query) ||
            product.category.toLowerCase().contains(query);
        if (!matchesQuery) return false;
      }

      return true;
    }).toList();

    // Sort list
    switch (_sortOption) {
      case CJSortOption.priceLowHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case CJSortOption.priceHighLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case CJSortOption.nameAZ:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case CJSortOption.featured:
        // Natural order
        break;
    }

    return list;
  }

  /// Initial load or pull-to-refresh
  Future<void> fetchProducts({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _errorMessage = null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _service.getProducts(
        page: _currentPage,
        size: _pageSize,
        keyword: _searchQuery.trim().isNotEmpty ? _searchQuery.trim() : '',
      );

      if (refresh) {
        _products.clear();
      }

      // Avoid duplicates
      final existingIds = _products.map((p) => p.id).toSet();
      for (final item in results) {
        if (!existingIds.contains(item.id)) {
          _products.add(item);
        }
      }

      _hasMore = results.length >= _pageSize;
      if (_hasMore) {
        _currentPage++;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load next page
  Future<void> loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final results = await _service.getProducts(
        page: _currentPage,
        size: _pageSize,
        keyword: _searchQuery.trim().isNotEmpty ? _searchQuery.trim() : '',
      );

      final existingIds = _products.map((p) => p.id).toSet();
      for (final item in results) {
        if (!existingIds.contains(item.id)) {
          _products.add(item);
        }
      }

      _hasMore = results.length >= _pageSize;
      if (_hasMore) {
        _currentPage++;
      }
    } catch (e) {
      // Don't overwrite error if products already exist, just log
      debugPrint('Error loading more CJ products: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Search query update
  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  /// Category selection
  void setSelectedCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
  }

  /// Sort option selection
  void setSortOption(CJSortOption option) {
    if (_sortOption == option) return;
    _sortOption = option;
    notifyListeners();
  }

  /// Toggle favorite and synchronize with Firebase Firestore
  Future<void> toggleFavorite(String productId, [CJProductModel? product]) async {
    final user = _auth.currentUser;

    CJProductModel? targetProduct = product;
    if (targetProduct == null) {
      final idx = _products.indexWhere((p) => p.id == productId);
      if (idx >= 0) {
        targetProduct = _products[idx];
      } else {
        final favIdx = _favoriteProducts.indexWhere((p) => p.id == productId);
        if (favIdx >= 0) targetProduct = _favoriteProducts[favIdx];
      }
    }

    final isFav = _favoriteIds.contains(productId);

    if (isFav) {
      _favoriteIds.remove(productId);
      _favoriteProducts.removeWhere((p) => p.id == productId);
      notifyListeners();

      if (user != null) {
        try {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('wishlist')
              .doc(productId)
              .delete();
        } catch (e) {
          debugPrint('Error removing from Firebase wishlist: $e');
        }
      }
    } else {
      _favoriteIds.add(productId);
      if (targetProduct != null &&
          !_favoriteProducts.any((p) => p.id == productId)) {
        _favoriteProducts.add(targetProduct);
      }
      notifyListeners();

      if (user != null && targetProduct != null) {
        try {
          final data = targetProduct.toMap();
          data['timestamp'] = FieldValue.serverTimestamp();
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('wishlist')
              .doc(productId)
              .set(data, SetOptions(merge: true));
        } catch (e) {
          debugPrint('Error adding to Firebase wishlist: $e');
        }
      }
    }
  }

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  /// Returns list of all favorited CJ products loaded from Firebase Firestore
  List<CJProductModel> get favoriteProducts {
    return List.unmodifiable(_favoriteProducts);
  }

  bool get isLoadingFavorites => _isLoadingFavorites;

  /// Retry after error
  void retry() {
    fetchProducts(refresh: true);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _wishlistSubscription?.cancel();
    super.dispose();
  }
}
