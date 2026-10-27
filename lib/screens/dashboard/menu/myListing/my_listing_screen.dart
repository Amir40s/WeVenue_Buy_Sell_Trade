import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/image_loader_widget.dart';
import 'package:biouwa/model/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../helper/simple_header.dart';
import '../../../../provider/products/products_provider.dart';

class MyListingScreen extends StatelessWidget {
  const MyListingScreen({super.key});

  static const Color _background = Color(0xFFF7F8FA);
  static const Color _cardColor = Color(0xFFFFFFFF);
  static const Color _textColor = Color(0xFF202033);
  static const Color _mutedText = Color(0xFF85859A);
  static const Color _borderColor = Color(0xFFEEEEF4);
  static const Color _deleteColor = Color(0xFFD9485F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              const SimpleHeader(),
              const SizedBox(height: 28),
              const Text(
                'My Listing',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: _textColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Manage the products you have listed for sale.',
                style: TextStyle(
                  fontSize: 13,
                  color: _mutedText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    return StreamBuilder<List<ProductModel>>(
                      stream: productProvider.getMyProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 2.5,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    color: _deleteColor,
                                    size: 42,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Unable to load listings',
                                    style: TextStyle(
                                      color: _textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${snapshot.error}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: _mutedText,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 86,
                                    height: 86,
                                    decoration: BoxDecoration(
                                      color: primaryColor.withValues(
                                        alpha: 0.08,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.inventory_2_outlined,
                                      size: 40,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  const Text(
                                    'No products yet',
                                    style: TextStyle(
                                      color: _textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Your listed products will appear here.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _mutedText,
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final List<ProductModel> products = snapshot.data!;

                        return ListView.separated(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: products.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            return itemsList(
                              products: products[index],
                              context: context,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemsList({
    required ProductModel products,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: darkPurple.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: SizedBox(
                width: 88,
                height: 92,
                child: ImageLoaderWidget(
                  imageUrl: products.image.toString(),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    products.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${products.cost}',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 7,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Your listing',
                        style: TextStyle(
                          color: _mutedText,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _deleteColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'Delete listing',
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: _deleteColor,
                  size: 21,
                ),
                onPressed: () {
                  customDialog(
                    onClick: () async {
                      Get.back();
                      await Provider.of<ProductProvider>(
                        context,
                        listen: false,
                      ).deleteProduct(
                        productId: products.docID,
                        imageUrl: products.image,
                      );
                    },
                    title: 'Alert!!!!',
                    content: 'are you sure to delete this product?',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
