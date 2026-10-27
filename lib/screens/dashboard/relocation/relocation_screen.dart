import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/no_user_widget.dart';
import 'package:biouwa/screens/dashboard/relocation/widget/re_input_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/bottom_bar/bottom_bar_provider.dart';

class RelocationScreen extends StatelessWidget {
  RelocationScreen({super.key});

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final typesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const Color _background = Color(0xFFF7F8FA);
  static const Color _textColor = Color(0xFF202033);
  static const Color _mutedText = Color(0xFF85859A);
  static const Color _borderColor = Color(0xFFEEEEF4);

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text,
        style: const TextStyle(
          color: _textColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomProvider = Provider.of<BottomBarProvider>(context);

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: bottomProvider.isLoggedIn
            ? SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryColor, orangeColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.16),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Relocation Services',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Plan your move with your preferred locations, date, and time.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      'Moving Details',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Fill in the details to get started.',
                      style: TextStyle(
                        color: _mutedText,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: _borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: darkPurple.withValues(alpha: 0.035),
                            blurRadius: 18,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('Starting Location'),
                            ReInputField(
                              hintText: 'Enter starting location',
                              controller: fromController,
                              prefix: const Icon(Icons.trip_origin_rounded),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the starting location';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _fieldLabel('Destination'),
                            ReInputField(
                              hintText: 'Enter destination location',
                              controller: toController,
                              prefix: const Icon(Icons.location_on_outlined),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the destination location';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _fieldLabel('Departure Date'),
                            ReInputField(
                              hintText: 'Enter departure date',
                              controller: dateController,
                              prefix: const Icon(Icons.calendar_month_outlined),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the departure date';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _fieldLabel('Type of Relocation'),
                            ReInputField(
                              hintText: 'e.g. Home or office relocation',
                              controller: typesController,
                              prefix: const Icon(Icons.category_outlined),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please specify the type of relocation';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _fieldLabel('Departure Time'),
                            ReInputField(
                              hintText: 'Enter departure time',
                              controller: timeController,
                              prefix: const Icon(Icons.access_time_rounded),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the departure time';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 28),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [primaryColor, orangeColor],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          primaryColor.withValues(alpha: 0.18),
                                      blurRadius: 12,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (kDebugMode) {
                                        print(
                                          'Search pressed: ${fromController.text} to ${toController.text}',
                                        );
                                      }
                                    }
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Let's Search",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.arrow_forward_rounded,
                                          size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const NoUserWidget(),
      ),
    );
  }
}
