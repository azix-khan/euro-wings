import 'package:flutter/material.dart';

class Titles extends StatelessWidget {
  final String title;
  final String subtitle;

  const Titles(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        width: double.infinity,
        height: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(this.title,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            Text(this.subtitle),
          ],
        ),
      ),
    );
  }
}
