import 'dart:developer';
import 'dart:io';

import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/image_loader_widget.dart';
import 'package:biouwa/helper/simple_header.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/model/product/product_image_model.dart';
import 'package:biouwa/model/product/product_model.dart';
import 'package:biouwa/provider/bottom_bar/bottom_bar_provider.dart';
import 'package:biouwa/screens/chat/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../helper/bordder_button_widget.dart';
import '../../provider/cart/cart_provider.dart';
import '../../provider/chat/chat_provider.dart';
import '../../provider/products/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  final String docID;

  ProductDetailsScreen({
    super.key,
    required this.product,
    required this.docID,
  });

  final isIos = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    return isIos
        ? CupertinoPageScaffold(
            child: ProductDetailsBody(
              product: product,
              docID: docID,
            ),
          )
        : Scaffold(
            backgroundColor: lightGrey,
            body: ProductDetailsBody(
              product: product,
              docID: docID,
            ),
          );
  }
}

class ProductDetailsBody extends StatelessWidget {
  ProductDetailsBody({
    super.key,
    required this.product,
    required this.docID,
  });

  final ProductModel product;
  final String docID;
  final isIos = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    final bottomP = Provider.of<BottomBarProvider>(context);

    return SafeArea(
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
              Container(
                height: Get.width * 0.600,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(product.image), fit: BoxFit.cover),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),

                // child: Consumer<ProductProvider>(
                //   builder: (context, productProvider, child) {
                //     return StreamBuilder<List<ProductImageModel>>(
                //       stream: productProvider.getProductImages(docID: docID),
                //       builder: (context, snapshot) {
                //         if (snapshot.connectionState ==
                //             ConnectionState.waiting) {
                //           return Center(
                //             child: isIos
                //                 ? const CupertinoActivityIndicator()
                //                 : const CircularProgressIndicator(),
                //           );
                //         }
                //         if (snapshot.hasError) {
                //           return Center(
                //             child: Text('Error: ${snapshot.error}'),
                //           );
                //         }
                //         if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //           return const Center(child: Text('No images found'));
                //         }
                //
                //         List<ProductImageModel> images = snapshot.data!;
                //
                //         return ListView.builder(
                //           itemCount: images.length,
                //           shrinkWrap: true,
                //           scrollDirection: Axis.horizontal,
                //           itemBuilder: (context, index) {
                //             ProductImageModel image = images[index];
                //             return Container(
                //               height: 100.0,
                //               margin: const EdgeInsets.only(right: 10.0),
                //               width: Get.width / 1.4,
                //               child: ImageLoaderWidget(
                //                 imageUrl: image.image,
                //               ),
                //             );
                //           },
                //         );
                //       },
                //     );
                //   },
                // ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: product.title,
                          size: 18.0,
                          isBold: true,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextWidget(
                          text: "\$${product.cost}",
                          size: 18.0,
                          isBold: true,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: bottomP.isLoggedIn
                  //       ? () async {
                  //           final chatRoomId = await context
                  //               .read<ChatProvider>()
                  //               .createOrGetChatRoom(product.email, "");
                  //           Get.to(
                  //             ChatScreen(
                  //               userUID: product.userUID,
                  //               name: product.name,
                  //               image: product.profile,
                  //               otherEmail: product.email,
                  //               chatRoomId: chatRoomId,
                  //             ),
                  //           );
                  //         }
                  //       : () {},
                  //   child: Container(
                  //     width: 50.0,
                  //     height: 50.0,
                  //     margin: const EdgeInsets.only(right: 40.0),
                  //     decoration: BoxDecoration(
                  //       color: primaryColor,
                  //       borderRadius: BorderRadius.circular(50.0),
                  //     ),
                  //     child: const Icon(
                  //       Icons.chat,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextWidget(text: product.description, size: 14.0),
              const SizedBox(
                height: 20.0,
              ),
              if (bottomP.isLoggedIn)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<CartProvider>(
                      builder: (context, provider, child) {
                        return BorderButtonWidget(
                          text: provider.isInCart(product) ? "Remove" : "Add to Cart",
                          width: Get.width * 0.4,
                          height: 50.0,
                          textColor: primaryColor,
                          radius: 10.0,
                          onClicked: () {
                            try {
                              if (provider.isInCart(product)) {
                                showSnackBar(title: "Product Removed", subtitle: "");
                                Provider.of<CartProvider>(context, listen: false).removeProduct(product);
                              } else {
                                showSnackBar(title: "Product Added", subtitle: "");
                                Provider.of<CartProvider>(context, listen: false).addProduct(product);
                              }
                            } catch (e) {
                              log("Add Cart Product Button : ${e.toString()}");
                            }
                          },
                        );
                      },
                    ),
                    if (Platform.isAndroid) const Spacer(),
                    if (Platform.isAndroid)
                      ButtonWidget(
                        text: "Buy",
                        onClicked: () {},
                        width: Get.width * 0.4,
                        height: 50.0,
                        radius: 10.0,
                      ),
                  ],
                ),
              // const SizedBox(height: 30),
              // if (!bottomP.isLoggedIn)
              //   Center(child: TextWidget(text: 'Not Logged In', size: 13))
            ],
          ),
        ),
      ),
    );
  }
}
