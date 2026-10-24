import 'dart:developer';

import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/custom_network_image.dart';
import 'package:biouwa/model/product/cj_product_model.dart';
import 'package:biouwa/model/product/product_model.dart';
import 'package:biouwa/provider/bottom_bar/bottom_bar_provider.dart';
import 'package:biouwa/provider/cart/cart_provider.dart';
import 'package:biouwa/provider/cj/cj_dropshipping_provider.dart';
import 'package:biouwa/provider/products/products_provider.dart';
import 'package:biouwa/screens/productDetail/cj_product_details_screen.dart';
import 'package:biouwa/screens/productDetail/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final String imageurl;
  final String title;
  final String price;
  final ProductModel? product;
  final CJProductModel? cjProduct;
  final bool isCart;
  final bool isSaved;

  const ProductCard({
    super.key,
    required this.imageurl,
    required this.title,
    required this.price,
    this.product,
    this.cjProduct,
    this.isCart = false,
    this.isSaved = false,
  }) : assert(
          product != null || cjProduct != null,
          'Provide either product or cjProduct',
        );

  @override
  Widget build(BuildContext context) {
    final bottomP = Provider.of<BottomBarProvider>(context);
    final isCJProduct = cjProduct != null;

    return GestureDetector(
      onTap: () {
        if (product != null) {
          Get.to(
            () => ProductDetailsScreen(
              product: product!,
              docID: product!.docID,
            ),
          );
        } else {
          Get.to(
            () => CJProductDetailsScreen(
              product: cjProduct!,
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade100, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 11,
                child: Stack(
                  children: [
                    CustomNetworkImage(
                      imageUrl: imageurl,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    // // Top Left Supplier Badge
                    // Positioned(
                    //   top: 8,
                    //   left: 8,
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    //     decoration: BoxDecoration(
                    //       color: isCJProduct
                    //           ? darkPurple.withValues(alpha: 0.9)
                    //           : Colors.black.withValues(alpha: 0.7),
                    //       borderRadius: BorderRadius.circular(6),
                    //     ),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Icon(
                    //           isCJProduct ? Icons.verified : Icons.storefront,
                    //           size: 10,
                    //           color: Colors.white,
                    //         ),
                    //         const SizedBox(width: 3),
                    //         Text(
                    //           isCJProduct ? 'CJ DIRECT' : 'MARKET',
                    //           style: const TextStyle(
                    //             fontSize: 9,
                    //             fontWeight: FontWeight.w800,
                    //             color: Colors.white,
                    //             letterSpacing: 0.3,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    if (!isCJProduct)
                      Consumer<ProductProvider>(
                        builder: (context, provider, child) {
                          return Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: !bottomP.isLoggedIn
                                  ? null
                                  : () {
                                      if (isSaved) {
                                        provider.unsaveProduct(product!.docID);
                                      } else {
                                        provider.saveProduct(
                                            product!.docID, product);
                                      }
                                    },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isSaved
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isSaved ? Colors.red : Colors.black54,
                                  size: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    else
                      Consumer<CJDropshippingProvider>(
                        builder: (context, cjProvider, child) {
                          final isFav = cjProvider.isFavorite(cjProduct!.id);
                          return Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                cjProvider.toggleFavorite(
                                    cjProduct!.id, cjProduct);
                                showSnackBar(
                                  title: isFav
                                      ? 'Removed from Wishlist'
                                      : 'Saved to Wishlist',
                                  subtitle: cjProduct!.name,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav ? Colors.red : Colors.black54,
                                  size: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 9,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isCJProduct)
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    size: 14, color: Colors.amber),
                                const SizedBox(width: 2),
                                Text(
                                  '${cjProduct!.rating}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  ' (${cjProduct!.salesCount}+)',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          const SizedBox(height: 3),
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '\$$price',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: darkPurple,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                          Consumer<CartProvider>(
                            builder: (context, cart, child) {
                              final effectiveProduct = isCJProduct
                                  ? cjProduct!.toProductModel()
                                  : product!;
                              final inCart = cart.isInCart(effectiveProduct);

                              return GestureDetector(
                                onTap: !bottomP.isLoggedIn
                                    ? () {
                                        showSnackBar(
                                          title: 'Login Required',
                                          subtitle:
                                              'Please login to add items to your cart.',
                                        );
                                      }
                                    : () {
                                        try {
                                          if (inCart) {
                                            cart.removeProduct(
                                                effectiveProduct);
                                            showSnackBar(
                                              title: 'Product Removed',
                                              subtitle: effectiveProduct.title,
                                            );
                                          } else {
                                            cart.addProduct(effectiveProduct);
                                            showSnackBar(
                                              title: 'Added to Cart',
                                              subtitle: effectiveProduct.title,
                                            );
                                          }
                                        } catch (e) {
                                          log('Cart error: $e');
                                        }
                                      },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: inCart ? Colors.green : null,
                                    gradient: inCart
                                        ? null
                                        : const LinearGradient(
                                            colors: [darkPurple, primaryColor],
                                          ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    inCart
                                        ? Icons.check
                                        : Icons.add_shopping_cart,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
