import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/provider/bottom_bar/bottom_bar_provider.dart';
import 'package:biouwa/screens/dashboard/relocation/widget/re_input_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../helper/images.dart';
import '../../../helper/no_user_widget.dart';

class RelocationScreen extends StatelessWidget {
  RelocationScreen({super.key});

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final typesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bottomProvider = Provider.of<BottomBarProvider>(context);
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: bottomProvider.isLoggedIn
            ? Container(
                width: Get.width,
                height: Get.height,
                padding: const EdgeInsets.all(20.0),
                margin: EdgeInsets.only(top: Get.width * 0.400),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Get.width * 0.080),
                        topRight: Radius.circular(Get.width * 0.080)),
                    color: lightGrey),
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
                              colors: [primaryColor, orangeColor],
                            ),
                          ),
                          child: TextWidget(
                            text: "Relocation",
                            size: 20.0,
                            color: Colors.white,
                            isBold: true,
                            textAlignment: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ReInputField(
                        hintText: "From",
                        controller: fromController,
                        prefixPath: AppIcons.ic_arrow_forward,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ReInputField(
                        hintText: "To",
                        controller: toController,
                        prefixPath: AppIcons.ic_location,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ReInputField(
                        hintText: "Departure Date",
                        controller: dateController,
                        prefixPath: AppIcons.ic_calender,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ReInputField(
                        hintText: "Types of relocation",
                        controller: typesController,
                        prefixPath: AppIcons.ic_type,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ReInputField(
                        hintText: "Departure Clock",
                        controller: timeController,
                        prefixPath: AppIcons.ic_clock,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle form submission
                          if (kDebugMode) {
                            print(
                                "Search pressed: ${fromController.text} to ${toController.text}");
                          }
                        },
                        child: Container(
                          width: Get.width,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: const LinearGradient(
                                colors: [primaryColor, orangeColor]),
                          ),
                          child: TextWidget(
                            text: "Let's Search",
                            size: 20.0,
                            color: Colors.white,
                            isBold: true,
                            textAlignment: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const NoUserWidget(),
      ),
    );
  }
}
