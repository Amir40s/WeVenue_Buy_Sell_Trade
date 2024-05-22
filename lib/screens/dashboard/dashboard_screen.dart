import 'package:biouwa/helper/custom_textfield.dart';
import 'package:biouwa/screens/dashboard/menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/header.dart';
import '../../helper/images.dart';
import '../../helper/search_field.dart';
class DashboardScreen extends StatelessWidget {
   DashboardScreen({super.key});

  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Header(menuPress: (){
                Get.to(()=> MenuScreen());
              },),

              SizedBox(height: 20.0,),
              SearchField(hintText: "search for books, guitar and more", controller: searchController,suffixPath: AppIcons.ic_logo,)


            ],
          ),
        ),
      ),
    );
  }
}
