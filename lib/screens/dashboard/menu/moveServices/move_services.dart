import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/custom_textfield.dart';
import 'package:biouwa/helper/simple_header.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoveServices extends StatelessWidget {
  MoveServices({super.key});

  final _formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final dateController = TextEditingController();
  final departureController = TextEditingController();
  final arrivalController = TextEditingController();
  final timeController = TextEditingController();

  Future<String> selectDate(
    BuildContext context, {
    DateTime? initialPickedDate,
  }) async {
    final DateTime now = DateTime.now();
    final DateTime lastDate = DateTime(now.year, now.month, now.day);

    DateTime initialDate =
        initialPickedDate != null && initialPickedDate.isBefore(lastDate)
            ? initialPickedDate
            : lastDate;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: lastDate,
    );

    if (picked != null) {
      return formatDate(picked);
    }
    return '';
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SimpleHeader(
                    isSuffix: true,
                    prefixText: "Moving",
                    prefixTextSize: 22.0,
                    suffixText: "X",
                    suffixTextSize: 22.0,
                  ),
                  const SizedBox(height: 40.0),
                  TextWidget(text: "Phone Number", size: 14.0, isBold: true),
                  const SizedBox(height: 10.0),
                  CustomTextField(
                    hintText: "+11",
                    controller: phoneController,
                    error: "Please enter a valid phone number",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20.0),
                  TextWidget(text: "Date", size: 14.0, isBold: true),
                  const SizedBox(height: 10.0),
                  CustomTextField(
                    hintText: "Select date",
                    controller: dateController,
                    error: "Please select a date",
                    callback: () async {
                      String selectedDate = await selectDate(context);
                      dateController.text = selectedDate;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextWidget(
                      text: "Departure Address", size: 14.0, isBold: true),
                  const SizedBox(height: 10.0),
                  CustomTextField(
                    hintText: "Enter departure address",
                    controller: departureController,
                    error: "Please enter departure address",
                  ),
                  const SizedBox(height: 20.0),
                  TextWidget(text: "Arrival Address", size: 14.0, isBold: true),
                  const SizedBox(height: 10.0),
                  CustomTextField(
                    hintText: "Enter arrival address",
                    controller: arrivalController,
                    error: "Please enter arrival address",
                  ),
                  const SizedBox(height: 20.0),
                  TextWidget(text: "Time", size: 14.0, isBold: true),
                  const SizedBox(height: 10.0),
                  CustomTextField(
                    hintText: "Select Time",
                    controller: timeController,
                    error: "Please select a time",
                  ),
                  const SizedBox(height: 50.0),
                  ButtonWidget(
                    text: "Ship my Product",
                    onClicked: () {
                      if (_formKey.currentState!.validate()) {
                        Get.snackbar(
                          "Success",
                          "All fields are valid. Proceeding...",
                          backgroundColor: Colors.transparent,
                          colorText: Colors.black,
                        );
                      }
                    },
                    width: Get.width,
                    height: 50.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
