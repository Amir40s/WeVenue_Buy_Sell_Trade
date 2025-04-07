import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final width, height;
  final loadingMesasge;
  var textColor, borderColor, isShadow;

  double radius;

  ButtonWidget(
      {super.key,
      required this.text,
      required this.onClicked,
      required this.width,
      required this.height,
      this.radius = 20.0,
      this.textColor = Colors.white,
      this.borderColor = primaryColor,
      this.isShadow = true,
      this.loadingMesasge = "Loading.."});

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? CupertinoButton(
          color: primaryColor,
          onPressed: onClicked,
          borderRadius: BorderRadius.circular(20.0),
          padding: EdgeInsets.symmetric(horizontal: width / 3.5),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: textColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        )
      : GestureDetector(
          onTap: onClicked,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              // gradient:  const LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   stops: [0.0, 1.0],
              //   colors: [
              //     primaryColor,
              //     lightPink,
              //   ],
              // ),
              color: primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: isShadow ? 2 : 0,
                  blurRadius: isShadow ? 5 : 0,
                  offset: Offset(
                    isShadow ? 0 : 0,
                    isShadow ? 3 : 0,
                  ),
                ),
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
        );
}
