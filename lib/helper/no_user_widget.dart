import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/screens/login/login_screen.dart';
import 'package:biouwa/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NoUserWidget extends StatelessWidget {
  const NoUserWidget({super.key, this.msj, this.title});

  final String? msj;
  final String? title;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey.shade300,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   Images.noData,
              //   height: Get.height * 0.35,
              // ),
              const SizedBox(height: 24),
              TextWidget(
                text: title ?? 'No User Found',
                size: 18,
                isBold: true,
              ),
              const SizedBox(height: 8),
              TextWidget(
                text: msj ??
                    'You are not logged in. Please log in or sign up to continue using the app.',
                size: 14,
                color: Colors.grey,
                textAlignment: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.offAll(LoginScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {
                      // Add your signup navigation logic here
                      Get.offAll(SignupScreen());
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
