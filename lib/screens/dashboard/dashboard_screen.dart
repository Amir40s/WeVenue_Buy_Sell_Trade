import 'dart:io';

import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/cj_products_section.dart';
import 'package:biouwa/helper/header.dart';
import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/search_field.dart';
import 'package:biouwa/provider/cj/cj_dropshipping_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? const CupertinoPageScaffold(
            backgroundColor: Color(0xFFF7F8FA),
            child: DashboardBody(),
          )
        : const Scaffold(
            backgroundColor: Color(0xFFF7F8FA),
            body: DashboardBody(),
          );
  }
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cjProvider =
        Provider.of<CJDropshippingProvider>(context, listen: false);

    return SafeArea(
      child: RefreshIndicator(
        color: darkPurple,
        onRefresh: () async {
          await cjProvider.fetchProducts(refresh: true);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(menuPress: () {}),
              const SizedBox(height: 18),
              _buildHeroBanner(),
              const SizedBox(height: 18),
              SearchField(
                hintText: 'Search wholesale products, SKUs, or items...',
                controller: searchController,
                suffixPath: AppIcons.ic_logo,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  cjProvider.setSearchQuery(value);
                },
              ),
              const SizedBox(height: 18),
              CJProductsSection(
                searchQuery: searchQuery,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [darkPurple, primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.public, color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text(
                      'GLOBAL SOURCING',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'WHOLESALE',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Direct Dropshipping\nMarketplace',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.2,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Thousands of factory-direct items with fast global shipping & buyer protection.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _bannerPill(Icons.verified_outlined, 'Verified Suppliers'),
              const SizedBox(width: 8),
              _bannerPill(Icons.local_shipping_outlined, 'Express Delivery'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bannerPill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
