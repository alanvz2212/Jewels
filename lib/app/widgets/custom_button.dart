import 'package:flutter/material.dart';
import 'package:testapp/app/widgets/add_on_widgets.dart';
import 'package:testapp/app/widgets/text_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final EdgeInsets? padding;
  final bool isOutlined;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.padding,
    this.isOutlined = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    )
                  : Text(text),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? buildLoadingIndicator(context: context)
                  : Text(
                      text,
                      style: AppTextStyles.montserratBold.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
            ),
    );
  }
}
