import 'dart:io';

import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/custom_listtile.dart';
import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/simple_header.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/provider/account/account_provider.dart';
import 'package:biouwa/screens/dashboard/account/account_screen.dart';
import 'package:biouwa/screens/dashboard/menu/moveServices/move_services.dart';
import 'package:biouwa/screens/dashboard/menu/myListing/my_listing_screen.dart';
import 'package:biouwa/screens/saveItems/save_items_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../faq/faq_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SimpleHeader(),
                const SizedBox(
                  height: 40.0,
                ),
                TextWidget(
                  text: "Settings",
                  size: 24.0,
                  isBold: true,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 40.0,
                ),
                CustomListTile(
                  icon: AppIcons.ic_person,
                  title: "Account Setting",
                  subtitle: "edit your details, account setting",
                  press: () {
                    Get.to(
                      () => AccountScreen(
                          type: "edit",
                          image: Provider.of<AccountProvider>(context,
                                  listen: false)
                              .image
                              .toString()),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                CustomListTile(
                    icon: AppIcons.ic_eye,
                    title: "Moving Services",
                    subtitle: "check mover available",
                    press: () {
                      Get.to(() => MoveServices());
                    }),
                const SizedBox(
                  height: 20.0,
                ),
                CustomListTile(
                    icon: AppIcons.ic_bell,
                    title: "My Listing",
                    subtitle: "view your products listing",
                    press: () {
                      Get.to(() => const MyListingScreen());
                    }),
                const SizedBox(
                  height: 20.0,
                ),
                CustomListTile(
                    icon: AppIcons.ic_layers,
                    title: "Saved Items",
                    subtitle: "See your wishlist products",
                    press: () {
                      Get.to(() => const SaveItemsScreen());
                    }),
                const SizedBox(
                  height: 20.0,
                ),
                // CustomListTile(
                //     icon: AppIcons.ic_orders,
                //     title: "My orders",
                //     subtitle: "view all your order",
                //     press: () {}),
                // const SizedBox(
                //   height: 20.0,
                // ),
                CustomListTile(
                    icon: AppIcons.ic_faq,
                    title: "FAQ",
                    subtitle: "check all faq question",
                    press: () {
                      Get.to(() => const FAQScreen());
                    }),
                const SizedBox(
                  height: 20.0,
                ),
                CustomListTile(
                  icon: AppIcons.ic_delete,
                  title: "Delete Account",
                  width: 30,
                  height: 38,
                  space: Get.width * 0.030,
                  subtitle: "Delete your account permanently",
                  press: () {
                    showReAuthDialog(context);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CustomListTile(
                  icon: AppIcons.ic_logout,
                  title: "Logout",
                  subtitle: "logout your account",
                  press: () {
                    Platform.isIOS
                        ? showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: const Text("Logout"),
                              content: const Text(
                                  "Are you sure you want to logout?"),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text("No"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: const Text("Yes"),
                                  onPressed: () {
                                    logout(); // Your logout logic here
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          )
                        : Get.defaultDialog(
                            title: "Logout",
                            content: const Text("Are you sure want to logout?"),
                            textCancel: "No",
                            textConfirm: "Yes",
                            onConfirm: () {
                              logout();
                            },
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
