import 'dart:async';

import 'package:biouwa/constant.dart';
import 'package:biouwa/constant/appString/app_string.dart';
import 'package:biouwa/helper/gradient_box.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

import '../helper/images.dart';
import '../model/app_string.dart';
import '../screens/bottom_bar/bottom_bar_screen.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 4),(){
      //Get.offAll(const ConfirmScreen());
      if(auth.currentUser !=null ){
        Get.offAll(()=> const BottomNavBar());
      }else{
        Get.offAll(LoginScreen());
      }

    });
    return Scaffold(
      backgroundColor: darkPurple,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppIcons.ic_logo,width:Get.width,height:150.0,fit: BoxFit.contain,),
                SizedBox(height: 20.0,),
                TextWidget(text: AppText.appName, size: 22.0,color: whiteColor,)

              ],
            ),
          ),

        ],
      ),
    );
  }
}
