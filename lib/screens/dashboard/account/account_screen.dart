import 'dart:developer';

import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/button_widget.dart';
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

  static const Color _background = Color(0xFFF7F8FA);
  static const Color _cardColor = Color(0xFFFFFFFF);
  static const Color _textColor = Color(0xFF202033);
  static const Color _mutedText = Color(0xFF85859A);
  static const Color _borderColor = Color(0xFFEEEEF4);
  static const Color _destructiveColor = Color(0xFFD9485F);

  @override
  void initState() {
    super.initState();
    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);

    nameController = TextEditingController(text: accountProvider.name);
    emailController = TextEditingController(text: accountProvider.email);
    phoneController = TextEditingController();
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

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text,
        style: const TextStyle(
          color: _textColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _profileAvatar({
    required Widget child,
    VoidCallback? onTap,
    bool editable = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.35),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 46,
              backgroundColor: _background,
              child: ClipOval(
                child: SizedBox(
                  width: 92,
                  height: 92,
                  child: child,
                ),
              ),
            ),
          ),
          if (editable)
            Container(
              width: 31,
              height: 31,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [darkPurple, primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: _cardColor, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 15,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _settingsButton() {
    return Material(
      color: _cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.to(() => const SettingScreen()),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: _borderColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: primaryColor,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Manage your account preferences',
                      style: TextStyle(
                        color: _mutedText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: _mutedText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileCard(AccountProvider accountProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 25,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [darkPurple, primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          if (widget.type == "edit")
            Consumer<ImagePickProvider>(
              builder: (context, provider, child) {
                return _profileAvatar(
                  editable: true,
                  onTap: provider.pickProductImage,
                  child: provider.imageFile != null
                      ? Image.file(
                          provider.imageFile!,
                          fit: BoxFit.cover,
                        )
                      : ImageLoaderWidget(
                          imageUrl: widget.image,
                        ),
                );
              },
            )
          else
            _profileAvatar(
              child: accountProvider.image.isNotEmpty
                  ? Image.network(
                      accountProvider.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) {
                        return const Icon(
                          Icons.person_rounded,
                          size: 44,
                          color: _mutedText,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/icons/ic_profile_image.webp',
                      fit: BoxFit.cover,
                    ),
            ),
          const SizedBox(height: 15),
          Text(
            accountProvider.name.isNotEmpty
                ? accountProvider.name
                : 'My Account',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            accountProvider.email,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 12,
            ),
          ),
          if (widget.type == "edit") ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: const Text(
                'Tap the camera to change photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _informationCard(AccountProvider accountProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Full Name'),
          ReInputField(
            hintText: accountProvider.name,
            controller: nameController,
          ),
          const SizedBox(height: 20),
          _sectionLabel('Email Address'),
          ReInputField(
            enabled: false,
            hintText: accountProvider.email,
            controller: emailController,
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 14,
                color: _mutedText,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Your email address cannot be changed here.',
                  style: TextStyle(
                    color: _mutedText,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider =
        Provider.of<ImagePickProvider>(context, listen: false);
    final bottomProvider = Provider.of<BottomBarProvider>(context);

    return Scaffold(
      backgroundColor: _background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: bottomProvider.isLoggedIn
            ? Consumer<AccountProvider>(
                builder: (context, accountProvider, child) {
                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (widget.type == "edit") ...[
                              Material(
                                color: _cardColor,
                                borderRadius: BorderRadius.circular(13),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(13),
                                  onTap: () => Get.back(),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _borderColor,
                                      ),
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_rounded,
                                      color: _textColor,
                                      size: 21,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 13),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.type == "edit"
                                        ? 'Edit Account'
                                        : 'Account',
                                    style: const TextStyle(
                                      color: _textColor,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Manage your personal information',
                                    style: TextStyle(
                                      color: _mutedText,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        _profileCard(accountProvider),
                        const SizedBox(height: 26),
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _informationCard(accountProvider),
                        if (widget.type == "bottom") ...[
                          const SizedBox(height: 22),
                          _settingsButton(),
                        ],
                        if (widget.type == "edit") ...[
                          const SizedBox(height: 28),
                          Consumer<ValueProvider>(
                            builder: (context, provider, child) {
                              return provider.isLoading
                                  ? ButtonLoadingWidget(
                                      loadingMesasge: 'Updating profile...',
                                      width: Get.width,
                                      height: 52.0,
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ButtonWidget(
                                        text: 'Update Profile',
                                        onClicked: () async {
                                          provider.setLoading(true);
                                          String? url;

                                          try {
                                            if (imageProvider.imageFile !=
                                                null) {
                                              url = await imageProvider
                                                  .uploadImage(
                                                imageFile:
                                                    imageProvider.imageFile!,
                                              );
                                            } else {
                                              url = accountProvider.image;
                                            }

                                            if (!context.mounted) return;

                                            await accountProvider
                                                .updateUserProfile(
                                              name: nameController.text.trim(),
                                              email:
                                                  emailController.text.trim(),
                                              phone:
                                                  phoneController.text.trim(),
                                              address:
                                                  addressController.text.trim(),
                                              image: url,
                                              context: context,
                                            );

                                            log('Profile image URL: $url');
                                          } catch (error, stackTrace) {
                                            log(
                                              'Profile update failed',
                                              error: error,
                                              stackTrace: stackTrace,
                                            );
                                            provider.setLoading(false);
                                          }
                                        },
                                        width: Get.width,
                                        height: 52.0,
                                        radius: 14.0,
                                        isShadow: false,
                                      ),
                                    );
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
              )
            : const NoUserWidget(),
      ),
    );
  }
}
