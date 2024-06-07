import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/custom_listtile.dart';
import 'package:biouwa/helper/header.dart';
import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/simple_header.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/screens/dashboard/menu/moveServices/move_services.dart';
import 'package:biouwa/screens/dashboard/menu/myListing/my_listing_screen.dart';
import 'package:biouwa/screens/saveItems/save_items_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

                SimpleHeader(),
                SizedBox(height: 40.0,),
                TextWidget(text: "Settings", size: 24.0,isBold: true,color: Colors.black,),
                SizedBox(height: 40.0,),
                CustomListTile(
                    icon: AppIcons.ic_person,
                    title: "Account Setting",
                    subtitle: "edit your details, account setting",
                    press: (){}
                ),
                SizedBox(height: 20.0,),
                CustomListTile(
                    icon: AppIcons.ic_eye,
                    title: "Moving Services",
                    subtitle: "check mover available",
                    press: (){
                      Get.to(()=> MoveServices());
                    }
                ),
                SizedBox(height: 20.0,),
                CustomListTile(
                    icon: AppIcons.ic_bell,
                    title: "My Listing",
                    subtitle: "view your products listing",
                    press: (){
                      Get.to(()=> MyListingScreen());
                    }
                ),

                SizedBox(height: 20.0,),
                CustomListTile(
                    icon: AppIcons.ic_layers,
                    title: "Saved Items",
                    subtitle: "See your wishlist products",
                    press: (){
                      Get.to(()=> SaveItemsScreen());
                    }
                ),

                SizedBox(height: 20.0,),
                CustomListTile(
                    icon: AppIcons.ic_orders,
                    title: "My orders",
                    subtitle: "view all your order",
                    press: (){}
                ),

                SizedBox(height: 20.0,),
                CustomListTile(
                    icon: AppIcons.ic_faq,
                    title: "FAQ",
                    subtitle: "check all faq question",
                    press: (){
                      Get.to(()=> FAQScreen());
                    }
                ),

                SizedBox(height: 20.0,),
                CustomListTile(
                    icon: AppIcons.ic_logout,
                    title: "Logout",
                    subtitle: "logout your account",
                    press: (){
                     Get.defaultDialog(
                       title: "Logout",
                         content: Text("Are you sure want to logout?"),
                         textCancel: "No",
                         textConfirm: "Yes",
                     onConfirm: (){
                       logout();
                     },
                     );
                    }
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
