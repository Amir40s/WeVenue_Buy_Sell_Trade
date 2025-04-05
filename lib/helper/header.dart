import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/provider/bottom_bar/bottom_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../provider/cart/cart_provider.dart';
import '../screens/cart/cart_screen.dart';

class Header extends StatelessWidget {
  VoidCallback? menuPress;

  Header({super.key, this.menuPress});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomBarProvider>(builder: (context, provider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage(AppIcons.ic_logo),
              ),
              const SizedBox(
                width: 5.0,
              ),
              TextWidget(text: "Welcome back", size: 14.0)
            ],
          ),
          Row(
            children: [
              //CustomIconsButton(iconPath: AppIcons.ic_notification,),
              GestureDetector(
                onTap: provider.isLoggedIn
                    ? () {
                        Get.to(() => CartScreen());
                      }
                    : () {},
                child: Stack(children: [
                  const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 26,
                  ),
                  Positioned(
                    right: 0,
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return cart.itemCount > 0
                            ? CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                                child: Text(
                                  cart.itemCount.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              )
                            : Container();
                      },
                    ),
                  ),
                ]),
              ),
              const SizedBox(
                width: 10.0,
              ),
              const Icon(
                Icons.notifications,
                color: Colors.black,
                size: 26,
              ),
              // GestureDetector(
              //     onTap: menuPress,
              //     child: CustomIconsButton(iconPath: AppIcons.ic_menu,)),
            ],
          )
        ],
      );
    });
  }
}
