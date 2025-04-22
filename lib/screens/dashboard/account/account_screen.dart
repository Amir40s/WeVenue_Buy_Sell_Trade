import 'dart:developer';

import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/provider/account/account_provider.dart';
import 'package:biouwa/provider/bottom_bar/bottom_bar_provider.dart';
import 'package:biouwa/screens/dashboard/relocation/widget/re_input_field.dart';
import 'package:biouwa/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../helper/button_loading_widget.dart';
import '../../../helper/image_loader_widget.dart';
import '../../../helper/no_user_widget.dart';
import '../../../provider/constant/value_provider.dart';
import '../../../provider/data/image_provider.dart';

class AccountScreen extends StatefulWidget {
  final String type;
  final String image;

  const AccountScreen({
    super.key,
    required this.type,
    this.image = "",
  });

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);

    nameController = TextEditingController(text: accountProvider.name);
    emailController = TextEditingController(text: accountProvider.email);
    phoneController = TextEditingController(text: accountProvider.phone);
    addressController = TextEditingController(text: accountProvider.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider =
        Provider.of<ImagePickProvider>(context, listen: false);
    final bottomProvider = Provider.of<BottomBarProvider>(context);

    return Scaffold(
      backgroundColor: lightGrey,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: bottomProvider.isLoggedIn
            ? Container(
                width: Get.width,
                height: Get.height,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  child: Consumer<AccountProvider>(
                    builder: (context, accountProvider, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),

                          if (widget.type == "edit")
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                  image: const DecorationImage(
                                    image:
                                        AssetImage("assets/icons/ic_back.webp"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20.0),
                          TextWidget(
                            text: "Account",
                            size: 18.0,
                            isBold: true,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),

                          const SizedBox(height: 20.0),
                          if (widget.type == "edit")
                            Consumer<ImagePickProvider>(
                              builder: (context, prov, child) {
                                return GestureDetector(
                                  onTap: () {
                                    prov.pickProductImage();
                                  },
                                  child: prov.imageFile != null
                                      ? Align(
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: CircleAvatar(
                                            radius: 50.0,
                                            backgroundImage:
                                                FileImage(prov.imageFile!),
                                          ),
                                        )
                                      : Align(
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: CircleAvatar(
                                            radius: 50.0,
                                            child: ImageLoaderWidget(
                                              imageUrl: widget.image,
                                            ),
                                          ),
                                        ),
                                );
                              },
                            ),

                          if (widget.type == "bottom")
                            accountProvider.image != ""
                                ? Align(
                                    alignment: AlignmentDirectional.center,
                                    child: CircleAvatar(
                                      radius: 50.0,
                                      backgroundImage: NetworkImage(
                                          accountProvider.image.toString()),
                                      // child: ImageLoaderWidget(imageUrl: accountProvider.image.toString() ,),
                                    ),
                                  )
                                : const Align(
                                    alignment: AlignmentDirectional.center,
                                    child: CircleAvatar(
                                      radius: 50.0,
                                      backgroundColor: lightGrey,
                                      backgroundImage: AssetImage(
                                          "assets/icons/ic_profile_image.webp"),
                                      // child: ImageLoaderWidget(imageUrl: accountProvider.image.toString() ,),
                                    ),
                                  ),
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: TextWidget(
                              text: "My Account",
                              size: 18.0,
                              isBold: true,
                            ),
                          ),

                          const SizedBox(
                            height: 20.0,
                          ),
                          TextWidget(
                            text: "Name",
                            size: 14.0,
                            isBold: true,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ReInputField(
                            hintText: nameController.text =
                                accountProvider.name.toString(),
                            controller: nameController,
                          ),

                          const SizedBox(
                            height: 10.0,
                          ),
                          TextWidget(
                            text: "Email",
                            size: 14.0,
                            isBold: true,
                          ),
                          const SizedBox(height: 10.0),
                          ReInputField(
                            enabled: false,
                            hintText: emailController.text =
                                accountProvider.email.toString(),
                            controller: emailController,
                          ),

                          const SizedBox(
                            height: 10.0,
                          ),
                          TextWidget(
                            text: "Phone",
                            size: 14.0,
                            isBold: true,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ReInputField(
                            hintText: phoneController.text =
                                accountProvider.phone.toString(),
                            controller: phoneController,
                          ),

                          const SizedBox(
                            height: 10.0,
                          ),
                          // TextWidget(
                          //   text: "Address",
                          //   size: 14.0,
                          //   isBold: true,
                          // ),
                          // const SizedBox(
                          //   height: 10.0,
                          // ),
                          // ReInputField(
                          //   hintText: addressController.text =
                          //       accountProvider.address.toString(),
                          //   controller: addressController,
                          //   prefixPath: "",
                          //   isPrefix: false,
                          // ),

                          const SizedBox(
                            height: 40.0,
                          ),

                          if (widget.type == "bottom")
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const SettingScreen());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: appW * 0.03,
                                  vertical: appH * 0.01,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: primaryColor, width: 1),
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      AppIcons.ic_setting,
                                      height: 25,
                                      width: 30,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Settings',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          const SizedBox(height: 40.0),

                          if (widget.type == "edit")
                            Consumer<ValueProvider>(
                              builder: (context, provider, child) {
                                return provider.isLoading == false
                                    ? ButtonWidget(
                                        text: "Update",
                                        onClicked: () async {
                                          provider.setLoading(true);
                                          String? url;
                                          if (imageProvider.imageFile != null) {
                                            url =
                                                await imageProvider.uploadImage(
                                                    imageFile: imageProvider
                                                        .imageFile!);
                                          } else {
                                            url = accountProvider.image
                                                .toString();
                                          }
                                          accountProvider.updateUserProfile(
                                              name: nameController.text
                                                  .toString()
                                                  .trim(),
                                              email: emailController.text
                                                  .toString()
                                                  .trim(),
                                              phone: phoneController.text
                                                  .toString()
                                                  .trim(),
                                              address: addressController.text
                                                  .toString()
                                                  .trim(),
                                              image: url,
                                              context: context);
                                          log("Url: ${url.toString()}");
                                        },
                                        width: Get.width,
                                        height: 50.0)
                                    : ButtonLoadingWidget(
                                        loadingMesasge: "updating",
                                        width: Get.width,
                                        height: 50.0);
                              },
                            ),
                        ],
                      );
                    },
                  ),
                ),
              )
            : const NoUserWidget(),
      ),
    );
  }
}
