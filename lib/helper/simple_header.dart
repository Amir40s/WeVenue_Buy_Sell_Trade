import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SimpleHeader extends StatelessWidget {
  final suffixText,prefixText;
  bool isSuffix;
  final suffixTextSize, prefixTextSize;
   SimpleHeader({super.key, this.suffixText = "BioUWa",
     this.isSuffix = false,this.prefixText = "",
     this.suffixTextSize = 14.0, this.prefixTextSize=14.0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       Row(children: [
         GestureDetector(
             onTap: (){
               Get.back();
             },
             child: Image.asset(AppIcons.ic_back,height: 35.0,width: 35.0,)
         ),
         SizedBox(width: 10.0,),
         if(isSuffix)
         TextWidget(text: prefixText, size: prefixTextSize,isBold: true,),
       ],),
        TextWidget(text: suffixText, size: suffixTextSize,isBold: true,)
      ],
    );
  }
}
