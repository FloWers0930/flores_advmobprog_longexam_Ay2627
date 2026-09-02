import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.validator,
    required this.onSaved,
    required this.controller,
    this.isObscure = false,
    required this.fontSize,
    required this.fontColor,
    this.hintTextSize = 12,
    this.hintText = '',
    this.fillColor = Colors.black12,
    required this.height,
    required this.width,
    this.keyboardType = TextInputType.text,
    this.maxLength = 200,
    this.suffixIcon,
  });

  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final TextEditingController controller;

  final bool isObscure;
  final double fontSize;
  final Color fontColor;

  final double height;
  final double width;

  final double hintTextSize;
  final String hintText;

  final Color fillColor;
  final TextInputType keyboardType;
  final int maxLength;

  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      style: TextStyle(fontSize: fontSize, color: fontColor),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(width, height, width, height),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: fbDarkPrimary, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: fbLightPrimary, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black12,
          fontSize: hintTextSize,
          fontFamily: 'Frutiger',
        ),
        fillColor: fillColor,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
