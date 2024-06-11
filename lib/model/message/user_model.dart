class UserModel {
  final String id;
  final String name;
  final String email;
  final String image;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      image: map['image'] ?? "",
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, image: $image}';
  }
}