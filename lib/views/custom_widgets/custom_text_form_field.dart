// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:euro_wings/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final controller;
  Widget prefixIcon;
  final keyboardType;
  final String? Function(String?)? validator;
  String hintText;
  String labelText;
  bool obscure;
  final onTap;
  CustomTextFormField({
    super.key,
    required this.controller,
    required this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.obscure = false,
    this.onTap,
    required this.labelText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      onTap: onTap,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        // hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: greenColor),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: greenColor),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: greenColor),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      style: TextStyle(
        color: blackColor,
        fontSize: 16.0,
      ),
    );
  }
}
