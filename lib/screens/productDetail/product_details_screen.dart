import 'dart:developer';

import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/image_loader_widget.dart';
import 'package:biouwa/helper/simple_header.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/model/product/product_image_model.dart';
import 'package:biouwa/model/product/product_model.dart';
import 'package:biouwa/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../helper/bordder_button_widget.dart';
import '../../provider/cart/cart_provider.dart';
import '../../provider/chat/chat_provider.dart';
import '../../provider/products/products_provider.dart';
class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  final String docID;
  const ProductDetailsScreen({super.key, required this.product, required this.docID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SimpleHeader(),

                SizedBox(height: 40.0,),
                Container(
                  height: Get.width * 0.600,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Consumer<ProductProvider>(
                    builder: (context, productProvider, child) {
                      return StreamBuilder<List<ProductImageModel>>(
                        stream: productProvider.getProductImages(docID: docID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No images found'));
                          }

                          List<ProductImageModel> images = snapshot.data!;

                          return ListView.builder(
                            itemCount: images.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              ProductImageModel image = images[index];
                              return Container(
                                height: 100.0,
                                margin: const EdgeInsets.only(right: 10.0),
                                width: Get.width / 1.4,
                                child: ImageLoaderWidget(imageUrl: image.image,),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.0,),

                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(text: product.title, size: 18.0,isBold: true,),
                            SizedBox(height: 20.0,),
                            TextWidget(text: "\$${product.cost}", size: 18.0,isBold: true,color: Colors.green,),
                          ],
                        )),
                    GestureDetector(
                      onTap: () async{
                        final chatRoomId = await context.read<ChatProvider>().createOrGetChatRoom(product.email,"");
                        Get.to(ChatScreen(
                          userUID: product.userUID,
                          name: product.name,
                          image: product.profile,
                          otherEmail: product.email,
                          chatRoomId: chatRoomId,
                        ));
                      },
                      child: Container(
                          width: 50.0,
                          height: 50.0,
                          margin: EdgeInsets.only(right: 40.0),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Icon(Icons.chat,color: Colors.white,)
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                TextWidget(text: product.description, size: 14.0),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<CartProvider>(
                     builder: (context, provider, child){
                       return BorderButtonWidget(
                         text: provider.isInCart(product) ? "Remove" : "Add to Cart",
                         width: Get.width * 0.4,
                         height: 50.0,
                         textColor:  primaryColor,
                         radius: 10.0,
                         onClicked: (){
                           try{
                             if(provider.isInCart(product)){
                               showSnackBar(title: "Product Removed", subtitle: "");
                               Provider.of<CartProvider>(context,listen: false).removeProduct(product);
                             }else{
                               showSnackBar(title: "Product Added", subtitle: "");
                               Provider.of<CartProvider>(context,listen: false).addProduct(product);
                             }

                           }catch (e){
                             log("Add Cart Product Button : ${e.toString()}");
                           }
                         },
                       );
                     },
                    ),
                    ButtonWidget(text: "Buy", onClicked: (){

                    }, width: Get.width * 0.4, height: 50.0,radius: 10.0)
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
