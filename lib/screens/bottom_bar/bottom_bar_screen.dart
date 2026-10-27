import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../helper/images.dart';
import '../../provider/bottom_bar/bottom_bar_provider.dart';
import '../uploadItems/items_upload_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final double defaultIconSize = 20.0;

  static const Color navBackground = Color(0xFF171923);
  static const Color activeColor = Color(0xFFFFFFFF);
  static const Color inactiveColor = Color(0xFF9296A5);
  static const Color scaffoldBackground = Color(0xFFF5F6FA);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Provider.of<BottomBarProvider>(
        context,
        listen: false,
      ).refreshStatus();
    });
  }

  Widget _navItem({
    required String label,
    required Widget icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? activeColor : inactiveColor;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconTheme(
                data: IconThemeData(color: color, size: defaultIconSize),
                child: icon,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: color,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _assetNavItem({
    required String label,
    required String asset,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? activeColor : inactiveColor;

    return _navItem(
      label: label,
      isSelected: isSelected,
      onTap: onTap,
      icon: Image.asset(
        asset,
        height: defaultIconSize,
        width: defaultIconSize,
        color: color,
      ),
    );
  }

  Widget _publishLabel() {
    return const Text(
      'PUBLISH',
      style: TextStyle(
        fontSize: 9.5,
        fontWeight: FontWeight.w500,
        color: inactiveColor,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _publishItem(VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.public_rounded,
                size: defaultIconSize,
                color: inactiveColor,
              ),
              const SizedBox(height: 5),
              const _PublishLabelPlaceholder(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomBarProvider =
        Provider.of<BottomBarProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: scaffoldBackground,
      resizeToAvoidBottomInset: false,
      body: Consumer<BottomBarProvider>(
        builder: (context, value, child) {
          return value.myList[value.myIndex];
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        shape: const CircularNotchedRectangle(),
        notchMargin: 7,
        color: navBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        child: Consumer<BottomBarProvider>(
          builder: (context, value, child) {
            if (Platform.isAndroid) {
              return Row(
                children: [
                  _assetNavItem(
                    label: 'HOME',
                    asset: AppIcons.ic_home,
                    isSelected: value.myIndex == 0,
                    onTap: () => bottomBarProvider.changeMyIndex(0),
                  ),
                  _assetNavItem(
                    label: 'CHATS',
                    asset: AppIcons.ic_chat,
                    isSelected: value.myIndex == 1,
                    onTap: () => bottomBarProvider.changeMyIndex(1),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => bottomBarProvider.changeMyIndex(2),
                      child: SizedBox(
                        height: 56,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: defaultIconSize),
                            const SizedBox(height: 5),
                            const _PublishLabelPlaceholder(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _assetNavItem(
                    label: 'RELOCATION',
                    asset: AppIcons.ic_relocation,
                    isSelected: value.myIndex == 2,
                    onTap: () => bottomBarProvider.changeMyIndex(2),
                  ),
                  _assetNavItem(
                    label: 'ACCOUNT',
                    asset: AppIcons.ic_person,
                    isSelected: value.myIndex == 3,
                    onTap: () => bottomBarProvider.changeMyIndex(3),
                  ),
                ],
              );
            }

            return Row(
              children: [
                _assetNavItem(
                  label: 'HOME',
                  asset: AppIcons.ic_home,
                  isSelected: value.myIndex == 0,
                  onTap: () => bottomBarProvider.changeMyIndex(0),
                ),
                _publishItem(
                  () => bottomBarProvider.changeMyIndex(1),
                ),
                _assetNavItem(
                  label: 'RELOCATION',
                  asset: AppIcons.ic_relocation,
                  isSelected: value.myIndex == 3,
                  onTap: () => bottomBarProvider.changeMyIndex(3),
                ),
                _assetNavItem(
                  label: 'ACCOUNT',
                  asset: AppIcons.ic_person,
                  isSelected: value.myIndex == 4,
                  onTap: () => bottomBarProvider.changeMyIndex(4),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Platform.isAndroid
          ? FloatingActionButton(
              onPressed: () => Get.to(() => ItemsUploadScreen()),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              elevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              disabledElevation: 0,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              shape: const CircleBorder(),
              child: SvgPicture.asset(
                'assets/icons/publish_add.svg',
                width: 58,
                height: 58,
              ),
            )
          : null,
    );
  }
}

class _PublishLabelPlaceholder extends StatelessWidget {
  const _PublishLabelPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'PUBLISH',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 9.5,
        fontWeight: FontWeight.w500,
        color: Color(0xFF9296A5),
        letterSpacing: 0.3,
      ),
    );
  }
}
