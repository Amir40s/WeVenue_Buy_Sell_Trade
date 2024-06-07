class ProductImageModel {
  final String id;
  final String image;


  ProductImageModel({
    required this.id,
    required this.image,
  });

  factory ProductImageModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProductImageModel(
      id: documentId,
      image: data['image'] ?? '',
    );
  }
}
