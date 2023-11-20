import 'package:euro_wings/constants/themes.dart';
import 'package:euro_wings/views/screens/deals_menu.dart';
import 'package:flutter/material.dart';

class MoreMenuButton extends StatelessWidget {
  const MoreMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DealsScreen()));
        },
        child: Container(
          alignment: Alignment.center,
          height: 60,
          width: 350,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text('Deals Menu',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
