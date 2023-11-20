import 'package:euro_wings/Models/menu_model.dart';
import 'package:euro_wings/views/custom_widgets/menu_item_widget.dart';
import 'package:flutter/material.dart';

// class MenuList extends StatelessWidget {
//   const MenuList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: 15),
//       width: double.infinity,
//       height: 620,
//       child: GridView.count(
//         physics: const BouncingScrollPhysics(),
//         crossAxisCount: 2,
//         crossAxisSpacing: 5.0,
//         mainAxisSpacing: 5.0,
//         children: const [
//           MenuItems('Combos Hamburgesas', 'images/hamburger.png', menuModel: null,),
//           MenuItems('Fajitas', 'images/fajita.png'),
//           MenuItems('Salchipapas', 'images/salchipapa.png'),
//           MenuItems('Pizzas', 'images/pizza.png'),
//         ],
//       ),
//     );
//   }
// }

class MenuList extends StatelessWidget {
  final List<Menu> menu = [
    Menu(
      description: 'Combos Hamburgesas',
      image: 'images/hamburger.png',
    ),
    Menu(
      description: 'Fajitas',
      image: 'images/fajita.png',
    ),
    Menu(
      description: 'Salchipapas',
      image: 'images/salchipapa.png',
    ),
    Menu(
      description: 'Pizzas',
      image: 'images/pizza.png',
    ),
    // Add more deals as needed
  ];

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
        children: [
          ListView.builder(
            itemCount: menu.length,
            itemBuilder: (context, index) {
              return MenuItems(menu: menu[index]);
            },
          ),
        ],
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Deals Menu'),
    //   ),
    //   body: ListView.builder(
    //     itemCount: menu.length,
    //     itemBuilder: (context, index) {
    //       return MenuItems(menu: menu[index]);
    //     },
    //   ),
    // );
  }
}
