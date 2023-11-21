import 'package:euro_wings/Models/menu_model.dart';
import 'package:euro_wings/views/custom_widgets/menu_item_widget.dart';
import 'package:flutter/material.dart';

class MenuList extends StatelessWidget {
  final List<Menu> menu = [
    Menu(
      id: 1,
      title: "Burgers",
      image: 'images/hamburger.png',
    ),
    Menu(
      id: 2,
      title: "Shwarmas",
      image: 'images/fajita.png',
    ),
    Menu(
      id: 3,
      title: "Fries",
      image: 'images/salchipapa.png',
    ),
    Menu(
      id: 4,
      title: "Pizzas",
      image: 'images/pizza.png',
    ),
    // Add more deals as needed
  ];

  MenuList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      width: double.infinity,
      height: 620,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: menu.length,
        itemBuilder: (context, index) {
          return MenuItems(menu: menu[index]);
        },
      ),
    );
  }
}
