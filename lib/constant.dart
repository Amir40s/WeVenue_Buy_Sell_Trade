import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xFFFF5858);
const secondaryColor = Color(0xFFF857A6);
const whiteColor = Color(0xFFFFFFFF);
const lightPink = Color(0xFFC1839F);
const bgColor = Color(0xFFFFFFFF);
const drawerBackground = Color(0xFF212332);
const lightGrey = Color(0xFFD4E4E6);
const lightBlue = Colors.lightBlue;


LinearGradient gradientColor = const LinearGradient(colors: [

  Color(0xff0fabaa),
  Color(0xff3EC2C2),
  Color(0xff40d5d4),
  Color(0xff8ae5e5),
  // Color(0xffFFFFFF),
]);

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;