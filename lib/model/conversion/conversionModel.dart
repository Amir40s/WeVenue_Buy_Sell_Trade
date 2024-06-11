import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final String title;
  final String imageUrl;
  final bool isActive;
  final int unreadCount;
  final String lastMessage;
  final DateTime lastTimestamp;

  Conversation({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.isActive,
    required this.unreadCount,
    required this.lastMessage,
    required this.lastTimestamp,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'],
      unreadCount: json['unreadCount'],
      lastMessage: json['lastMessage'],
      lastTimestamp: (json['lastTimestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'unreadCount': unreadCount,
      'lastMessage': lastMessage,
      'lastTimestamp': lastTimestamp,
    };
  }
}