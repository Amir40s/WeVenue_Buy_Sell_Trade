import 'dart:developer';

import 'package:biouwa/constant/appString/app_string.dart';
import 'package:biouwa/helper/payment.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/provider/cart/cart_provider.dart';
import 'package:biouwa/provider/check_out/check_out_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../helper/button_widget.dart';
import '../../helper/custom_textfield.dart';
import '../../helper/order_progress_bar.dart';
import '../../helper/simple_header.dart';
import 'order_placed_screen.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen(
      {super.key, required this.totalProducts, required this.pPrice});

  final String totalProducts;
  final String pPrice;
  final addressController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final paymentC = Get.put(PaymentController());
    final checkoutP = Provider.of<CheckOutP>(context);
    final cartP = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SimpleHeader(),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const OrderProgressIndicator(
                    progress: 0.38,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextWidget(text: "Default Address", size: 14.0),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    hintText: 'Enter Default Address',
                    controller: addressController,
                    fillColor: customGrey,
                    error: '${AppString.fieldError}Default Address',
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextWidget(text: "Full Name", size: 14.0),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    hintText: 'Enter your Name',
                    controller: nameController,
                    fillColor: customGrey,
                    error: '${AppString.fieldError}your Name',
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextWidget(text: "Phone Number", size: 14.0),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    hintText: 'Enter Phone Number',
                    controller: phoneController,
                    fillColor: customGrey,
                    error: '${AppString.fieldError}Phone Number',
                  ),
                  const SizedBox(height: 40.0),
                  ButtonWidget(
                    text: 'Continue',
                    width: Get.width,
                    height: 50.0,
                    onClicked: () {
                      if (_formKey.currentState!.validate()) {
                        log(checkoutP.price);
                        paymentC.makePayment(
                            amount: cartP.totalAmount.toStringAsFixed(2),
                            successMsj: '',
                            onSuccess: () {
                              checkoutP.addOrder(
                                  address: addressController.text.trim(),
                                  userName: nameController.text.trim(),
                                  userPhone: phoneController.text.trim(),
                                  totalAmount: pPrice,
                                  totalItems: totalProducts);
                              Get.to(OrderPlacedScreen());
                            });
                      }
                    },
                    radius: 10.0,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
