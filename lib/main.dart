import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:learn_project/config/stripe.dart';
import 'package:learn_project/modules/stripe/payment_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishableKey;
  runApp(
    GetMaterialApp(
      home: const MyApp(),
      getPages: [
        GetPage(
          name: "/PaymentPage",
          page: () =>  PaymentPage(),
        ),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.toNamed('/PaymentPage'),
          child: const Text('Procceed to Pay'),
        ),
      ),
    );
  }
}
