import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/product/cj_product_model.dart';

class CJDropshippingService {
  CJDropshippingService._();

  static final CJDropshippingService instance = CJDropshippingService._();

  static const String _baseUrl =
      'https://developers.cjdropshipping.com/api2.0/v1';

  // Supply this at run time for testing:
  // --dart-define=CJ_API_KEY=your_key
  // This is NOT secure for production mobile apps.
  String get _apiKey => dotenv.env['CJ_API_KEY'] ?? '';

  String? _accessToken;

  Future<String> _getAccessToken() async {
    if (_accessToken != null) {
      debugPrint('CJ: Using cached access token');
      return _accessToken!;
    }

    if (_apiKey.trim().isEmpty) {
      throw Exception('CJ API key is missing from .env');
    }

    debugPrint('CJ: API key configured = ${_apiKey.trim().isNotEmpty}');
    debugPrint('CJ: Requesting access token...');

    final response = await http
        .post(
          Uri.parse('$_baseUrl/authentication/getAccessToken'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'apiKey': _apiKey.trim()}),
        )
        .timeout(const Duration(seconds: 30));

    debugPrint('CJ Auth HTTP Status: ${response.statusCode}');
    debugPrint('CJ Auth Response: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'CJ authentication HTTP error: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    final data = body['data'];

    if (body['code'] != 200 || data is! Map || data['accessToken'] == null) {
      throw Exception(
        'CJ authentication failed: ${body['message'] ?? 'Unknown error'}',
      );
    }

    _accessToken = data['accessToken'].toString();
    debugPrint('CJ: Access token received successfully');

    return _accessToken!;
  }

  Future<List<CJProductModel>> getProducts({
    String keyword = '',
    int page = 1,
    int size = 20,
    String? categoryId,
    bool isRetry = false,
  }) async {
    debugPrint(
      'CJ Products: Fetching page=$page, size=$size, keyword="$keyword", category="$categoryId"',
    );

    final token = await _getAccessToken();

    final query = <String, String>{
      'page': page.toString(),
      'size': size.clamp(1, 100).toString(),
      if (keyword.trim().isNotEmpty) 'keyWord': keyword.trim(),
      if (categoryId != null && categoryId.trim().isNotEmpty)
        'categoryId': categoryId.trim(),
    };

    final uri =
        Uri.parse('$_baseUrl/product/listV2').replace(queryParameters: query);

    final response = await http.get(
      uri,
      headers: {'CJ-Access-Token': token},
    ).timeout(const Duration(seconds: 30));

    debugPrint('CJ Products HTTP Status: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception(
        'CJ products HTTP error: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (body['code'] != 200) {
      // If token expired, clear token and retry once
      if (body['code'] == 1600001 && !isRetry) {
        debugPrint('CJ: Token expired (1600001), refreshing token and retrying...');
        _accessToken = null;
        return getProducts(
          keyword: keyword,
          page: page,
          size: size,
          categoryId: categoryId,
          isRetry: true,
        );
      }

      throw Exception(
        body['message'] ?? 'CJ products query failed',
      );
    }

    final data = body['data'];

    if (data is! Map) {
      debugPrint('CJ: data is not a Map');
      return [];
    }

    final content = data['content'];

    if (content is! List) {
      debugPrint('CJ: data.content is not a List');
      return [];
    }

    final products = <CJProductModel>[];

    for (final group in content) {
      if (group is! Map) continue;

      final productList = group['productList'];

      if (productList is! List) continue;

      for (final item in productList) {
        if (item is! Map) continue;

        final map = Map<String, dynamic>.from(item);
        final product = CJProductModel.fromMap(map);

        if (product.id.isNotEmpty && product.image.isNotEmpty) {
          products.add(product);
        }
      }
    }

    debugPrint('CJ: Successfully parsed ${products.length} products');

    return products;
  }

  /// Optional query for product details by ID
  Future<CJProductModel?> getProductDetails(String productId) async {
    try {
      final token = await _getAccessToken();
      final uri = Uri.parse('$_baseUrl/product/query').replace(
        queryParameters: {'pid': productId},
      );

      final response = await http.get(
        uri,
        headers: {'CJ-Access-Token': token},
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['code'] == 200 && body['data'] is Map) {
          return CJProductModel.fromMap(Map<String, dynamic>.from(body['data']));
        }
      }
    } catch (e) {
      debugPrint('CJ Product Details error: $e');
    }
    return null;
  }
}
