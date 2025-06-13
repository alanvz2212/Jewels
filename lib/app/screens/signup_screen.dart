import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testapp/app/controllers/auth_controller.dart';
import 'package:testapp/app/widgets/custom_button.dart';
import 'package:testapp/app/widgets/text_form.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(Object context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF15384E), Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Sign Up'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Obx(
          () => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset('assets/Images/logo.png', height: 150),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: usernameController,
                        label: 'Username',
                        validator: (value) => GetUtils.isNullOrBlank(value)!
                            ? 'Please enter username'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => !GetUtils.isEmail(value ?? '')
                            ? 'Please enter valid email'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: phoneController,
                        label: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                            GetUtils.isNullOrBlank(value)! || value!.length < 10
                            ? 'Please enter valid phone number'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: passwordController,
                        label: 'Password',
                        obscureText: true,
                        validator: (value) =>
                            GetUtils.isNullOrBlank(value)! || value!.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: confirmPasswordController,
                        label: 'Confirm Password',
                        obscureText: true,
                        validator: (value) => value != passwordController.text
                            ? 'Passwords do not match'
                            : null,
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: 'Sign Up',
                        onPressed: authController.isLoading.value
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  authController.signUpWithEmailAndPhone(
                                    email: emailController.text.trim(),
                                    password: passwordController.text,
                                    username: usernameController.text.trim(),
                                    phone: phoneController.text.trim(),
                                  );
                                }
                              },
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed('/login'),
                        child: const Text(
                          'Already have an account? Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (authController.isLoading.value)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
