import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomListTile extends StatelessWidget {
  final String icon, title, subtitle;
  final VoidCallback press;
  final double width, height;
  final double? space;

  const CustomListTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.press,
      this.width = 30,
      this.height = 30,
      this.space});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // icon.endsWith('.svg')
            //     ? SvgPicture.asset(
            //         icon,
            //         width: width,
            //         height: height,
            //       )
            //     : Image.asset(
            //         icon,
            //         width: width,
            //         height: height,
            //       ),
            SizedBox(
              width: space ?? Get.width * 0.050,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: title, size: 18.0),
                const SizedBox(height: 2.0),
                TextWidget(text: subtitle, size: 12.0),
              ],
            )
          ],
        ),
      ),
    );
  }
}
