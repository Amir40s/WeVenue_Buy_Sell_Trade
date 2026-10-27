import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final double width;
  final double height;
  final double radius;
  final Color textColor;
  final Color borderColor;
  final bool isShadow;
  final String loadingMesasge;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onClicked,
    required this.width,
    required this.height,
    this.radius = 20.0,
    this.textColor = Colors.white,
    this.borderColor = primaryColor,
    this.isShadow = true,
    this.loadingMesasge = "Loading..",
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        color: primaryColor,
        onPressed: onClicked,
        borderRadius: BorderRadius.circular(radius),
        padding: EdgeInsets.symmetric(horizontal: width / 3.5),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15.0,
            color: textColor,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onClicked,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: primaryColor,
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: isShadow ? 2.0 : 0.0,
              blurRadius: isShadow ? 5.0 : 0.0,
              offset: Offset(0.0, isShadow ? 3.0 : 0.0),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15.0,
            color: textColor,
            fontWeight: FontWeight.w900,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
