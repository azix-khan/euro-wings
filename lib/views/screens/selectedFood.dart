import 'package:euro_wings/Models/categories_model.dart';
import 'package:euro_wings/Models/menu_model.dart';
import 'package:euro_wings/views/custom_widgets/customNavigation.dart';
import 'package:euro_wings/views/custom_widgets/tiles.dart';
import 'package:euro_wings/views/screens/categories_item_widget.dart';
import 'package:flutter/material.dart';

import '../../constants/themes.dart';

class SelectedFoodScreen extends StatefulWidget {
  final Menu menu;

  SelectedFoodScreen({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  State<SelectedFoodScreen> createState() => _SelectedFoodScreenState();
}

class _SelectedFoodScreenState extends State<SelectedFoodScreen> {
  final List<Categories> categories = [
    Categories(
        id: 1,
        title: 'Euro Special Burger',
        subtitle: "Ala carte",
        price: '649 RS'),
    Categories(
        id: 1, title: 'Student Burger', subtitle: "Ala carte", price: '200 RS'),
    Categories(
        id: 1, title: 'Zinger Burger', subtitle: "Ala carte", price: '349 Rs'),
    Categories(
        id: 1,
        title: 'Zinger Stacker Burger',
        subtitle: "Ala carte",
        price: '449 RS'),
    Categories(
        id: 1,
        title: 'Double Decker Burger',
        subtitle: "Ala carte",
        price: '449 RS'),
    Categories(
        id: 1, title: 'Tower Burger', subtitle: "Ala carte", price: '599 RS'),
    Categories(
        id: 2,
        title: 'Chicken Grill Burger',
        subtitle: "Ala carte",
        price: '399'),
    Categories(
        id: 2,
        title: 'Milde Chicken Burger',
        subtitle: "Ala carte",
        price: '449 Rs'),
    Categories(
        id: 4, title: 'Hot Burger', subtitle: "Ala carte", price: '380 LKR'),
    Categories(
        id: 4, title: 'Hot Burger', subtitle: "Ala carte", price: '380 LKR'),
    Categories(
        id: 4, title: 'Hot Burger', subtitle: "Ala carte", price: '380 LKR'),
  ];
  List<Categories> updateCat = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      updateCat =
          categories.where((element) => element.id == widget.menu.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('EURO',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black)),
            Text('W I N G S',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: primary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // TITLE :
          Titles(widget.menu.title,
              'Please select your ${widget.menu.title} type'),
          // IMAGE :
          SizedBox(
            width: double.infinity,
            height: 240,
            child: Image.asset(widget.menu.image),
          ),
          // TYPE SELECTION :
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, i) => CategoriesFood(
                categories: updateCat[i],
                title: 'title',
              ),
              separatorBuilder: (_, i) => const SizedBox(height: 15),
              itemCount: updateCat.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavigatorBar(),
    );
  }
}
