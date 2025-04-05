import 'dart:developer';
import 'dart:io';

import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/custom_textfield.dart';
import 'package:biouwa/provider/bottom_bar/bottom_bar_provider.dart';
import 'package:biouwa/provider/data/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../helper/button_loading_widget.dart';
import '../../helper/no_user_widget.dart';
import '../../helper/simple_header.dart';
import '../../helper/text_widget.dart';
import '../../provider/constant/value_provider.dart';
import '../../provider/items/items_upload_provider.dart';

class ItemsUploadScreen extends StatelessWidget {
  ItemsUploadScreen({super.key});

  var titleController = TextEditingController();
  var descController = TextEditingController();
  var costController = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final imageUploadProvider =
        Provider.of<ImagePickProvider>(context, listen: false);
    final uploadProvider =
        Provider.of<ItemsUploadProvider>(context, listen: false);
    final bottomProvider =
        Provider.of<BottomBarProvider>(context, listen: false);
    titleController.clear();
    descController.clear();
    costController.clear();
    return Scaffold(
        backgroundColor: lightGrey,
        body: SafeArea(
          child: !bottomProvider.isLoggedIn
              ? NoUserWidget()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SimpleHeader(),
                          Container(
                            width: Get.width,
                            padding: const EdgeInsets.all(20.0),
                            margin: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: Consumer<ImagePickProvider>(
                              builder: (context, imageProvider, child) {
                                return Column(
                                  children: [
                                    Container(
                                      child: imageProvider.images != null &&
                                              imageProvider.images!.isNotEmpty
                                          ? GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                              ),
                                              itemCount:
                                                  imageProvider.images!.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Image.file(
                                                  File(imageProvider
                                                      .images![index].path),
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            )
                                          : const Center(
                                              child:
                                                  Text('No images selected')),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        imageProvider.pickImages();
                                        log('message}');
                                      },
                                      child: Container(
                                        width: Get.width,
                                        height: 50.0,
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: lightGrey,
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              TextWidget(
                                                text: "upload image",
                                                size: 12.0,
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextWidget(text: "Product Title", size: 14.0),
                          const SizedBox(
                            height: 10.0,
                          ),
                          CustomTextField(
                            hintText: "product title",
                            controller: titleController,
                            fillColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextWidget(text: "Product Description", size: 14.0),
                          const SizedBox(
                            height: 10.0,
                          ),
                          CustomTextField(
                            hintText: "Product Description",
                            controller: descController,
                            fillColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextWidget(text: "Delivery Cost(\$)", size: 14.0),
                          const SizedBox(
                            height: 10.0,
                          ),
                          CustomTextField(
                            hintText: "Delivery Cost",
                            controller: costController,
                            fillColor: Colors.white,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Consumer<ValueProvider>(
                            builder: (context, provider, index) {
                              return provider.isLoading == false
                                  ? ButtonWidget(
                                      text: "Sell",
                                      onClicked: () async {
                                        if (_key.currentState!.validate()) {
                                          provider.setLoading(true);
                                          if (imageUploadProvider
                                              .images!.isNotEmpty) {
                                            await imageUploadProvider
                                                .uploadImages(context);
                                            await uploadProvider.uploadItems(
                                                downloadUrls:
                                                    imageUploadProvider
                                                        .downloadUrls,
                                                title: titleController.text
                                                    .toString()
                                                    .trim(),
                                                description: descController.text
                                                    .toString()
                                                    .trim(),
                                                cost: costController.text
                                                    .toString()
                                                    .trim(),
                                                context: context);
                                            titleController.clear();
                                            descController.clear();
                                            costController.clear();
                                          } else {
                                            provider.setLoading(false);
                                            showSnackBar(
                                                title: "Alert!!!",
                                                subtitle:
                                                    "Please select product images");
                                          }
                                        }
                                      },
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 50.0)
                                  : ButtonLoadingWidget(
                                      loadingMesasge: "uploading",
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 50.0);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }
}
