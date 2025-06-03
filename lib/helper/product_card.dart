import 'dart:developer';

import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/image_loader_widget.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/model/product/product_model.dart';
import 'package:biouwa/provider/bottom_bar/bottom_bar_provider.dart';
import 'package:biouwa/provider/cart/cart_provider.dart';
import 'package:biouwa/provider/products/products_provider.dart';
import 'package:biouwa/screens/productDetail/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final String imageurl, title, price;
  final ProductModel product;
  final bool isCart, isSaved;

  const ProductCard({
    super.key,
    required this.imageurl,
    required this.title,
    required this.price,
    required this.product,
    required this.isCart,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    final bottomP = Provider.of<BottomBarProvider>(context);
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ProductDetailsScreen(
            product: product,
            docID: product.docID,
          ),
        );
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width,
                    height: Get.width * 0.300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ImageLoaderWidget(
                        imageUrl: imageurl,
                        radius: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextWidget(
                    text: title,
                    size: 16.0,
                    color: Colors.black,
                    maxLine: 1,
                  ),
                  const SizedBox(height: 8),
                  TextWidget(
                    text: '$price\$',
                    size: 16.0,
                    isBold: true,
                  )
                ],
              ),
            ),
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                return Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: !bottomP.isLoggedIn
                        ? () {}
                        : () {
                            // Handle the button tap
                            if (isSaved) {
                              provider.unsaveProduct(product.docID);
                            } else {
                              provider.saveProduct(product.docID);
                            }
                          },
                    child: isSaved
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.black,
                          ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: !bottomP.isLoggedIn
                    ? () {}
                    : () {
                        // Handle the button tap
                        try {
                          if (isCart) {
                            showSnackBar(title: "Product Remove", subtitle: "");
                            Provider.of<CartProvider>(context, listen: false).removeProduct(product);
                          } else {
                            showSnackBar(title: "Product Added", subtitle: "");
                            Provider.of<CartProvider>(context, listen: false).addProduct(product);
                          }
                        } catch (e) {
                          log("Add Cart Product Button : ${e.toString()}");
                        }
                      },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    gradient: LinearGradient(
                      colors: [darkPurple, primaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: isCart
                      ? const Icon(
                          Icons.remove,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
