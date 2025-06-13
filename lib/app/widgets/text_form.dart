import 'package:flutter/material.dart';
import 'package:testapp/app/widgets/text_style.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? hint;
  final Widget? suffixicon;
  final Widget? prefixIcon;
  final Function(String)? onChanged;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.label,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.hint,
    this.suffixicon,
    this.prefixIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: AppTextStyles.montserratBold.copyWith(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.caption.copyWith(
          color: const Color.fromARGB(255, 215, 210, 210),
          fontSize: 12,
        ),
        hintText: hint,
        suffixIcon: suffixicon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 178, 174, 174),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}
