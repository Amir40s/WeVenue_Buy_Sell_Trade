import 'product_model.dart';

class CJProductModel {
  final String id;
  final String name;
  final String sku;
  final String image;
  final double price;
  final String currency;
  final int stock;
  final String description;
  final String category;
  final String weight;
  final double rating;
  final int salesCount;
  final bool isFavorite;

  const CJProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.image,
    required this.price,
    required this.currency,
    required this.stock,
    this.description = '',
    this.category = '',
    this.weight = '',
    this.rating = 4.8,
    this.salesCount = 120,
    this.isFavorite = false,
  });

  factory CJProductModel.fromMap(Map<String, dynamic> map) {
    // Generate pseudo rating based on id hash for consistent visual polish
    final idHash = (map['id'] ?? map['pid'] ?? '').toString().hashCode.abs();
    final mockRating = 4.3 + ((idHash % 7) / 10.0);
    final mockSales = 50 + (idHash % 450);

    final double parsedRating = (map['rating'] is num)
        ? (map['rating'] as num).toDouble()
        : (double.tryParse(map['rating']?.toString() ?? '') ??
            double.parse(mockRating.toStringAsFixed(1)));

    final int parsedSales = (map['salesCount'] is num)
        ? (map['salesCount'] as num).toInt()
        : (int.tryParse(map['salesCount']?.toString() ?? '') ?? mockSales);

    return CJProductModel(
      id: (map['id'] ?? map['pid'] ?? '').toString(),
      name: (map['nameEn'] ??
              map['productNameEn'] ??
              map['productName'] ??
              map['name'] ??
              'Unnamed product')
          .toString(),
      sku: (map['sku'] ?? map['spu'] ?? map['productSku'] ?? '').toString(),
      image: (map['bigImage'] ?? map['productImage'] ?? map['image'] ?? '')
          .toString(),
      price: double.tryParse(
            (map['nowPrice'] ?? map['sellPrice'] ?? map['price'] ?? '0')
                .toString(),
          ) ??
          0.0,
      currency: (map['currency'] ?? 'USD').toString(),
      stock: int.tryParse(
            (map['warehouseInventoryNum'] ?? map['inventory'] ?? 0).toString(),
          ) ??
          0,
      description: (map['description'] ??
              map['remark'] ??
              map['entryNameEn'] ??
              '')
          .toString(),
      category: (map['categoryName'] ??
              map['threeCategoryName'] ??
              map['category'] ??
              '')
          .toString(),
      weight: (map['productWeight'] ?? map['weight'] ?? '').toString(),
      rating: parsedRating,
      salesCount: parsedSales,
      isFavorite: map['isFavorite'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'image': image,
      'price': price,
      'currency': currency,
      'stock': stock,
      'description': description,
      'category': category,
      'weight': weight,
      'rating': rating,
      'salesCount': salesCount,
      'isFavorite': isFavorite,
      'isCJProduct': true,
    };
  }

  CJProductModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? image,
    double? price,
    String? currency,
    int? stock,
    String? description,
    String? category,
    String? weight,
    double? rating,
    int? salesCount,
    bool? isFavorite,
  }) {
    return CJProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      image: image ?? this.image,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      stock: stock ?? this.stock,
      description: description ?? this.description,
      category: category ?? this.category,
      weight: weight ?? this.weight,
      rating: rating ?? this.rating,
      salesCount: salesCount ?? this.salesCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Converts this CJ Dropshipping product into a [ProductModel]
  /// so that it integrates seamlessly with existing cart, checkout,
  /// and order pipelines.
  ProductModel toProductModel() {
    return ProductModel(
      docID: 'cj_$id',
      cost: price,
      date: DateTime.now().toIso8601String(),
      description: description.isNotEmpty ? description : name,
      image: image,
      time: '',
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      title: name,
      userUID: 'cj_supplier',
      name: 'CJ Dropshipping',
      profile: '',
      email: 'support@cjdropshipping.com',
      isSaved: isFavorite,
    );
  }
}

