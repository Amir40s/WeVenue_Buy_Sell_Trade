import 'dart:developer';

import 'package:biouwa/db_key.dart';
import 'package:biouwa/provider/constant/value_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';

class AccountProvider extends ChangeNotifier{

   String _name = "";
   String _email = "";
   String _phone = "";
   String _address = "";
   String _image = "";

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get address => _address;
  String get image => _image;


   AccountProvider(){
     log("Run account provider Constructor");
     fetchUserProfile();
   }

  Future<void> fetchUserProfile() async {
    final uid = auth.currentUser?.uid;
    log("UID: ${uid}");
    try {
      final value = await firestore.collection(DbKey.c_users).doc(uid).get();
      if (value.exists) {
        _name = value.get(DbKey.k_name).toString();
       _email = value.get(DbKey.k_email).toString();
       _phone = value.get(DbKey.k_phone).toString();
       _address = value.get(DbKey.k_address).toString();
       if(value.data()!.containsKey("image")){
         _image = value.get(DbKey.k_image).toString();
       }else{
         _image = "no";
       }

       print("Fetch");
      } else {
        print("Not");
        _name = "";
        _email = "";
        _phone = "";
        _address = "";
      }
      notifyListeners();
    } catch (e) {
      log("Error fetching account data: $e");
      if (kDebugMode) {
        print("Error fetching account data: $e");
      }
    }
    notifyListeners();
  }


   Future<void> updateUserProfile({required name, required email, required phone,
     required address,required image, required BuildContext context}) async {
     final uid = auth.currentUser?.uid;
     try {
      await firestore.collection(DbKey.c_users).doc(uid).update({
         DbKey.k_name : name,
         DbKey.k_email : email,
         DbKey.k_phone : phone,
         DbKey.k_address : address,
         DbKey.k_image : image
       }).whenComplete((){
         Provider.of<ValueProvider>(context,listen: false).setLoading(false);
         showSnackBar(title: "Profile Updated", subtitle: "");
         fetchUserProfile();
      });
       notifyListeners();
     } catch (e) {
       Provider.of<ValueProvider>(context,listen: false).setLoading(false);
       log("Error fetching account data: $e");
       if (kDebugMode) {
         print("Error fetching account data: $e");
       }
     }
     notifyListeners();
   }



}