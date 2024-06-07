import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant.dart';


class ButtonLoadingWidget extends StatelessWidget {
  final width,height;
  final loadingMesasge;
  var textColor,borderColor,isShadow;

  double radius;

  ButtonLoadingWidget({
    Key? key,
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
      Container(
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
                offset: Offset( isShadow ? 0 : 0, isShadow ? 3 : 0), // changes position of shadow
              ),
            ]
        ),
        child: Center(
          child:   Text(
            '$loadingMesasge, please wait',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
}