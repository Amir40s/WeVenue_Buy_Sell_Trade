import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class BorderButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final width,height;
  final loadingMesasge;
  var textColor,borderColor,isShadow;

  double radius;

  BorderButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    required this.width,
   required this.height,
     this.radius = 20.0,
     this.textColor = Colors.white,
     this.borderColor = primaryColor,
     this.isShadow = true,
     this.loadingMesasge = "Loading.."
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>

      GestureDetector(
        onTap: onClicked,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: primaryColor),
              color: Colors.transparent,

          ),
          child: Center(
            child: Text(
              text,
              style:  TextStyle(fontSize: 15, color: textColor,fontWeight: FontWeight.w900),
            ),
          ),
        ),
      );
}