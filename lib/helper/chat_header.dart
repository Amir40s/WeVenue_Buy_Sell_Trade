// import 'package:biouwa/constant.dart';
// import 'package:biouwa/helper/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ChatHeader extends StatelessWidget {
//   final String imageUrl, name;
//
//   const ChatHeader({
//     super.key,
//     required this.imageUrl,
//     required this.name,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10.0),
//       decoration: const BoxDecoration(
//           color: primaryColor,
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(10.0),
//             bottomRight: Radius.circular(10.0),
//           )),
//       child: Row(
//         children: [
//           GestureDetector(
//               onTap: () {
//                 Get.back();
//               },
//               child: const Icon(
//                 Icons.arrow_back,
//                 color: Colors.white,
//               )),
//           const SizedBox(
//             width: 10.0,
//           ),
//           SizedBox(
//             width: 50.0,
//             height: 50.0,
//             child: imageUrl.isNotEmpty && imageUrl != ''
//                 ? CircleAvatar(
//                     backgroundImage: NetworkImage(imageUrl),
//                   )
//                 : const CircleAvatar(
//                     child: Center(
//                       child: Icon(Icons.question_mark),
//                     ),
//                   ),
//           ),
//           const SizedBox(
//             width: 10.0,
//           ),
//           TextWidget(
//             text: name,
//             size: 14.0,
//             color: Colors.white,
//             isBold: true,
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatHeader extends StatelessWidget {
  final String imageUrl, name, otherEmail;

  const ChatHeader({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.otherEmail,
  });

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Report User"),
        content: Text("Are you sure you want to report this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              FirebaseFirestore.instance.collection('userReports').add({
                'reportedBy': auth.currentUser?.email,
                'reportedUser': otherEmail,
                'timestamp': FieldValue.serverTimestamp(),
              });

              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                  "User has been reported.",
                )),
              );
            },
            child: Text("Report", style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          SizedBox(width: 10.0),
          Container(
            width: 50.0,
            height: 50.0,
            child: imageUrl.isEmpty || imageUrl == ''
                ? CircleAvatar(
                    child: Center(
                      child: Icon(Icons.person),
                    ),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                  ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: TextWidget(
              text: name,
              size: 14.0,
              color: Colors.white,
              isBold: true,
            ),
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'report') {
                _showReportDialog(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'report',
                child: Text('Report User'),
              )
            ],
            icon: Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
