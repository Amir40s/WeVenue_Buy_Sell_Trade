import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/bordder_button_widget.dart';
import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/screens/dashboard/menu/moveServices/move_services.dart';
import 'package:biouwa/screens/dashboard/menu/myListing/my_listing_screen.dart';
import 'package:biouwa/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/custom_listtile.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: "BioUwa",
                          size: 22.0,
                          isBold: true,
                        ),
                        TextWidget(text: "X", size: 22.0),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomListTile(
                      press: () {
                        Get.to(() => MoveServices());
                      },
                      icon: AppIcons.ic_name,
                      title: "Moving Services",
                      subtitle: "Check Mover Available",
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomListTile(
                      press: () {},
                      icon: AppIcons.ic_name,
                      title: "My Account",
                      subtitle: "Edit your details, account setting",
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomListTile(
                      press: () {},
                      icon: AppIcons.ic_name,
                      title: "My Orders",
                      subtitle: "view all your orders",
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomListTile(
                      press: () {
                        print("press");
                        Get.to(() => const MyListingScreen());
                      },
                      icon: AppIcons.ic_name,
                      title: "My Listings",
                      subtitle: "view your product listing for sale",
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    CustomListTile(
                      press: () {},
                      icon: AppIcons.ic_name,
                      title: "Like Items",
                      subtitle: "see the products you have wishlist",
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BorderButtonWidget(
                          text: "Feedback",
                          onClicked: () {},
                          width: Get.width * 0.4,
                          height: 50.0,
                          textColor: primaryColor,
                        ),
                        ButtonWidget(
                            text: "Sign out",
                            onClicked: () {
                              showDialogBox(context, "Sign out Alert",
                                  "are you sure to sign out?", () {
                                auth.signOut().whenComplete(() {
                                  Get.offAll(() => LoginScreen());
                                });
                              });
                            },
                            width: Get.width * 0.4,
                            height: 50.0)
                      ],
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Image.asset(
                Images.bottom_background,
                width: Get.width,
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showDialogBox(context, title, content, VoidCallback press) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'No'),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: press,
          child: const Text('sign out'),
        ),
      ],
    ),
  );
}
