import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NoUserWidget extends StatelessWidget {
  const NoUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Images.noData,
                height: Get.height * 0.35,
              ),
              const SizedBox(height: 24),
              TextWidget(
                text: 'No User Found',
                size: 18,
                isBold: true,
              ),
              const SizedBox(height: 8),
              TextWidget(
                text:
                    'It looks like you’re not logged in or don’t have an account yet.',
                size: 14,
                color: Colors.grey,
                textAlignment: TextAlign.center,
              ),
              SizedBox(height: Get.height * 0.05)
            ],
          ),
        ),
      ),
    );
  }
}
