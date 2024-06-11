// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class Message {
// //   final String id;
// //   final String text;
// //   final DateTime timestamp;
// //   final String sender;
// //
// //   Message({
// //     required this.id,
// //     required this.text,
// //     required this.timestamp,
// //     required this.sender,
// //   });
// //
// //   factory Message.fromJson(Map<String, dynamic> json) {
// //     return Message(
// //       id: json['id'],
// //       text: json['text'],
// //       timestamp: (json['timestamp'] as Timestamp).toDate(),
// //       sender: json['sender'],
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'id': id,
// //       'text': text,
// //       'timestamp': timestamp,
// //       'sender': sender,
// //     };
// //   }
// // }
//
// class MessageModel {
//    late final String id;
//   final String senderId;
//   final String text;
//   final DateTime timestamp;
//
//   MessageModel({
//     required this.id,
//     required this.senderId,
//     required this.text,
//     required this.timestamp,
//   });
//
//   factory MessageModel.fromMap(Map<String, dynamic> data, String id) {
//     return MessageModel(
//       id: id,
//       senderId: data['senderId'],
//       text: data['text'],
//       timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'senderId': senderId,
//       'text': text,
//       'timestamp': timestamp.millisecondsSinceEpoch,
//     };
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String text;
  final String sender;
  final DateTime timestamp;
  final bool read;
  final bool delivered;

  MessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    required this.read,
    required this.delivered,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data, String id) {
    return MessageModel(
      id: id,
      text: data['text'] ?? '',
      sender: data['sender'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      read: data['read'] ?? false,
      delivered: data['delivered'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'sender': sender,
      'timestamp': timestamp,
      'read': read,
      'delivered': delivered,
    };
  }
}
