import 'dart:io';

import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/simple_header.dart';
import 'package:biouwa/provider/account/account_provider.dart';
import 'package:biouwa/screens/dashboard/account/account_screen.dart';
import 'package:biouwa/screens/dashboard/menu/moveServices/move_services.dart';
import 'package:biouwa/screens/dashboard/menu/myListing/my_listing_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../faq/faq_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  static const Color _background = Color(0xFFF7F8FA);
  static const Color _purple = Color(0xFF6A35B8);
  static const Color _darkPurple = Color(0xFF422078);
  static const Color _text = Color(0xFF202033);
  static const Color _muted = Color(0xFF85859A);
  static const Color _border = Color(0xFFEEEEF4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SimpleHeader(),
              const SizedBox(height: 24),
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: _text,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Manage your account and preferences',
                style: TextStyle(
                  fontSize: 13,
                  color: _muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 22),
              _buildAccountBanner(context),
              const SizedBox(height: 28),
              _sectionTitle('ACCOUNT & SERVICES'),
              const SizedBox(height: 12),
              _settingsCard([
                _SettingItem(
                  icon: Icons.person_outline_rounded,
                  title: 'Account Settings',
                  subtitle: 'Update your personal details',
                  onTap: () {
                    final image = Provider.of<AccountProvider>(
                      context,
                      listen: false,
                    ).image.toString();

                    Get.to(
                      () => AccountScreen(type: 'edit', image: image),
                    );
                  },
                ),
                _SettingItem(
                  icon: Icons.local_shipping_outlined,
                  title: 'Moving Services',
                  subtitle: 'Explore available moving services',
                  onTap: () => Get.to(() => MoveServices()),
                ),
                _SettingItem(
                  icon: Icons.inventory_2_outlined,
                  title: 'My Listings',
                  subtitle: 'Manage your product listings',
                  onTap: () => Get.to(() => const MyListingScreen()),
                ),
                _SettingItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & FAQ',
                  subtitle: 'Find answers to common questions',
                  showDivider: false,
                  onTap: () => Get.to(() => const FAQScreen()),
                ),
              ]),
              const SizedBox(height: 26),
              _sectionTitle('ACCOUNT ACTIONS'),
              const SizedBox(height: 12),
              _settingsCard([
                _SettingItem(
                  icon: Icons.delete_outline_rounded,
                  title: 'Delete Account',
                  subtitle: 'Permanently remove your account',
                  iconColor: const Color(0xFFD9485F),
                  showDivider: false,
                  onTap: () => showReAuthDialog(context),
                ),
              ]),
              const SizedBox(height: 12),
              _settingsCard([
                _SettingItem(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  iconColor: const Color(0xFFD9485F),
                  showDivider: false,
                  onTap: () => _showLogoutDialog(context),
                ),
              ]),
              const SizedBox(height: 26),
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      width: 36,
                      decoration: BoxDecoration(
                        color: _purple.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'WeVenue',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: _darkPurple,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Manage everything in one place',
                      style: TextStyle(fontSize: 11, color: _muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_darkPurple, _purple, primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.manage_accounts_outlined,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Manage your profile and services',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.settings_suggest_outlined,
            color: Colors.white70,
            size: 26,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: _muted,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.15,
      ),
    );
  }

  Widget _settingsCard(List<_SettingItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF242044).withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildSettingTile(items[i]),
            if (i < items.length - 1 && items[i].showDivider)
              const Padding(
                padding: EdgeInsets.only(left: 72),
                child: Divider(height: 1, color: _border),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingTile(_SettingItem item) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (item.iconColor ?? _purple).withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item.icon,
                  size: 23,
                  color: item.iconColor ?? _purple,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 11.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: item.iconColor ?? const Color(0xFFB5B5C5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(dialogContext).pop();
                logout(context: context);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      );
    } else {
      Get.defaultDialog(
        title: 'Logout',
        titleStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
        middleText: 'Are you sure you want to logout?',
        textCancel: 'Cancel',
        textConfirm: 'Logout',
        confirmTextColor: Colors.white,
        buttonColor: _purple,
        radius: 18,
        onConfirm: () {
          Get.back();
          logout(context: context);
        },
      );
    }
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool showDivider;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.showDivider = true,
  });
}
