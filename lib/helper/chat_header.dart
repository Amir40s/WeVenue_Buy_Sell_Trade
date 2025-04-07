import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatHeader extends StatelessWidget {
  final String imageUrl, name;

  const ChatHeader({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          )),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          const SizedBox(
            width: 10.0,
          ),
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: imageUrl.isNotEmpty && imageUrl != ''
                ? CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                  )
                : const CircleAvatar(
                    child: Center(
                      child: Icon(Icons.question_mark),
                    ),
                  ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          TextWidget(
            text: name,
            size: 14.0,
            color: Colors.white,
            isBold: true,
          )
        ],
      ),
    );
  }
}
