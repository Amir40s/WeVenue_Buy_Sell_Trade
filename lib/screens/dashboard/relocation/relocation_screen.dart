import 'dart:io';

import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../helper/no_user_widget.dart';
import '../../../provider/bottom_bar/bottom_bar_provider.dart';

class RelocationScreen extends StatelessWidget {
  RelocationScreen({super.key});

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final typesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                    topRight: Radius.circular(Get.width * 0.080),
                  ),
                  color: lightGrey,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
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
                        const SizedBox(height: 10.0),
                        ReInputField(
                          hintText: "From",
                          controller: fromController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the starting location';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        ReInputField(
                          hintText: "To",
                          controller: toController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the destination location';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        ReInputField(
                          hintText: "Departure Date",
                          controller: dateController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the departure date';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        ReInputField(
                          hintText: "Types of relocation",
                          controller: typesController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please specify the type of relocation';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        ReInputField(
                          hintText: "Departure Clock",
                          controller: timeController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the departure time';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (kDebugMode) {
                                print(
                                    "Search pressed: ${fromController.text} to ${toController.text}");
                              }
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
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const NoUserWidget(),
      ),
    );
  }
}

class ReInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Widget? prefix;
  final bool enabled;
  final String? Function(String?)? validator;

  ReInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.enabled = true,
    this.prefix,
    this.validator,
  });

  final isIos = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    return isIos
        ? CupertinoTextField(
            controller: controller,
            cursorColor: Colors.black,
            placeholder: hintText,
            placeholderStyle:
                const TextStyle(fontSize: 12.0, color: Colors.black),
            style: const TextStyle(color: Colors.black),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.white),
            ),
          )
        : TextFormField(
            controller: controller,
            cursorColor: Colors.black,
            validator: validator,
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              prefixIcon: prefix,
              fillColor: Colors.white,
              hintStyle: const TextStyle(fontSize: 12.0, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
          );
  }
}
