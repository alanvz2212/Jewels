import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/app/controllers/auth_controller.dart';
import 'package:testapp/app/widgets/add_on_widgets.dart';
import 'package:testapp/app/widgets/text_style.dart';

class SplashScreen extends StatelessWidget {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (authController.user.value != null) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF15384E), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/Images/logo.png', width: 150),
              SizedBox(height: 30),
              buildLoadingIndicator(context: context),
              SizedBox(height: 20),
              Text(
                'Loading...',
                style: AppTextStyles.montserratBold.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
