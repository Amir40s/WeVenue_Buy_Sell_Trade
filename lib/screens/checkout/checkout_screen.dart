import 'package:biouwa/helper/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant.dart';
import '../../helper/button_widget.dart';
import '../../helper/custom_textfield.dart';
import '../../helper/order_progress_bar.dart';
import '../../helper/simple_header.dart';
class CheckoutScreen extends StatelessWidget {
   CheckoutScreen({super.key});

  var addressController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SimpleHeader(),
            SizedBox(height: 20.0,),
            OrderProgressIndicator(progress: 0.38,),
            SizedBox(height: 20.0,),
            TextWidget(text: "Default Address", size: 14.0),
            SizedBox(height: 10.0,),
            CustomTextField(hintText: 'Enter Default Address', controller: addressController,fillColor: customGrey,),

            SizedBox(height: 10.0,),
            TextWidget(text: "Full Name", size: 14.0),
            SizedBox(height: 10.0,),
            CustomTextField(hintText: 'Enter your Name', controller: nameController,fillColor: customGrey,),

            SizedBox(height: 10.0,),
            TextWidget(text: "Phone Number", size: 14.0),
            SizedBox(height: 10.0,),
            CustomTextField(hintText: 'Enter Phone Number', controller: phoneController,fillColor: customGrey,),

            SizedBox(height: 40.0,),
            ButtonWidget(text: 'Continue',width: Get.width,height: 50.0,onClicked: (){

            },radius: 10.0,)
          ],
          ),
        ),
      ),
    );
  }
}
