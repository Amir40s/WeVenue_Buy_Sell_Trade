import 'dart:io';

import 'package:biouwa/helper/no_user_widget.dart';
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
      backgroundColor: const Color(0xFFF6F6FA),
      body: SafeArea(
        child: bottomProvider.isLoggedIn
            ? Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Messages',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Stay connected with your conversations',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<ChatProvider>(
                      builder: (context, chatProvider, _) {
                        return StreamBuilder<List<ChatRoomModel>>(
                          stream: chatProvider.getChatRoomsStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Platform.isIOS
                                    ? const CupertinoActivityIndicator()
                                    : const CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                              );
                            }

                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Unable to load conversations'),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(22),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withValues(
                                            alpha: 0.08),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.chat_bubble_outline_rounded,
                                        size: 42,
                                        color: primaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No conversations yet',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF202033),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Your messages will appear here.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF85859A),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final chatRooms = snapshot.data!;

                            return ListView.separated(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 22, 16, 24),
                              itemCount: chatRooms.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final chatRoom = chatRooms[index];
                                final currentEmail = auth.currentUser?.email;

                                final otherUserEmail =
                                    chatRoom.users.firstWhere(
                                  (user) => user != currentEmail,
                                  orElse: () => '',
                                );

                                final otherUser = chatProvider.users.firstWhere(
                                  (user) => user.email == otherUserEmail,
                                  orElse: () => UserModel(
                                    id: '',
                                    name: 'Unknown',
                                    email: otherUserEmail,
                                    image: '',
                                  ),
                                );

                                final unreadCount = chatProvider
                                        .unreadMessageCounts[chatRoom.id] ??
                                    0;

                                final lastMessage =
                                    chatRoom.lastMessage.toString();

                                final hasUnread = unreadCount > 0 ||
                                    (chatRoom.isMessage == currentEmail &&
                                        chatRoom.isMessage != 'seen');

                                return Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(18),
                                    onTap: () async {
                                      final chatRoomId = await context
                                          .read<ChatProvider>()
                                          .createOrGetChatRoom(
                                            otherUser.email,
                                            '',
                                          );

                                      if (!context.mounted) return;

                                      context
                                          .read<ChatProvider>()
                                          .updateMessageStatus(chatRoomId);

                                      Get.to(
                                        () => ChatScreen(
                                          userUID: otherUser.id,
                                          name: otherUser.name,
                                          image: otherUser.image,
                                          otherEmail: otherUser.email,
                                          chatRoomId: chatRoomId,
                                        ),
                                      );

                                      await chatProvider
                                          .getUnreadMessageCount(chatRoom.id);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        children: [
                                          Stack(
                                            children: [
                                              CircleAvatar(
                                                radius: 27,
                                                backgroundColor: primaryColor
                                                    .withValues(alpha: 0.1),
                                                backgroundImage:
                                                    otherUser.image.isNotEmpty
                                                        ? NetworkImage(
                                                            otherUser.image)
                                                        : null,
                                                child: otherUser.image.isEmpty
                                                    ? const Icon(
                                                        Icons.person_rounded,
                                                        color: primaryColor,
                                                        size: 28,
                                                      )
                                                    : null,
                                              ),
                                              Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color: hasUnread
                                                        ? primaryColor
                                                        : const Color(
                                                            0xFFB8B8C5),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 13),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  otherUser.name.isNotEmpty
                                                      ? otherUser.name
                                                      : otherUser.email,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF202033),
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  lastMessage.isNotEmpty
                                                      ? lastMessage
                                                      : 'Start a conversation',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: hasUnread
                                                        ? const Color(
                                                            0xFF45455A)
                                                        : const Color(
                                                            0xFF85859A),
                                                    fontWeight: hasUnread
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          if (unreadCount > 0)
                                            Container(
                                              constraints: const BoxConstraints(
                                                minWidth: 22,
                                                minHeight: 22,
                                              ),
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 6,
                                              ),
                                              decoration: const BoxDecoration(
                                                color: primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                unreadCount > 99
                                                    ? '99+'
                                                    : '$unreadCount',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          else
                                            const Icon(
                                              Icons.chevron_right_rounded,
                                              color: Color(0xFFB0B0BF),
                                              size: 22,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            : const NoUserWidget(title: 'Required Login'),
      ),
    );
  }
}
