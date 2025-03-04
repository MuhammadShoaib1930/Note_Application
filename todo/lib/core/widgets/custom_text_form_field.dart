import 'package:flutter/material.dart';
import "package:todo/core/theme/app_color.dart";

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String? val) validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final String hintText;
  final Widget? suffix;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.validator,
    required this.keyboardType,
    required this.obscureText,
    required this.hintText,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      style: Theme.of(context).textTheme.titleMedium,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffix: suffix,
        hintText: hintText,
        hintStyle: const TextStyle(fontWeight: FontWeight.w400),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.borderColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.borderColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.appColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.errorColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.errorColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: AppColor.errorColor, fontSize: 12),
      ),
      validator: validator,
    );
  }
}
