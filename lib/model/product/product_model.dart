
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
    return ProductModel(
      docID: documentId,
      timestamp: data['timestamp'] ?? '',
      cost: data['cost'].toDouble() ?? 0.0,
      date: data['date'] ?? '',
      description: data['description'] ?? '',
      image: data['image'] ?? '',
      time: data['time'] ?? '',
      title: data['title'] ?? '',
      userUID: data['userUID'] ?? '',
      name: data['name'] ?? '',
      profile: data['profile'] ?? '',
      email: data['email'] ?? '',
      isSaved: data['isSaved'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': docID,
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
