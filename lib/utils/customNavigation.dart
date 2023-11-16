import 'package:euro_wings/utils/themes.dart';
import 'package:flutter/material.dart';

class CustomNavigatorBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // fixedColor: primary,
      currentIndex: 0,
      selectedItemColor: primary,
      unselectedItemColor: Colors.blueGrey,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 35), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_sharp, size: 35),
            label: 'Special Burgers'),
        BottomNavigationBarItem(
            icon: Icon(Icons.star, size: 35), label: 'Favorites'),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.food_bank_sharp, size: 35), label: 'Track Orders'),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.account_balance_wallet_sharp, size: 35),
        //     label: 'Wallet'),
      ],
    );
  }
}
