import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar({
  required String title,
  required String message,
  IconData? icon,
  Color? backgroundColor = const Color(0xFF15384E),
  Color textColor = Colors.white,
  Color? iconColor,
  SnackPosition snackPosition = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 3),
  double borderRadius = 2.0,
  EdgeInsets margin = const EdgeInsets.all(30.0),
  EdgeInsets padding = const EdgeInsets.only(bottom: 20.0, left: 5, right: 5),
  TextAlign textAlign = TextAlign.center,
  bool isDismissible = true,
  Function? onTap,
}) {
  Get.snackbar(
    title,
    message,
    icon: icon != null
        ? Icon(icon, color: iconColor ?? textColor, size: 24.0)
        : null,
    backgroundColor: backgroundColor,
    colorText: textColor,
    snackPosition: snackPosition,
    duration: duration,
    borderRadius: borderRadius,
    margin: margin,
    padding: padding,
    snackStyle: SnackStyle.FLOATING,
    overlayBlur: 3,
    overlayColor: Colors.black.withValues(),
    isDismissible: isDismissible,
    onTap: (_) {
      if (onTap != null) onTap();
    },
    messageText: Text(
      message,
      textAlign: textAlign,
      // style: App,
    ),
    titleText: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: textColor,
        fontSize: 16,
      ),
    ),
  );
}
