import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/custom_textfield.dart';
import 'package:biouwa/helper/simple_header.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MoveServices extends StatelessWidget {
   MoveServices({super.key});

  var phoneController = TextEditingController();
  var dateController = TextEditingController();
  var departureController = TextEditingController();
  var arrivalController = TextEditingController();
  var timeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SimpleHeader(isSuffix: true,
                  prefixText: "Moving",
                  prefixTextSize: 22.0,
                  suffixText: "X",
                suffixTextSize: 22.0,),

                const SizedBox(height: 40.0,),
                TextWidget(text: "Phone Number", size: 14.0, isBold: true),
                const SizedBox(height: 10.0,),
                CustomTextField(hintText: "+11", controller: phoneController),

                const SizedBox(height: 20.0,),
                TextWidget(text: "Date", size: 14.0, isBold: true),
                const SizedBox(height: 10.0,),
                CustomTextField(hintText: "select date", controller: phoneController),

                const SizedBox(height: 20.0,),
                TextWidget(text: "Departure Address", size: 14.0, isBold: true),
                const SizedBox(height: 10.0,),
                CustomTextField(hintText: "enter departure address", controller: phoneController),

                const SizedBox(height: 20.0,),
                TextWidget(text: "Arrival Address", size: 14.0, isBold: true),
                const SizedBox(height: 10.0,),
                CustomTextField(hintText: "enter arrival address", controller: phoneController),

                const SizedBox(height: 20.0,),
                TextWidget(text: "Time", size: 14.0, isBold: true),
                const SizedBox(height: 10.0,),
                CustomTextField(hintText: "select Time", controller: phoneController),

                const SizedBox(height: 50.0,),
                ButtonWidget(text: "Ship my Product", onClicked: (){}, width: Get.width, height: 50.0)


              ],
            ),
          ),
        ),
      ),
    );
  }
}
