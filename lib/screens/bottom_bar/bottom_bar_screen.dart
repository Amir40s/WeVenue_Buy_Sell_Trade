import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../helper/images.dart';
import '../../provider/bottom_bar/bottom_bar_provider.dart';
import '../uploadItems/items_upload_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final double defaultIconSize = 20.0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BottomBarProvider>(context, listen: false).refreshStatus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bottomBarProvider =
    Provider.of<BottomBarProvider>(context, listen: false);

    return Platform.isAndroid
        ? Scaffold(
      backgroundColor: lightGrey,
      resizeToAvoidBottomInset: false,
      body: Consumer<BottomBarProvider>(
        builder: (context, value, child) {
          return value.myList[value.myIndex];
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.5,
        color: darkGrey,
        surfaceTintColor: Colors.transparent,
        child: Consumer<BottomBarProvider>(
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    bottomBarProvider.changeMyIndex(0);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppIcons.ic_home,
                        height: defaultIconSize,
                        color: value.myIndex == 0
                            ? Colors.white
                            : Colors.grey,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "HOME",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: value.myIndex == 0
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(width: Get.width*0.125,),
                GestureDetector(
                  onTap: () {
                    bottomBarProvider.changeMyIndex(1);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppIcons.ic_chat,
                        height: defaultIconSize,
                        color: value.myIndex == 1
                            ? Colors.white
                            : Colors.grey,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "CHATS",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: value.myIndex == 1
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    bottomBarProvider.changeMyIndex(2);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(null),
                      SizedBox(height: Get.width * 0.010),
                      // SizedBox(height: Get.width * 0.010),
                      SizedBox(width: Get.width * 0.010),
                      const Text(
                        "PUBLISH",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    bottomBarProvider.changeMyIndex(2);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppIcons.ic_relocation,
                        height: defaultIconSize,
                        color: value.myIndex == 2
                            ? Colors.white
                            : Colors.grey,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "RELOCATION",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: value.myIndex == 2
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    bottomBarProvider.changeMyIndex(3);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppIcons.ic_person,
                        height: defaultIconSize,
                        color: value.myIndex == 3
                            ? Colors.white
                            : Colors.grey,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "Account",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: value.myIndex == 3
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Consumer<BottomBarProvider>(
        builder: (context, value, child) {
          return FloatingActionButton.large(
            backgroundColor: Colors.transparent,
            focusElevation: 0.0,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightElevation: 0.0,
            disabledElevation: 0.0,
            elevation: 0.0,
            onPressed: () {
              Get.to(() => ItemsUploadScreen());
            },
            child: Image.asset(
              AppIcons.ic_add,
              height: 200.0,
            ),
          );
        },
      ),
    )
        : Scaffold(
      backgroundColor: lightGrey,
      resizeToAvoidBottomInset: false,
      body: Consumer<BottomBarProvider>(
        builder: (context, value, child) {
          return value.myList[value.myIndex];
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.5,
        color: darkGrey,
        surfaceTintColor: Colors.transparent,
        child: Consumer<BottomBarProvider>(
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    bottomBarProvider.changeMyIndex(0);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppIcons.ic_home,
                        height: defaultIconSize,
                        color: value.myIndex == 0
                            ? Colors.white
                            : Colors.grey,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "HOME",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: value.myIndex == 0
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(width: Get.width*0.125,),

                GestureDetector(
                  onTap: () {
                    bottomBarProvider.changeMyIndex(1);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.public,
                        color: value.myIndex == 1
                            ? Colors.white
                            : Colors.grey,
                      ),
                      SizedBox(height: Get.width * 0.010),
                      // SizedBox(height: Get.width * 0.010),
                      SizedBox(width: Get.width * 0.010),
                      const Text(
                        "PUBLISH",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    bottomBarProvider.changeMyIndex(3);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppIcons.ic_relocation,
                        height: defaultIconSize,
                        color: value.myIndex == 3
                            ? Colors.white
                            : Colors.grey,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "RELOCATION",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: value.myIndex == 3
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    bottomBarProvider.changeMyIndex(4);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppIcons.ic_person,
                        height: defaultIconSize,
                        color: value.myIndex == 4
                            ? Colors.white
                            : Colors.grey,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "Account",
                        style: TextStyle(
                          fontSize: 10.0,
                          color: value.myIndex == 4
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniCenterDocked,
      // floatingActionButton: Consumer<BottomBarProvider>(
      //   builder: (context, value, child) {
      //     return FloatingActionButton.large(
      //       backgroundColor: Colors.transparent,
      //       focusElevation: 0.0,
      //       splashColor: Colors.transparent,
      //       focusColor: Colors.transparent,
      //       highlightElevation: 0.0,
      //       disabledElevation: 0.0,
      //       elevation: 0.0,
      //       onPressed: () {
      //         Get.to(() => ItemsUploadScreen());
      //       },
      //       child: Image.asset(
      //         AppIcons.ic_add,
      //         height: 200.0,
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
