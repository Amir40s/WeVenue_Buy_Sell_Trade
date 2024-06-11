
import 'dart:developer';

import 'package:biouwa/constant.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../model/message/chatroom_model.dart';
import '../../model/message/message_model.dart';
import '../../model/message/user_model.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MessageModel> _messages = [];
  List<UserModel> _users = [];
  List<ChatRoomModel> _chatRooms = [];
  Map<String, int> _unreadMessageCounts = {};



  List<MessageModel> get messages => _messages;
  List<UserModel> get users => _users;

  List<ChatRoomModel> get chatRooms => _chatRooms;
  Map<String, int> get unreadMessageCounts => _unreadMessageCounts;


  ChatProvider() {
    _loadUsers();
    _loadMessages();
    loadChatRooms();
  }

  // Future<void> _loadChatRooms() async {
  //   final currentUserEmail = auth.currentUser!.email!;
  //   QuerySnapshot snapshot = await _firestore
  //       .collection('chatRooms')
  //       .where('users', arrayContains: currentUserEmail)
  //       .get();
  //
  //   _chatRooms = snapshot.docs.map((doc) => ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  //
  //   for (var chatRoom in _chatRooms) {
  //     final unreadCount = await _getUnreadMessageCount(chatRoom.id);
  //     _unreadMessageCounts[chatRoom.id] = unreadCount;
  //   }
  //   notifyListeners();
  // }
  Future<void> loadChatRooms() async {
    log("Chat Room Load");
    final currentUserEmail = auth.currentUser!.email!;
    QuerySnapshot snapshot = await _firestore
        .collection('chatRooms')
        .where('users', arrayContains: currentUserEmail)
        .get();

    final chatRooms = snapshot.docs.map((doc) {
      return ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    // Retrieve unread message counts
    await Future.wait(chatRooms.map((chatRoom) async {
      chatRoom.unreadMessageCount = await _getUnreadMessageCount(chatRoom.id);
      _unreadMessageCounts[chatRoom.id] = chatRoom.unreadMessageCount;
    }));

    _chatRooms = chatRooms;
    notifyListeners();
  }

  Stream<List<ChatRoomModel>> getChatRoomsStream() {
    final currentUserEmail = auth.currentUser!.email!;
    return _firestore
        .collection('chatRooms')
        .where('users', arrayContains: currentUserEmail)
        .snapshots()
        .asyncMap((snapshot) async {
      final chatRooms = snapshot.docs.map((doc) {
        final chatRoom = ChatRoomModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        chatRoom.unreadMessageCount = _unreadMessageCounts[chatRoom.id] ?? 0;
        return chatRoom;
      }).toList();
      return chatRooms;
    });
  }


  Future<int> _getUnreadMessageCount(String chatRoomId) async {
    final currentUserEmail = auth.currentUser!.email!;
    final messagesSnapshot = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('read', isEqualTo: false)
        .where('sender', isNotEqualTo: currentUserEmail)
        .get();

    return messagesSnapshot.docs.length;
  }

  Future<int> getUnreadMessageCount(String chatRoomId) async {
    log("Chat ID ${chatRoomId}");
    final currentUserEmail = auth.currentUser!.email!;
    final messagesSnapshot = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('read', isEqualTo: false)
        .where('sender', isNotEqualTo: currentUserEmail)
        .get();

    return messagesSnapshot.docs.length;
  }

  Future<void> _loadUsers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    _users = snapshot.docs
        .map((doc) => UserModel(
      id: doc.id,
      name: doc['name'] ?? "",
      email: doc['email'] ?? "",
      image: doc['image'] ?? "",
    ))
        .toList();
    notifyListeners();
  }

  Future<void> _loadMessages() async {
    QuerySnapshot snapshot = await _firestore.collection('messages').orderBy('timestamp').get();
    _messages = snapshot.docs.map((doc) => MessageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    notifyListeners();
  }



  // working
  // Future<void> sendMessage({required String chatRoomId,required String message}) async {
  //   await _firestore.collection("chatRooms").doc(chatRoomId).update({
  //     "lastMessage" : message
  //   });
  //   await _firestore.collection('chatRooms').doc(chatRoomId).collection('messages').add({
  //     'text': message,
  //     'sender': auth.currentUser!.email,
  //     'timestamp': FieldValue.serverTimestamp(),
  //     'delivered': false, // Add delivered status
  //   });
  // }

  Future<void> sendMessage({required String chatRoomId,required String message, required String otherEmail}) async {
    final currentUserEmail = auth.currentUser!.email!;
    final newMessage = {
      'text': message,
      'sender': currentUserEmail,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
      'delivered': false,
    };
    await _firestore.collection('chatRooms').doc(chatRoomId).collection('messages').add(newMessage);
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': message,
      'isMessage': otherEmail,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateDeliveryStatus(String chatRoomId) async {
    final currentUserEmail = auth.currentUser!.email;
    final messageDocs = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('sender', isNotEqualTo: currentUserEmail)
        .get();

    for (var doc in messageDocs.docs) {
      if (!(doc['delivered'] as bool)) {
        await doc.reference.update({'delivered': true});
      }
    }
  }

  Future<void> updateMessageStatus(String chatRoomID) async{
    log("message ${chatRoomID} : run");
    await _firestore.collection("chatRooms").doc(chatRoomID).update({"isMessage" : "seen"});
  }


  Future<void> markMessageAsRead(String chatRoomId) async {
    final currentUserEmail = auth.currentUser!.email!;
    final messageDocs = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('sender', isNotEqualTo: currentUserEmail)
        .get();

    for (var doc in messageDocs.docs) {
      if (!(doc['read'] as bool)) {
        await doc.reference.update({'read': true});
      }
    }
    await loadChatRooms(); // Refresh chat rooms to update unread counts
  }


  // Future<void> markMessageAsRead(String chatRoomId) async {
  //   final currentUserEmail = auth.currentUser!.email;
  //   final messageDocs = await _firestore
  //       .collection('chatRooms')
  //       .doc(chatRoomId)
  //       .collection('messages')
  //       .where('sender', isNotEqualTo: currentUserEmail)
  //       .get();
  //
  //   for (var doc in messageDocs.docs) {
  //     if (!(doc['read'] as bool)) {
  //       await doc.reference.update({'read': true});
  //       _unreadChatRooms.remove(chatRoomId);
  //       notifyListeners();
  //     }
  //   }
  // }

  Future<String> createChatRoom(String otherUserEmail,String lastMessage) async {
    final chatRoom = await _firestore.collection('chatRooms').add({
      'users': [auth.currentUser!.email, otherUserEmail],
      'lastMessage': lastMessage,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
    return chatRoom.id;
  }

  String getChatRoomId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode
        ? '$user1-$user2'
        : '$user2-$user1';
  }

  Stream<QuerySnapshot> getChatRooms() {
    return _firestore
        .collection('chatRooms')
        .where('users', arrayContains: auth.currentUser!.email)
        .snapshots();
  }


  // working
  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
  // Stream<List<MessageModel>> getMessages(String chatRoomId) {
  //   return _firestore
  //       .collection('chatRooms')
  //       .doc(chatRoomId)
  //       .collection('messages')
  //       .orderBy('timestamp', descending: true)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) => MessageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  // }

  Future<String> createOrGetChatRoom(String otherUserEmail,String lastMessage) async {
    final currentUserEmail = auth.currentUser!.email!;
    final chatRoomId = getChatRoomId(currentUserEmail, otherUserEmail);

    final chatRoomDoc = _firestore.collection('chatRooms').doc(chatRoomId);
    final chatRoomSnapshot = await chatRoomDoc.get();

    if (!chatRoomSnapshot.exists) {
      await chatRoomDoc.set({
        'users': [currentUserEmail, otherUserEmail],
        'lastMessage': lastMessage,
        'isMessage': auth.currentUser!.email.toString(),
        'lastTimestamp': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }

  int _collectionLength = 0;
  int get collectionLength => _collectionLength;

  Future<void> getCollectionLength(String chatRoomId) async {
    log('Enter');
    final currentUserEmail = auth.currentUser!.email!;
    final collectionRef =
    FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId)
        .collection("messages")
        .where("read" , isEqualTo: false)
        .where('sender', isNotEqualTo: currentUserEmail);
    QuerySnapshot snapshot = await collectionRef.get();
    _collectionLength = snapshot.size;
    notifyListeners();
  }


}

