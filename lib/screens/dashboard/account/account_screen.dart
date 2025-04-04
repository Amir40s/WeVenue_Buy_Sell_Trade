import 'dart:developer';

import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/provider/account/account_provider.dart';
import 'package:biouwa/screens/dashboard/relocation/widget/re_input_field.dart';
import 'package:biouwa/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../helper/button_loading_widget.dart';
import '../../../helper/image_loader_widget.dart';
import '../../../provider/data/image_provider.dart';
import '../../../provider/constant/value_provider.dart';
class AccountScreen extends StatelessWidget {
  final String type;
  String image;
  AccountScreen({
    super.key,
    required this.type,
    this.image = ""
  });

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImagePickProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: lightGrey,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Consumer<AccountProvider>(
              builder: (context, accountProvider, child){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 20.0,),
                    //back button
                    if(type == "edit")
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black,width: 0.5),
                          borderRadius: BorderRadius.circular(20.0),
                          image: const DecorationImage(
                            image: AssetImage("assets/icons/ic_back.webp"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    TextWidget(text: "Account", size: 18.0,isBold: true,),
                    const SizedBox(height: 10.0,),
                    // TextWidget(text: "Name", size: 14.0,isBold: true,),
                    // const SizedBox(height: 10.0,),
                    const SizedBox(height: 20.0,),
                    if(type == "edit")
                    Consumer<ImagePickProvider>(
                    builder: (context, prov, child){
                      return GestureDetector(
                        onTap: (){
                          prov.pickProductImage();
                        },
                        child: prov.imageFile !=null ?
                        Align(
                          alignment: AlignmentDirectional.center,
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: FileImage(prov.imageFile!),
                          ),
                        ) : Align(
                          alignment: AlignmentDirectional.center,
                          child: CircleAvatar(
                            radius: 50.0,
                            child: ImageLoaderWidget(imageUrl: image,),
                          )
                        ),
                      );
                    },
                    ),

                    if(type == "bottom")
                      accountProvider.image != "" ?
                    Align(
                        alignment: AlignmentDirectional.center,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(accountProvider.image.toString()),
                          // child: ImageLoaderWidget(imageUrl: accountProvider.image.toString() ,),
                        )
                    ) : const Align(
                          alignment: AlignmentDirectional.center,
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundColor: lightGrey,
                            backgroundImage: AssetImage("assets/icons/ic_profile_image.webp"),
                            // child: ImageLoaderWidget(imageUrl: accountProvider.image.toString() ,),
                          )
                      ),
                    Align(
                        alignment: AlignmentDirectional.center,
                        child: TextWidget(text: "My Account", size: 18.0,isBold: true,)),

                    const SizedBox(height: 20.0,),
                    TextWidget(text: "Name", size: 14.0,isBold: true,),
                    const SizedBox(height: 10.0,),
                    ReInputField(
                      hintText: nameController.text = accountProvider.name.toString(),
                      controller: nameController,
                      prefixPath: "",
                      isPrefix : false,
                    ),

                    const SizedBox(height: 10.0,),
                    TextWidget(text: "Email", size: 14.0,isBold: true,),
                    const SizedBox(height: 10.0,),
                    ReInputField(
                        hintText: emailController.text = accountProvider.email.toString(),
                        controller: emailController,
                        prefixPath: "",
                        isPrefix : false
                    ),

                    const SizedBox(height: 10.0,),
                    TextWidget(text: "Phone", size: 14.0,isBold: true,),
                    const SizedBox(height: 10.0,),
                    ReInputField(
                        hintText: phoneController.text = accountProvider.phone.toString(),
                        controller: phoneController,
                        prefixPath: "",
                        isPrefix : false,
                    ),

                    const SizedBox(height: 10.0,),
                    TextWidget(text: "Address", size: 14.0,isBold: true,),
                    const SizedBox(height: 10.0,),
                    ReInputField(
                        hintText: addressController.text = accountProvider.address.toString(),
                        controller: addressController,
                        prefixPath: "",
                        isPrefix : false
                    ),


                    const SizedBox(height: 40.0,),

                    if(type =="bottom")
                    GestureDetector(
                      onTap: (){
                        Get.to(()=> const SettingScreen());
                      },
                      child: Container(
                        width: Get.width / 2,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primaryColor,
                            width: 2.0
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.transparent
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(AppIcons.ic_setting,width: 24.0,height: 24.0,),
                            const SizedBox(width: 10.0,),
                            TextWidget(text: "Setting", size: 14.0,color: primaryColor,)
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40.0,),

                    if(type =="edit")
                    Consumer<ValueProvider>(
                      builder: (context, provider, child){
                        return provider.isLoading == false  ? ButtonWidget(text: "Update", onClicked: () async{
                          provider.setLoading(true);
                          String? url;
                          if(imageProvider.imageFile!=null){
                            url = await imageProvider.uploadImage(imageFile: imageProvider.imageFile!);
                          }else{
                            url = accountProvider.image.toString();
                          }
                          accountProvider.updateUserProfile(
                              name: nameController.text.toString().trim(),
                              email: emailController.text.toString().trim(),
                              phone: phoneController.text.toString().trim(),
                              address: addressController.text.toString().trim(),
                              image: url,
                            context: context
                          );
                          log("Url: ${url.toString()}");
                        }, width: Get.width, height: 50.0) :
                        ButtonLoadingWidget(loadingMesasge: "updating",width: Get.width, height: 50.0);
                      },
                    ),

                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
