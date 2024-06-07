import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:biouwa/model/product/product_model.dart';

import '../../constant.dart';
import '../../helper/image_loader_widget.dart';
import '../../helper/simple_header.dart';
import '../../helper/text_widget.dart';
import '../../provider/products/products_provider.dart';
import '../productDetail/product_details_screen.dart';

class SaveItemsScreen extends StatelessWidget {
  const SaveItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context,listen: false);

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
                TextWidget(text: "Saved Items", size: 22.0,color: Colors.black,isBold: true,),
                SizedBox(height: 40.0,),
                StreamBuilder<List<ProductModel>>(
                  stream: productProvider.getSavedProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading saved products'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No saved products'));
                    }
                    final savedProducts = snapshot.data!;
                    return ListView.builder(
                      itemCount: savedProducts.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        ProductModel product = savedProducts[index];
                        return itemsList(products: product,context: context);
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
  Card itemsList({required ProductModel products,required BuildContext context}){
    return Card(
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
                      await Provider.of<ProductProvider>(context,listen: false).unsaveProduct(products.docID,);

                    }, title: "Alert!!!!", content: "are you sure to remove this product?");
              }),
            ],
          ),
          onTap: (){
            Get.to(()=> ProductDetailsScreen(product: products, docID: products.docID,));
          },
        )
    );
  }
}
