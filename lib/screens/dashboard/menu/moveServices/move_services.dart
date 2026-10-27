import 'package:biouwa/constant.dart';
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

  static const Color _background = Color(0xFFF7F8FA);
  static const Color _cardColor = Color(0xFFFFFFFF);
  static const Color _textColor = Color(0xFF202033);
  static const Color _mutedText = Color(0xFF85859A);
  static const Color _borderColor = Color(0xFFEEEEF4);

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

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      return formatDate(picked);
    }

    return '';
  }

  String formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextWidget(
        text: text,
        size: 14.0,
        isBold: true,
      ),
    );
  }

  Widget _formCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: darkPurple.withValues(alpha: 0.035),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: SimpleHeader(
                isSuffix: true,
                prefixText: 'Moving',
                prefixTextSize: 22.0,
                suffixText: 'X',
                suffixTextSize: 22.0,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [darkPurple, primaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.local_shipping_outlined,
                                color: Colors.white,
                                size: 27,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Moving Services',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Enter your shipment details below',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'Shipment Details',
                        style: TextStyle(
                          color: _textColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Provide the information for your move.',
                        style: TextStyle(
                          color: _mutedText,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _formCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionLabel('Phone Number'),
                            CustomTextField(
                              hintText: '+11',
                              controller: phoneController,
                              error: 'Please enter a valid phone number',
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 22),
                            _sectionLabel('Date'),
                            CustomTextField(
                              hintText: 'Select date',
                              controller: dateController,
                              error: 'Please select a date',
                              callback: () async {
                                final String selectedDate =
                                    await selectDate(context);
                                dateController.text = selectedDate;
                              },
                            ),
                            const SizedBox(height: 22),
                            _sectionLabel('Departure Address'),
                            CustomTextField(
                              hintText: 'Enter departure address',
                              controller: departureController,
                              error: 'Please enter departure address',
                            ),
                            const SizedBox(height: 22),
                            _sectionLabel('Arrival Address'),
                            CustomTextField(
                              hintText: 'Enter arrival address',
                              controller: arrivalController,
                              error: 'Please enter arrival address',
                            ),
                            const SizedBox(height: 22),
                            _sectionLabel('Time'),
                            CustomTextField(
                              hintText: 'Select Time',
                              controller: timeController,
                              error: 'Please select a time',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      ButtonWidget(
                        text: 'Ship my Product',
                        onClicked: () {
                          if (_formKey.currentState!.validate()) {
                            Get.snackbar(
                              'Success',
                              'All fields are valid. Proceeding...',
                              backgroundColor: Colors.transparent,
                              colorText: _textColor,
                            );
                          }
                        },
                        width: Get.width,
                        height: 52.0,
                        radius: 16.0,
                        isShadow: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
