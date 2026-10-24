
class ProductModel {
  final double cost;
  final String date;
  final String description;
  final String image;
  final String time;
  final String timestamp;
  final String title;
  final String userUID;
  final String docID;
  final String name;
  final String profile;
  final String email;
  bool isSaved;

  ProductModel({
    required this.docID,
    required this.cost,
    required this.date,
    required this.description,
    required this.image,
    required this.time,
    required this.timestamp,
    required this.title,
    required this.userUID,
    required this.name,
    required this.profile,
    required this.email,
    this.isSaved = false,
  });

  factory ProductModel.fromMap(Map<String, dynamic> data, String documentId) {
    final rawCost = data['cost'] ?? data['price'];
    final double parsedCost = (rawCost is num)
        ? rawCost.toDouble()
        : (double.tryParse(rawCost?.toString() ?? '0') ?? 0.0);

    return ProductModel(
      docID: documentId,
      timestamp: data['timestamp']?.toString() ?? '',
      cost: parsedCost,
      date: data['date']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      image: data['image']?.toString() ?? '',
      time: data['time']?.toString() ?? '',
      title: (data['title'] ?? data['name'] ?? '').toString(),
      userUID: data['userUID']?.toString() ?? '',
      name: (data['name'] ?? data['title'] ?? '').toString(),
      profile: data['profile']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      isSaved: data['isSaved'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': docID,
      'docID': docID,
      'cost': cost,
      'date': date,
      'description': description,
      'image': image,
      'time': time,
      'timestamp': timestamp,
      'title': title,
      'userUID': userUID,
      'name': name,
      'email': email,
      'profile': profile,
      'isSaved': isSaved,
    };
  }
}
