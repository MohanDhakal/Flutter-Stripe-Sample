import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:learn_project/config/server.dart';
import 'package:http/http.dart' as http;

class PaymentPageController extends GetxController {
  int step = 0;

  Future<Map<String, dynamic>> _createTestPaymentSheet() async {
    final url = Uri.parse('$kApiUrl/v1/payment_intents');
    final response = await http.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer sk_test_51K9SU9KMZ7M71898u25VWeG0AvVXxQjg2tYzWl4xbMyyUCiSw5AEyrovdH9aYwaUOsMF07oIglFELQ5imLDvGQNe00LJH30dou",
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      },
      body: {
        "amount": "500",
        "currency": "USD",
        "payment_method_types[]": "card"
      },
    );
    final body = json.decode(response.body);
    if (body['error'] != null) {
      throw Exception(body['error']);
    }
    return body;
  }

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await _createTestPaymentSheet();
      // create some billingdetails
      const billingDetails = BillingDetails(
        email: 'mohandkl.512@gmai.com',
        phone: '+48888000888',
        address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      ); // mocked data for tests

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: data['client_secret'],
          merchantDisplayName: 'Flutter Stripe Metro Coffee',
          // Customer params
          customerId: data['customer'],
          // Extra params
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          primaryButtonColor: Colors.redAccent,
          billingDetails: billingDetails,
          testEnv: true,
          merchantCountryCode: 'USA',
        ),
      );
      step = 1;
      update();
    } catch (e) {
      print(e);
      Get.snackbar(
        "Error",
        "Error Initiating Payment",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> confirmPayment() async {
    try {
      // 3. display the payment sheet.
      print("opening payment sheet");
      await Stripe.instance.presentPaymentSheet();
      // print("closing payment sheet");
      step = 0;
      update();
      Get.snackbar(
        "Message",
        "Payment succesfully completed",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 2000),
      );
    } on Exception catch (e) {
      if (e is StripeException) {
        Get.snackbar(
          "Message",
          'Error from Stripe: ${e.error.localizedMessage}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 2000),
        );
      } else {
        Get.snackbar(
          "Message",
          'Unforeseen error: $e',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 2000),
        );
      }
    }
  }
}
