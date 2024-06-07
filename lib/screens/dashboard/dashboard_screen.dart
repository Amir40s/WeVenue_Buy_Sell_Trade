import 'package:biouwa/helper/product_card.dart';
import 'package:biouwa/provider/cart/cart_provider.dart';
import 'package:biouwa/screens/dashboard/menu/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../helper/header.dart';
import '../../helper/image_loader_widget.dart';
import '../../helper/images.dart';
import '../../helper/search_field.dart';
import '../../helper/text_widget.dart';
import '../../model/product/product_model.dart';
import '../../provider/products/products_provider.dart';

class DashboardScreen extends StatelessWidget {
   DashboardScreen({super.key});

  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
    backgroundColor: lightGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Header(menuPress: (){
                 // Get.to(()=> MenuScreen());
                },),
            
                const SizedBox(height: 20.0,),
                SearchField(hintText: "search for books, guitar and more", controller: searchController,suffixPath: AppIcons.ic_logo,),
                const SizedBox(height: 20.0,),
                Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                    return StreamBuilder<List<ProductModel>>(
                      stream: productProvider.getProducts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No products found'));
                        }
            
                        List<ProductModel> products = snapshot.data!;
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 0.7
                          ),
                          itemCount: products.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            ProductModel product = products[index];
                            bool isInCart = cartProvider.isInCart(products[index]);
                            return FutureBuilder(
                             future: productProvider.isProductSaved(product.docID),
                             builder: (context, snapshot){
                               bool isSaved = snapshot.data ?? false;
                               return ProductCard(
                                 imageurl: product.image,
                                 title: product.title,
                                 price: product.cost.toString(),
                                 product: product,
                                 isCart: isInCart,
                                 isSaved: isSaved,
                               );
                             },
                            );
                          },
                        );
                      },
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
}
