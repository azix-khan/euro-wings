import 'package:euro_wings/views/custom_widgets/menu.dart';
import 'package:flutter/material.dart';

class MenuList extends StatelessWidget {
  const MenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      width: double.infinity,
      height: 620,
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
        children: const [
          Menu('Combos Hamburgesas', 'images/hamburger.png'),
          Menu('Fajitas', 'images/fajita.png'),
          Menu('Salchipapas', 'images/salchipapa.png'),
          Menu('Pizzas', 'images/pizza.png'),
        ],
      ),
    );
  }
}
