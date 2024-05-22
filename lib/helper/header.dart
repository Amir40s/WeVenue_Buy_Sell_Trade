import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_icon_button.dart';
class Header extends StatelessWidget {
  VoidCallback? menuPress;
   Header({super.key, this.menuPress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(AppIcons.ic_logo),
            ),
            SizedBox(width: 5.0,),
            TextWidget(text: "Welcome back", size: 14.0)
          ],
        ),

        Row(
          children: [
            CustomIconsButton(iconPath: AppIcons.ic_notification,),
            SizedBox(width: 10.0,),
            GestureDetector(
                onTap: menuPress,
                child: CustomIconsButton(iconPath: AppIcons.ic_menu,)),
          ],
        )
      ],
    );
  }
}
