import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/provider/check_out/check_out_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../bottom_bar/bottom_bar_screen.dart';

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutP = Provider.of<CheckOutP>(context);
    return Scaffold(
      backgroundColor: lightGrey,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: appW * 0.09,
          vertical: appH * 0.025,
        ),
        child: ButtonWidget(
          text: 'Go Home',
          onClicked: () {
            Get.offAll(BottomNavBar());
          },
          width: appW * 0.6,
          height: appH * 0.05,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: appW * 0.05, vertical: appH * 0.1),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppIcons.ic_order,
                  height: appH * 0.1,
                ),
                SizedBox(
                  height: appH * 0.02,
                ),
                TextWidget(
                  text: 'Order Placed',
                  size: 23,
                  isBold: true,
                ),
                SizedBox(
                  height: appH * 0.025,
                ),
                TextWidget(
                  text: 'your order for \$ ${checkoutP.price} is placed',
                  size: 16,
                ),
                SizedBox(
                  height: appH * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: appW * 0.3,
                        height: appH * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          image:
                              DecorationImage(image: AssetImage(AppIcons.box)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      SizedBox(width: appW * 0.05),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: 'Total Items: ${checkoutP.totalProducts}',
                              isBold: true,
                            ),
                            TextWidget(
                              text: checkoutP.address,
                              maxLine: 2,
                            ),
                            TextWidget(
                              text: checkoutP.userPhone,
                            ),
                          ],
                        ),
                      )
                    ],
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
