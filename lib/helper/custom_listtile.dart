import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CustomListTile extends StatelessWidget {
  final icon,title,subtitle;
  final VoidCallback press;
  const CustomListTile({super.key, required this.icon, required this.title, required this.subtitle, required this.press});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 5.0,),
          Image.asset(icon,width: 30.0,height: 30.0,),
            SizedBox(width: Get.width * 0.050,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: title, size: 18.0),
                SizedBox(height: 5.0,),
                TextWidget(text: subtitle, size: 12.0),
              ],
            )
          ],
        ),
      ),
    );
  }
}
