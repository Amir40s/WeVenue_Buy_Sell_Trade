import 'dart:ui';

import 'package:biouwa/screens/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

const primaryColor = Color(0xFFC60AF5);
const darkPurple = Color(0xFF7132F5);
const secondaryColor = Color(0xFFF857A6);
const orangeColor = Color(0xFFE25D6C);
const whiteColor = Color(0xFFFFFFFF);
const lightPink = Color(0xFFC1839F);
const bgColor = Color(0xFFFBF9F9);
const drawerBackground = Color(0xFF212332);
const lightGrey = Color(0xFFE2E8F0);
const darkGrey = Color(0xFF534F5D);
const lightBlue = Colors.lightBlue;
const Color customGrey = Color(0xFFE0E0E0);


LinearGradient gradientColor = const LinearGradient(colors: [

  Color(0xff0fabaa),
  Color(0xff3EC2C2),
  Color(0xff40d5d4),
  Color(0xff8ae5e5),
  // Color(0xffFFFFFF),
]);

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

void showSnackBar({required title, required subtitle}){
  Get.snackbar(title, subtitle,colorText: Colors.black);
}


logout(){
  auth.signOut().then((value){
    Get.offAll(()=> LoginScreen());
  }).catchError((e){
    Get.offAll(()=> LoginScreen());
  });
}

customDialog({required VoidCallback onClick,required title,required content
,  textYes = "Yes", textNo = "No"}){
  Get.defaultDialog(
    title: title,
    content: Text(content),
    textCancel: textNo,
    textConfirm: textYes,
    onConfirm: onClick,
  );
}