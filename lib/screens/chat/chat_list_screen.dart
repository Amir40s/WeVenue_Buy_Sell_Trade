import 'dart:developer';

import 'package:biouwa/helper/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../model/message/chatroom_model.dart';
import '../../model/message/user_model.dart';
import '../../provider/chat/chat_provider.dart';
import 'chat_screen.dart'; // Import your ChatProvider class
import 'package:timeago/timeago.dart' as timeago;

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: Get.width * 0.450),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
            )
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                  TextWidget(text: "Messages", size: 16.0,isBold: true,color: primaryColor,),
                  ],
                ),
              ),
              Consumer<ChatProvider>(
                builder: (context, chatProvider, _) {
                  return StreamBuilder<List<ChatRoomModel>>(
                    stream: chatProvider.getChatRoomsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const  Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const  Center(
                          child: Text('No chats available'),
                        );
                      }
                      var chatRooms = snapshot.data!;
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final chatRoom = chatRooms[index];
                          final unreadCount =  chatProvider.unreadMessageCounts[chatRoom.id] ?? 0;
                          var otherUserEmail = chatRoom.users.firstWhere((user) => user != auth.currentUser!.email);
                          var lastMessage = chatRoom.lastMessage;
                          // var timeStamp = chatRoom[index].lastTimestamp;


                          log("message $unreadCount");
                          // final relativeTime = timeStamp != null
                          //     ? timeago.format(timeStamp.toDate())
                          //     : '';

                          log("message ${chatProvider.users.firstWhere(
                                  (user) => user.email == otherUserEmail,
                              orElse: () => UserModel(id: '', name: 'Unknown', email: otherUserEmail, image: ''))}");

                          // Retrieve user information from ChatProvider
                          var otherUser =  chatProvider.users.firstWhere(
                                (user) => user.email == otherUserEmail,
                            orElse: () => UserModel(id: '', name: 'Unknown', email: otherUserEmail, image: ''), // Default user
                          );

                          log("message ${otherUser.image}");
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(otherUser.image), // Assuming image is a URL
                            ),
                            title: TextWidget(text: otherUser.name,size: 14.0,color: Colors.black,isBold: true),
                            // title: Text(otherUserEmail),
                            subtitle: TextWidget(text: lastMessage.toString(),size: 12.0,color: Colors.black,),
                            trailing: chatRoom.isMessage == auth.currentUser!.email && chatRoom.isMessage !="seen"
                                ? const CircleAvatar(
                              radius: 7,
                              backgroundColor: primaryColor,
                            )
                                : null,
                            onTap: () async{
                              final chatRoomId = await context.read<ChatProvider>().createOrGetChatRoom(otherUser.email,"");
                             Provider.of<ChatProvider>(context,listen: false).updateMessageStatus(chatRoomId);
                              Get.to(ChatScreen(
                                userUID: "product.userUID",
                                name: otherUser.name,
                                image: otherUser.image,
                                otherEmail: otherUser.email,
                                chatRoomId: chatRoomId,
                              ));
                              await chatProvider.getUnreadMessageCount(chatRoom.id);
                              log("message ${ chatProvider.getUnreadMessageCount(chatRoom.id).toString()}");

                              // await chatProvider.getCollectionLength(chatRoom.id);
                              // log('get Messages ${chatProvider.collectionLength}');

                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: Colors.black,
                          );
                        },
                      );

                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}




