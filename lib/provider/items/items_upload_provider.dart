import 'dart:developer';

import 'package:biouwa/constant.dart';
import 'package:biouwa/db_key.dart';
import 'package:biouwa/provider/data/image_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../constant/value_provider.dart';

class ItemsUploadProvider extends ChangeNotifier{

  Future<void> uploadItems({required List downloadUrls,required title,
    required description, required cost,required BuildContext context}) async {
    try{
      DateTime time = DateTime.now();
      String id = time.millisecondsSinceEpoch.toString();
     final user =  await firestore.collection("users").doc(auth.currentUser?.uid.toString()).get();
     if(user.exists){
      await  firestore.collection("items").doc(id).set({
        DbKey.k_title :  title,
        DbKey.k_desc :  description,
        DbKey.k_cost :  double.parse(cost),
        DbKey.k_timestamp :  id,
        DbKey.k_userUID :  auth.currentUser?.uid.toString(),
        DbKey.k_date : "${time.day}/${time.month}/${time.year}",
        DbKey.k_time : "${time.hour}:${time.minute}",
        DbKey.k_image : downloadUrls.isNotEmpty ? downloadUrls[0].toString() : "",
        DbKey.k_name : user.get("name").toString(),
        "profile" : user.get("image").toString(),
        DbKey.k_email: user.get(DbKey.k_email).toString(),
      }).whenComplete((){
        uploadImagesLinks(downloadUrls: downloadUrls,id: id,context: context);
      });
     }

      notifyListeners();
    }catch(e){
      Provider.of<ValueProvider>(context,listen: false).setLoading(false);
      log("Error fetching count value: $e");
    }
    notifyListeners();
}

  Future<void> uploadImagesLinks({required List downloadUrls,required id,required BuildContext context}) async {
    DateTime time = DateTime.now();
    try{
      for(int i=0; i < downloadUrls.length; i++){
       await firestore.collection("items").doc(id).collection("images").add({
          DbKey.k_image : downloadUrls[i].toString(),
          DbKey.k_id : time.millisecondsSinceEpoch.toString(),
        });
      }
      Provider.of<ValueProvider>(context,listen: false).setLoading(false);
      Provider.of<ImagePickProvider>(context,listen: false).clear();
      showSnackBar(title: "Product Upload Successfully", subtitle: "");
      notifyListeners();
    }catch(e){
      Provider.of<ValueProvider>(context,listen: false).setLoading(false);
      log("Error fetching count value: $e");
    }
    notifyListeners();
  }

}