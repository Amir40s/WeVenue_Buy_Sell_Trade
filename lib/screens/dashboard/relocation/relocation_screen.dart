import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/screens/dashboard/relocation/widget/re_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/images.dart';
class RelocationScreen extends StatelessWidget {
   RelocationScreen({super.key});

  var fromController = TextEditingController();
  var toController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var typesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.only(top: Get.width * 0.400),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Get.width * 0.080),
                  topRight: Radius.circular(Get.width * 0.080)
              ),
              color: lightGrey
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Container(
                    width: Get.width * 0.400,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: primaryColor,
                        gradient: const LinearGradient(
                            colors: [
                              primaryColor,
                              orangeColor
                            ]
                        )
                    ),
                    child: TextWidget(
                      text: "Relocation",
                      size: 20.0,color: Colors.white,
                      isBold: true,
                      textAlignment: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 10.0,),

                ReInputField(
                  hintText: "From",
                  controller: fromController,
                  prefixPath: AppIcons.ic_arrow_forward,
                ),

                const SizedBox(height: 10.0,),

                ReInputField(
                  hintText: "To",
                  controller: toController,
                  prefixPath: AppIcons.ic_location,
                ),
                const SizedBox(height: 10.0,),

                ReInputField(
                  hintText: "Departure Date",
                  controller: dateController,
                  prefixPath: AppIcons.ic_calender,
                ),

                SizedBox(height: 10.0,),


                ReInputField(
                  hintText: "Types of relocation",
                  controller: typesController,
                  prefixPath: AppIcons.ic_type,
                ),

                SizedBox(height: 10.0,),

                ReInputField(
                  hintText: "Departure Clock",
                  controller: timeController,
                  prefixPath: AppIcons.ic_clock,
                ),

                SizedBox(height: 20.0,),

                Container(
                  width: Get.width,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: primaryColor,
                      gradient: LinearGradient(
                          colors: [
                            primaryColor,
                            orangeColor
                          ]
                      )
                  ),
                  child: TextWidget(
                    text: "Let's Search",
                    size: 20.0,color: Colors.white,
                    isBold: true,
                    textAlignment: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
