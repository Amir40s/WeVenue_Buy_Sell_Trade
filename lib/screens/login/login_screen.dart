import 'dart:io';

import 'package:biouwa/constant/appString/app_string.dart';
import 'package:biouwa/helper/button_widget.dart';
import 'package:biouwa/helper/custom_richtext.dart';
import 'package:biouwa/helper/custom_textfield.dart';
import 'package:biouwa/helper/images.dart';
import 'package:biouwa/helper/login_richtext.dart';
import 'package:biouwa/helper/simple_header.dart';
import 'package:biouwa/helper/text_widget.dart';
import 'package:biouwa/provider/constant/value_provider.dart';
import 'package:biouwa/provider/signnup/firebase_data_provider.dart';
import 'package:biouwa/screens/bottom_bar/bottom_bar_screen.dart';
import 'package:biouwa/screens/signup/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../helper/button_loading_widget.dart';
import '../../helper/custom_password_textfield.dart';
import '../forgot/forgot_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final firebaseProvider =
        Provider.of<FirebaseDataProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Form(
            key: _key,
            child: Container(
              width: Get.width,
              height: Get.height,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (Platform.isAndroid) const SimpleHeader(),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: "Log In",
                              size: 22.0,
                              isBold: true,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  const BottomNavBar(),
                                );
                              },
                              child: TextWidget(
                                text: "Skip",
                                size: 14.0,
                                isBold: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        CustomTextField(
                          hintText: "Email",
                          controller: emailController,
                          suffixPath: AppIcons.ic_email,
                          error: '${AppString.fieldError}Email',
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        CustomPasswordTextField(
                          hintText: "Password",
                          controller: passwordController,

                          suffixPath: AppIcons.ic_password_visible,
                          obscurePassword: _obscurePassword,
                          error:'Enter your password'
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to((ForgotPasswordScreen()));
                          },
                          child: TextWidget(
                            text: "Forgot password?",
                            size: 12.0,
                            color: Colors.lightBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LoginRichText(
                          press: () {},
                          firstText: "By sign, I accept the",
                          secondText: "Terms of service ",
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Consumer<ValueProvider>(
                          builder: (context, provider, child) {
                            return provider.isLoading == false
                                ? ButtonWidget(
                                    text: "Login",
                                    onClicked: () {
                                      if (_key.currentState!.validate()) {
                                        _key.currentState!.save();
                                        provider.setLoading(true);
                                        firebaseProvider.signInWithGoogle(
                                            email:
                                                emailController.text.toString(),
                                            password: passwordController.text
                                                .toString(),
                                            context: context);
                                      }
                                    },
                                    width: Get.width,
                                    height: 50.0,
                                  )
                                : ButtonLoadingWidget(
                                    loadingMesasge: "login",
                                    width: MediaQuery.sizeOf(context).width,
                                    height: 50.0,
                                  );
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        CustomRichtext(
                          press: () {
                            Get.to(
                              SignupScreen(),
                            );
                          },
                          firstText: "Don't have an account?",
                          secondText: "Create One",
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
