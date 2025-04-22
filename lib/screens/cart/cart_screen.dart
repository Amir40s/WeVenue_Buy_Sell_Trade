import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../helper/image_loader_widget.dart';
import '../../helper/images.dart';
import '../../provider/cart/cart_provider.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Image.asset(
                            AppIcons.ic_back,
                            height: 35.0,
                            width: 35.0,
                          )),
                      if (cartProvider.items.isNotEmpty)
                        ButtonWidget(
                          text: "Check Out",
                          onClicked: () {
                            Get.to(CheckoutScreen(
                              totalProducts:
                                  cartProvider.items.length.toString(),
                              pPrice:
                                  cartProvider.totalAmount.toStringAsFixed(2),
                            ));
                          },
                          width: Get.width * 0.300,
                          height: 50.0,
                          radius: 10.0,
                        )
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextWidget(text: "My Cart", size: 20.0, isBold: true),
                      TextWidget(
                          text:
                              "Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}",
                          size: 20.0,
                          isBold: true),
                    ],
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Column(
                    children: [
                      cartProvider.items.isNotEmpty
                          ? ListView.builder(
                              itemCount: cartProvider.items.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var cartItem = cartProvider.items[index];
                                return Container(
                                  width: Get.width,
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: cartItem.product.image.isEmpty
                                            ? CircleAvatar(
                                                backgroundImage: AssetImage(
                                                  'assets/icons/ic_profile_image.webp',
                                                ),
                                              )
                                            : ImageLoaderWidget(
                                                imageUrl:
                                                    cartItem.product.image,
                                              )),
                                    title: TextWidget(
                                      text: cartItem.product.title,
                                      size: 12.0,
                                    ),
                                    subtitle: Text(
                                        '\$${cartItem.product.cost.toStringAsFixed(2)}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            cartProvider.removeProduct(
                                                cartItem.product);
                                          },
                                        ),
                                        Text(cartItem.quantity.toString()),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            cartProvider
                                                .addProduct(cartItem.product);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: TextWidget(
                                  text: "No Cart Item Found", size: 14.0)),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
