import 'package:biouwa/constant.dart';
import 'package:biouwa/helper/image_loader_widget.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/model/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:provider/provider.dart';

import '../../../../helper/simple_header.dart';
import '../../../../provider/products/products_provider.dart';

class MyListingScreen extends StatelessWidget {
  const MyListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SimpleHeader(),
                SizedBox(height: 40.0,),
                TextWidget(text: "My Listing", size: 22.0,color: Colors.black,isBold: true,),
                SizedBox(height: 40.0,),
             Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return StreamBuilder<List<ProductModel>>(
                  stream: productProvider.getMyProducts(),
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


                    // return GridView.builder(
                    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2, // Number of columns
                    //       crossAxisSpacing: 10.0,
                    //       mainAxisSpacing: 10.0,
                    //       childAspectRatio: 0.6
                    //   ),
                    //   itemCount: products.length,
                    //   shrinkWrap: true,
                    //   itemBuilder: (context, index) {
                    //     ProductModel product = products[index];
                    //     return itemsList(products: product);
                    //   },
                    // );

                    return ListView.builder(

                      itemCount: products.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        ProductModel product = products[index];
                        return itemsList(products: product,context: context);
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
  // Card itemsList({required ProductModel products}){
  //   return Card(
  //    // margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
  //     color: Colors.white,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //
  //         ClipRRect(
  //             borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0)),
  //             child: ImageLoaderWidget(imageUrl: products.image.toString(),)),
  //         Expanded(
  //             child: Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               TextWidget(text: products.title,size: 14.0,isBold: true),
  //              // TextWidget(text: products.description,size: 12.0,),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   TextWidget(text: "\$${products.cost}",size: 14.0,isBold: true,color: primaryColor,),
  //
  //                   Padding(
  //                     padding: EdgeInsets.all(10.0),
  //                     child: Row(
  //                       children: [
  //                         Icon(Icons.edit,color: primaryColor,size: 24,),
  //                         SizedBox(width: 2.0,),
  //                         Icon(Icons.delete,color: Colors.red,size: 24,),
  //
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ),
  //         ))
  //
  //       ],
  //     ),
  //   );
  // }

  Card itemsList({required ProductModel products,required BuildContext context}){
    return Card(
      // margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
      color: Colors.white,
      child: ListTile(
        leading: ImageLoaderWidget(imageUrl: products.image.toString(),),
        title: TextWidget(text: products.title,size: 14.0,isBold: true),
        subtitle: TextWidget(text: "\$${products.cost}",size: 14.0,isBold: true,color: primaryColor,),
        trailing: Column(
          children: [
            IconButton(icon: Icon(Icons.delete,color: Colors.red,size: 24,),onPressed: (){

              customDialog(
                  onClick: () async{
                Get.back();
                await Provider.of<ProductProvider>(context,listen: false).deleteProduct(
                    productId: products.docID,
                    imageUrl: products.image
                );

              }, title: "Alert!!!!", content: "are you sure to delete this product?");
            }),
          ],
        ),
        onTap: (){
         // Get.to(EditProductScreen(id: products.id));
        },
      )
    );
  }
}

