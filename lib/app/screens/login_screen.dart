import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/app/controllers/auth_controller.dart';
import 'package:testapp/app/widgets/text_style.dart';

class LoginScreen extends StatelessWidget {
  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isPasswordVisible = false.obs;
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF15384E), Colors.black],
              begin: Alignment.center,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Login',
              style: AppTextStyles.montserratBold.copyWith(color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(child: Column()),
        ),
      ],
    );
  }
}
