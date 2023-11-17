import 'package:euro_wings/constants/themes.dart';
import 'package:flutter/material.dart';

class Slogan extends StatelessWidget {
  final String title;
  final String address;
  final Color color;
  const Slogan(this.color, this.address, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 100,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          const SizedBox(height: 10),
          Text(address, style: const TextStyle(color: primary))
        ],
      ),
    );
  }
}
