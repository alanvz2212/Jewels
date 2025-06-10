import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:testapp/app/data/consts.dart';

class StripeService extends GetxController {
  static StripeService get instance => Get.find();

  final _dio = Dio();
  final isLoading = false.obs;
  final isPaymentSuccessful = false.obs;

  void onInit() {
    super.onInit();
    // No need for initialization here since it's done in main.dart
  }

  Future<bool> processPayment({required double amount}) async {
    try {
      isLoading(true);

      // Create payment intent
      final paymentIntentResult = await _createPaymentIntent(amount);
      if (paymentIntentResult == null) {
        throw Exception('Failed to create payment intent');
      }

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentResult,
          merchantDisplayName: 'Your Store Name',
          style: ThemeMode.system,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Colors.blue,
              background: Colors.white,
              componentBackground: Colors.grey[200],
            ),
            shapes: PaymentSheetShape(
              borderRadius: 12.0,
              shadow: PaymentSheetShadowParams(color: Colors.black),
            ),
          ),
        ),
      );

      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      isPaymentSuccessful(true);
      Get.snackbar(
        'Success',
        'Payment processed successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      return true;
    } on StripeException catch (e) {
      isPaymentSuccessful(false);
      Get.snackbar(
        'Payment Failed',
        e.error.localizedMessage ?? 'An error occurred during payment',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return false;
    } catch (e) {
      isPaymentSuccessful(false);
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<String?> _createPaymentIntent(double amount) async {
    try {
      final int amountInCents = (amount * 100).toInt();
      final response = await _dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: {
          'amount': amountInCents.toString(),
          'currency': 'usd',
          'payment_method_types[]': 'card',
        },
        options: Options(
          headers: {'Authorization': 'Bearer ${_getSecretKey()}'},
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create payment intent',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(),
        colorText: Colors.white,
      );
    }
    return null;
  }

  String _getSecretKey() {
    return stripeSecretKey;
  }
}
