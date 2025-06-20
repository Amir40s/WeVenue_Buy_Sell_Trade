import 'dart:io';

import 'package:biouwa/helper/dropdown_provider.dart';
import 'package:biouwa/provider/account/account_provider.dart';
import 'package:biouwa/provider/bottom_bar/bottom_bar_provider.dart';
import 'package:biouwa/provider/cart/cart_provider.dart';
import 'package:biouwa/provider/chat/chat_provider.dart';
import 'package:biouwa/provider/check_out/check_out_provider.dart';
import 'package:biouwa/provider/constant/password_visible_provider.dart';
import 'package:biouwa/provider/constant/value_provider.dart';
import 'package:biouwa/provider/data/image_provider.dart';
import 'package:biouwa/provider/items/faq_provider.dart';
import 'package:biouwa/provider/items/items_upload_provider.dart';
import 'package:biouwa/provider/products/products_provider.dart';
import 'package:biouwa/provider/signnup/firebase_data_provider.dart';
import 'package:biouwa/start/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  print("App INIT");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  // Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH_KEY']!;
  // await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PasswordVisibleProvider()),
        ChangeNotifierProvider(create: (_) => DropdownProvider()),
        ChangeNotifierProvider(create: (_) => ValueProvider()),
        ChangeNotifierProvider(create: (_) => FirebaseDataProvider()),
        ChangeNotifierProvider(create: (_) => BottomBarProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => ImagePickProvider()),
        ChangeNotifierProvider(create: (_) => ItemsUploadProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FAQProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => CheckOutP()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
