import 'dart:ui';

import 'package:biouwa/db_key.dart';
import 'package:biouwa/provider/constant/value_provider.dart';
import 'package:biouwa/screens/login/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

const primaryColor = Color(0xFFC11C84);
const darkPurple = Color(0xFF7132F5);
const secondaryColor = Color(0xFFF857A6);
const orangeColor = Color(0xFFE25D6C);
const whiteColor = Color(0xFFFFFFFF);
const lightPink = Color(0xFFC1839F);
const bgColor = Color(0xFFFBF9F9);
const drawerBackground = Color(0xFF212332);
const lightGrey = Color(0xFFE2E8F0);
const darkGrey = Color(0xFF534F5D);
const lightBlue = Colors.lightBlue;
const Color customGrey = Color(0xFFE0E0E0);

LinearGradient gradientColor = const LinearGradient(colors: [
  Color(0xff0fabaa),
  Color(0xff3EC2C2),
  Color(0xff40d5d4),
  Color(0xff8ae5e5),
  // Color(0xffFFFFFF),
]);

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

void showSnackBar({required title, required subtitle}) {
  Get.snackbar(title, subtitle, colorText: Colors.black);
}

logout() {
  auth.signOut().then((value) {
    Get.offAll(() => LoginScreen());
  }).catchError((e) {
    Get.offAll(() => LoginScreen());
  });
}
//
// Future<void> deleteAccount({required BuildContext context}) async {
//   try {
//     User? user = auth.currentUser;
//
//     if (user != null) {
//       String userId = user.uid;
//       Provider.of<ValueProvider>(context, listen: false).setLoading(true);
//       // Delete user data from Firestore (adjust collection name if needed)
//       await firestore.collection(DbKey.c_users).doc(userId).delete();
//
//       // Delete the user’s authentication account
//       await user.delete();
//
//       // Show success message
//       Get.snackbar(
//         "Success",
//         "Your account has been deleted successfully",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//
//       // Navigate to login screen
//       Get.offAll(() => LoginScreen());
//     }
//   } catch (e) {
//     print("Error deleting account: $e");
//
//     // Show error message
//     Get.snackbar(
//       "Error",
//       "Failed to delete account. Please try again.",
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   } finally {
//     Provider.of<ValueProvider>(context, listen: false).setLoading(false);
//   }
// }

void showReAuthDialog(BuildContext context) {
  TextEditingController passwordController = TextEditingController();
  User? user = auth.currentUser;

  if (user == null) {
    Get.snackbar(
      "Error",
      "No user is currently logged in.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  Get.defaultDialog(
    title: "Re-authenticate",
    content: Column(
      children: [
        Text("Enter your password to continue."),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter password",
          ),
        ),
      ],
    ),
    textCancel: "Cancel",
    textConfirm: "Confirm",
    confirmTextColor: Colors.white,
    onConfirm: () {
      Get.back(); // Close the dialog
      reAuthenticateAndDelete(context, passwordController.text);
    },
  );
}

Future<void> reAuthenticateAndDelete(BuildContext context, String password) async {
  try {
    User? user = auth.currentUser;

    if (user == null || user.email == null) {
      Get.snackbar(
        "Error",
        "User not found. Please log in again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Provider.of<ValueProvider>(context, listen: false).setLoading(true);

    AuthCredential credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    // Re-authenticate user
    await user.reauthenticateWithCredential(credential);

    // Proceed with account deletion
    await deleteAccount(context: context);
  } catch (e) {
    Get.snackbar(
      "Error",
      "Re-authentication failed. Please check your password and try again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    Provider.of<ValueProvider>(context, listen: false).setLoading(false);
  }
}

Future<void> deleteAccount({required BuildContext context}) async {
  try {
    User? user = auth.currentUser;

    if (user != null) {
      String userId = user.uid;
      Provider.of<ValueProvider>(context, listen: false).setLoading(true);

      // Delete user data from Firestore
      await firestore.collection('users').doc(userId).delete();

      // Delete the user’s authentication account
      await user.delete();

      // Show success message
      Get.snackbar(
        "Success",
        "Your account has been deleted successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to login screen
      Get.offAll(() => LoginScreen());
    }
  } catch (e) {
    Get.snackbar(
      "Error",
      "Failed to delete account. Please try again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    Provider.of<ValueProvider>(context, listen: false).setLoading(false);
  }
}
customDialog(
    {required VoidCallback onClick,
    required title,
    required content,
    textYes = "Yes",
    textNo = "No"}) {
  Get.defaultDialog(
    title: title,
    content: Text(content),
    textCancel: textNo,
    textConfirm: textYes,
    onConfirm: onClick,
  );
}
