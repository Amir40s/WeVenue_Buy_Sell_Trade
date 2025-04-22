import 'dart:developer';
import 'dart:io';

import 'package:biouwa/helper/no_user_widget.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../model/message/chatroom_model.dart';
import '../../model/message/user_model.dart';
import '../../provider/bottom_bar/bottom_bar_provider.dart';
import '../../provider/chat/chat_provider.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomProvider = Provider.of<BottomBarProvider>(context);
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: bottomProvider.isLoggedIn
            ? Container(
                margin: EdgeInsets.only(top: Get.width * 0.450),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          TextWidget(
                            text: "Messages",
                            size: 16.0,
                            isBold: true,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                    Consumer<ChatProvider>(
                      builder: (context, chatProvider, _) {
                        return StreamBuilder<List<ChatRoomModel>>(
                          stream: chatProvider.getChatRoomsStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Platform.isIOS
                                    ? const CupertinoActivityIndicator()
                                    : const CircularProgressIndicator(),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('No chats available'),
                              );
                            }
                            var chatRooms = snapshot.data!;
                            return ListView.separated(
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final chatRoom = chatRooms[index];
                                final unreadCount = chatProvider
                                        .unreadMessageCounts[chatRoom.id] ??
                                    0;
                                var otherUserEmail = chatRoom.users.firstWhere(
                                    (user) => user != auth.currentUser!.email);
                                var lastMessage = chatRoom.lastMessage;

                                log("message $unreadCount");

                                log(
                                  "message ${chatProvider.users.firstWhere(
                                    (user) => user.email == otherUserEmail,
                                    orElse: () => UserModel(
                                        id: '',
                                        name: 'Unknown',
                                        email: otherUserEmail,
                                        image: ''),
                                  )}",
                                );

                                // Retrieve user information from ChatProvider
                                var otherUser = chatProvider.users.firstWhere(
                                  (user) => user.email == otherUserEmail,
                                  orElse: () => UserModel(
                                    id: '',
                                    name: 'Unknown',
                                    email: otherUserEmail,
                                    image: '',
                                  ), // Default user
                                );

                                log("message ${otherUser.image}");
                                return ListTile(
                                  leading: otherUser.image.isNotEmpty &&
                                          otherUser.image != ''
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(otherUser.image),
                                        )
                                      : const CircleAvatar(
                                          child: Center(
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                  title: TextWidget(
                                      text: otherUser.name,
                                      size: 14.0,
                                      color: Colors.black,
                                      isBold: true),
                                  // title: Text(otherUserEmail),
                                  subtitle: TextWidget(
                                    text: lastMessage.toString(),
                                    size: 12.0,
                                    color: Colors.black,
                                  ),
                                  trailing: chatRoom.isMessage ==
                                              auth.currentUser!.email &&
                                          chatRoom.isMessage != "seen"
                                      ? const CircleAvatar(
                                          radius: 7,
                                          backgroundColor: primaryColor,
                                        )
                                      : null,
                                  onTap: () async {
                                    final chatRoomId = await context
                                        .read<ChatProvider>()
                                        .createOrGetChatRoom(
                                            otherUser.email, "");
                                    Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .updateMessageStatus(chatRoomId);
                                    Get.to(ChatScreen(
                                      userUID: "product.userUID",
                                      name: otherUser.name,
                                      image: otherUser.image,
                                      otherEmail: otherUser.email,
                                      chatRoomId: chatRoomId,
                                    ));
                                    await chatProvider
                                        .getUnreadMessageCount(chatRoom.id);
                                    log("message ${chatProvider.getUnreadMessageCount(chatRoom.id).toString()}");

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
              )
            : const NoUserWidget(title: 'Required Login'),
      ),
    );
  }
}

class CurrentlyUnavailable extends StatelessWidget {
  const CurrentlyUnavailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SvgPicture.asset(
        //   Images.noData,
        //   height: Get.height * 0.35,
        // ),
        const SizedBox(height: 24),
        TextWidget(
          text: 'Currently unavailable',
          size: 18,
          isBold: true,
        ),
        const SizedBox(height: 8),
        TextWidget(
          text:
              'It looks like you’re not logged in or don’t have an account yet.',
          size: 14,
          color: Colors.grey,
          textAlignment: TextAlign.center,
        ),
        SizedBox(height: Get.height * 0.05)
      ],
    );
  }
}
