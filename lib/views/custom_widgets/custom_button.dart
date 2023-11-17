import 'package:euro_wings/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  void Function() onTap;
  String title;
  CustomButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height * .070,
        width: width * .60,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          color: buttonColor,
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(
              color: backgroundColor,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
