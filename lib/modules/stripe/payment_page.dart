import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_project/modules/stripe/payment_controller.dart';
import 'package:learn_project/modules/stripe/widgets/custom_scaffold.dart';
import 'widgets/loading_button.dart';

class PaymentPage extends StatelessWidget {
  PaymentPage({Key? key}) : super(key: key);

  final String data = "Flutter Stripe integration";
  final controller = Get.put(PaymentPageController());
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Stripe Payment",
      tags: const ['Metro', 'GV'],
      children: [
        GetBuilder<PaymentPageController>(
          builder: (pController) {
            return Stepper(
              currentStep: pController.step,
              steps: [
                Step(
                  title: const Text('Init payment'),
                  content: LoadingButton(
                    onPressed: pController.initPaymentSheet,
                    text: 'Init payment sheet',
                  ),
                ),
                Step(
                  title: const Text('Confirm payment'),
                  content: LoadingButton(
                    onPressed: pController.confirmPayment,
                    text: 'Pay now',
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
