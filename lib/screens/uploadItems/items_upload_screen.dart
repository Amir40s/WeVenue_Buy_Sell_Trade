import 'dart:io';

import 'package:biouwa/constant/appString/app_string.dart';
import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/custom_textfield.dart';
import 'package:biouwa/provider/bottom_bar/bottom_bar_provider.dart';
import 'package:biouwa/provider/data/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../helper/button_loading_widget.dart';
import '../../helper/no_user_widget.dart';
import '../../helper/simple_header.dart';
import '../../provider/constant/value_provider.dart';
import '../../provider/items/items_upload_provider.dart';

class ItemsUploadScreen extends StatelessWidget {
  ItemsUploadScreen({super.key});

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final costController = TextEditingController();
  final _key = GlobalKey<FormState>();

  static const Color backgroundColor = Color(0xFFF7F8FA);
  static const Color darkPurple = Color(0xFF35205F);
  static const Color primaryText = Color(0xFF202033);
  static const Color secondaryText = Color(0xFF85859A);
  static const Color borderColor = Color(0xFFEEEEF4);
  static const Color cardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final imageUploadProvider =
        Provider.of<ImagePickProvider>(context, listen: false);
    final uploadProvider =
        Provider.of<ItemsUploadProvider>(context, listen: false);
    final bottomProvider =
        Provider.of<BottomBarProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: !bottomProvider.isLoggedIn
            ? const NoUserWidget()
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SimpleHeader(),
                      const SizedBox(height: 24),
                      const Text(
                        'Sell your product',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: primaryText,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Add product details and images to get started.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: secondaryText,
                        ),
                      ),
                      const SizedBox(height: 26),
                      _sectionTitle('Product images'),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: borderColor),
                        ),
                        child: Consumer<ImagePickProvider>(
                          builder: (context, imageProvider, child) {
                            final images = imageProvider.images ?? [];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (images.isNotEmpty)
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.9,
                                    ),
                                    itemCount: images.length,
                                    itemBuilder: (context, index) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(images[index].path),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: backgroundColor,
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.broken_image_outlined,
                                                color: secondaryText,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  )
                                else
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 28,
                                    ),
                                    decoration: BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: borderColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: const Column(
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 42,
                                          color: darkPurple,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'No images selected',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: primaryText,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Add clear photos of your product',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      imageProvider.pickImages();
                                    },
                                    icon: const Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 19,
                                    ),
                                    label: Text(
                                      images.isEmpty
                                          ? 'Choose product images'
                                          : 'Add more images',
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: darkPurple,
                                      side: const BorderSide(
                                        color: borderColor,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 26),
                      _sectionTitle('Product details'),
                      const SizedBox(height: 14),
                      _fieldLabel('Product title'),
                      const SizedBox(height: 8),
                      _inputCard(
                        child: CustomTextField(
                          hintText: 'Enter product title',
                          controller: titleController,
                          fillColor: cardColor,
                          error: '${AppString.fieldError}Title',
                        ),
                      ),
                      const SizedBox(height: 20),
                      _fieldLabel('Product description'),
                      const SizedBox(height: 8),
                      _inputCard(
                        child: CustomTextField(
                          hintText: 'Describe your product',
                          controller: descController,
                          fillColor: cardColor,
                          error: '${AppString.fieldError}Product Description',
                        ),
                      ),
                      const SizedBox(height: 20),
                      _fieldLabel('Delivery cost (\$)'),
                      const SizedBox(height: 8),
                      _inputCard(
                        child: CustomTextField(
                          hintText: 'Enter delivery cost',
                          controller: costController,
                          fillColor: cardColor,
                          keyboardType: TextInputType.number,
                          error: '${AppString.fieldError}Delivery Cost',
                        ),
                      ),
                      const SizedBox(height: 30),
                      Consumer<ValueProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return ButtonLoadingWidget(
                              loadingMesasge: 'Uploading your product...',
                              width: MediaQuery.sizeOf(context).width,
                              height: 54,
                            );
                          }

                          return SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ButtonWidget(
                              text: 'Sell product',
                              width: MediaQuery.sizeOf(context).width,
                              height: 54,
                              onClicked: () async {
                                if (!_key.currentState!.validate()) return;

                                final images = imageUploadProvider.images;

                                if (images == null || images.isEmpty) {
                                  showSnackBar(
                                    title: 'Images required',
                                    subtitle: 'Please select product images.',
                                  );
                                  return;
                                }

                                provider.setLoading(true);

                                try {
                                  await imageUploadProvider
                                      .uploadImages(context);

                                  await uploadProvider.uploadItems(
                                    downloadUrls:
                                        imageUploadProvider.downloadUrls,
                                    title: titleController.text.trim(),
                                    description: descController.text.trim(),
                                    cost: costController.text.trim(),
                                    context: context,
                                  );

                                  titleController.clear();
                                  descController.clear();
                                  costController.clear();
                                } catch (e) {
                                  provider.setLoading(false);
                                  rethrow;
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: primaryText,
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
    );
  }

  Widget _inputCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}
