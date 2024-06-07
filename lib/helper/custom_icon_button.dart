import 'package:flutter/material.dart';

import 'images.dart';
class CustomIconsButton extends StatelessWidget {
  final String iconPath;
  const CustomIconsButton({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        // border: Border.all(
        //   color: Colors.black,
        //   width: 1.0,
        // )
      ),
      child: Image.asset(iconPath,width: 23.0,height: 23.0,),
    );
  }
}
