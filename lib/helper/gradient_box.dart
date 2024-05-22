import 'package:biouwa/constant.dart';
import 'package:flutter/material.dart';
class GradientBox extends StatelessWidget {
  final double width,height;
  const GradientBox({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration:  const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
          colors: [
            primaryColor,
            secondaryColor,
          ],
        ),
      ),
    );
  }
}
