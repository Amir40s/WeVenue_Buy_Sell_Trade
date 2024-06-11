import 'package:biouwa/db_key.dart';
import 'package:biouwa/provider/constant/value_provider.dart';
import 'package:biouwa/screens/dashboard/dashboard_screen.dart';
import 'package:biouwa/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../constant/appString/app_string.dart';
import '../../screens/bottom_bar/bottom_bar_screen.dart';


class FirebaseDataProvider extends ChangeNotifier{


  // create user new account
  Future<void> createUserAccount(
      {required name, required email, required phone,required accountType, required password,required  context}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).whenComplete((){
        saveUserAccount(name: name, email: email, phone: phone, accountType: accountType, password: password,context: context);
      });

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Provider.of<ValueProvider>(context,listen: false).setLoading(false);
        Get.snackbar("Failed!!!!","The password provided is too weak");
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Provider.of<ValueProvider>(context,listen: false).setLoading(false);
        Get.snackbar("Failed!!!!","The account already exists for that email.");
        print('The account already exists for that email.');
      }
    } catch (e) {
      Provider.of<ValueProvider>(context,listen: false).setLoading(false);
      print("Error fetching count value: $e");
    }
    notifyListeners();
  }


  // save new user accomt data to database
  Future<void> saveUserAccount(
      {required name, required email, required phone,required accountType, required password,required context}) async {
    DateTime time = DateTime.now();
    try {
      if(auth.currentUser?.uid!=null){
        firestore.collection(DbKey.c_users).doc(auth.currentUser?.uid.toString())
            .set({
          DbKey.k_name : name,
          DbKey.k_email : email,
          DbKey.k_phone : phone,
          DbKey.k_userType : accountType,
          DbKey.k_password : password,
          DbKey.k_address : "",
          DbKey.k_image : "",
          DbKey.k_date : "${time.day}/${time.month}/${time.year}",
          DbKey.k_time : "${time.hour}:${time.minute}",
          DbKey.k_timestamp : time.millisecondsSinceEpoch,
        }).whenComplete(() {
          Provider.of<ValueProvider>(context,listen: false).setLoading(false);
          Get.snackbar("Account Created Successfully","Thanks for creating your account");
          Get.to(()=> LoginScreen());
        });
      }
      notifyListeners();
    } catch (e) {
      Provider.of<ValueProvider>(context,listen: false).setLoading(false);
      print("Error fetching count value: $e");
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle({required email,required password,required BuildContext context}) async{
  //  final provider = Provider.of<SharedPreferenceProvider>(context,listen: false);
    try {
    final user =   await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      if(user.user!.uid.isNotEmpty){
        Provider.of<ValueProvider>(context,listen: false).setLoading(false);
        Get.offAll(()=> const BottomNavBar());
      }else{
        Provider.of<ValueProvider>(context,listen: false).setLoading(false);
        Get.snackbar("Error", "invalid credentials");
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Provider.of<ValueProvider>(context,listen: false).setLoading(false);
        print('No user found for that email.');
        Get.snackbar("Error", "No Email Found against");
      } else if (e.code == 'wrong-password') {
        Provider.of<ValueProvider>(context,listen: false).setLoading(false);
        Get.snackbar("something wrong", "Please enter correct password.");
        print('Wrong password provided for that user.');
      }
    }finally{
      Provider.of<ValueProvider>(context,listen: false).setLoading(false);
    }

  }

  Future<void> resetPassword({required email,required BuildContext context}) async{

    try{
      auth.sendPasswordResetEmail(email: email).whenComplete(() {
        Provider.of<ValueProvider>(context,listen: false).setLoading(false);
        Get.snackbar("Link Send Successfully", "please check your inbox");
      });
    }catch(e){
      print(e);
      Provider.of<ValueProvider>(context,listen: false).setLoading(false);
    }


  }

}