import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String id;
  final List<String> users;
  final String lastMessage;
  final String isMessage;
  final DateTime lastTimestamp;
  int unreadMessageCount;

  ChatRoomModel({
    required this.id,
    required this.users,
    required this.lastMessage,
    required this.isMessage,
    required this.lastTimestamp,
    this.unreadMessageCount = 0,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> data, String id) {
    return ChatRoomModel(
      id: id,
      users: List<String>.from(data['users']),
      lastMessage: data['lastMessage'] ?? '',
      isMessage: data['isMessage'] ?? '',
      lastTimestamp: (data['lastTimestamp'] as Timestamp).toDate(),
      unreadMessageCount: 0, // Initialize with 0; it will be updated later
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'users': users,
      'lastMessage': lastMessage,
      'lastTimestamp': lastTimestamp,
      'isMessage': isMessage,
    };
  }
}
