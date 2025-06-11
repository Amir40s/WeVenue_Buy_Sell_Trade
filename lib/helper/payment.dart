import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  Map<String, dynamic>? paymentIntentData;
  String payIntentId1 = '';

  Future<void> makePayment({
    required String amount,
    required String successMsj,
    required Function onSuccess,
  }) async {
    try {
      if (double.tryParse(amount) == null || double.parse(amount) <= 0) {
        throw Exception("Invalid amount. Please enter a valid payment amount.");
      }

      final paymentIntent = await createPaymentIntent(amount, 'USD');

      if (paymentIntent == null) {
        throw Exception(
          "Payment request could not be completed. Please try again later.",
        );
      }

      payIntentId1 = savePayIntent(paymentIntent);

      // final gPay = const PaymentSheetGooglePay(
      //   merchantCountryCode: "GB",
      //   currencyCode: "GBP",
      //   testEnv: true,
      // );
      //
      // await Stripe.instance.initPaymentSheet(
      //   paymentSheetParameters: SetupPaymentSheetParameters(
      //     paymentIntentClientSecret: paymentIntent['client_secret'],
      //     style: ThemeMode.light,
      //     merchantDisplayName: 'Laundry Services',
      //     googlePay: gPay,
      //   ),
      // );

      await displayPaymentSheet(amount, onSuccess, successMsj);
    } catch (e) {
      handlePaymentError(e);
    }
  }

  String savePayIntent(Map? intent) {
    if (intent != null && intent['id'] != null) {
      payIntentId1 = intent['id'];
    }
    return payIntentId1;
  }

  Future<void> displayPaymentSheet(
    String amount,
    Function onSuccess,
    String successMsj,
  ) async {
    try {
      // await Stripe.instance.presentPaymentSheet().then((_) {
      //   onSuccess();
      //   // AppUtils.showToast(message: '🎉 $successMsj');
      // });
    } catch (e) {
      handlePaymentError(e);
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      int amountInCents = (double.parse(amount) * 100).toInt();

      Map<String, dynamic> body = {
        'amount': amountInCents.toString(),
        'currency': currency,
      };

      final privateKey = dotenv.env['STRIPE_PRIVATE_KEY'];
      if (privateKey == null) {
        throw Exception("Stripe private key is missing from .env");
      }

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $privateKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Payment request failed. Please try again.');
      }
    } catch (e) {
      handlePaymentError(e);
      return null;
    }
  }

  Future<void> refundStripePayment(String paymentIntentId) async {
    try {
      final privateKey = dotenv.env['STRIPE_PRIVATE_KEY'];
      if (privateKey == null) {
        throw Exception("Stripe private key is missing from .env");
      }

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/refunds'),
        headers: {
          'Authorization': 'Bearer $privateKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'payment_intent': paymentIntentId},
      );

      if (response.statusCode == 200) {
        // AppUtils.showToast(message: '✅ Refund processed successfully.');
      } else {
        throw Exception('⚠️ Refund could not be processed. Please contact support.');
      }
    } catch (e) {
      handlePaymentError(e);
    }
  }

  void handlePaymentError(dynamic error) {
    String errorMessage = "⚠️ Something went wrong. Please try again.";

    // if (
    // // error is StripeException
    // ) {
    //   // if (error.error.code == FailureCode.Canceled) {
    //   //   errorMessage = "⚠️ Payment was canceled.";
    //   // } else if (error.error.message!.contains("authentication")) {
    //   //   errorMessage = "⚠️ Payment authentication required.";
    //   // } else {
    //   //   errorMessage = "⚠️ Payment failed: ${error.error.localizedMessage}";
    //   // }
    // } else
    if (error is http.ClientException) {
      errorMessage = "⚠️ Network error. Please check your internet connection.";
    } else if (error.toString().contains("Invalid amount")) {
      errorMessage = "⚠️ Please enter a valid amount.";
    } else if (error.toString().contains("Payment request failed")) {
      errorMessage = "⚠️ Your payment could not be completed.";
    } else if (error.toString().contains("Refund could not be processed")) {
      errorMessage = "⚠️ Refund failed. Contact support for assistance.";
    }

    // AppUtils.showToast(message: errorMessage);

    if (kDebugMode) {
      print("❌ ERROR: $error");
    }
  }
}
