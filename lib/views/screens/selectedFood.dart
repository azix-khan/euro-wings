import 'package:euro_wings/utils/customNavigation.dart';
import 'package:euro_wings/utils/tiles.dart';
import 'package:euro_wings/views/screens/payFood.dart';
import 'package:flutter/material.dart';
//
import '../../utils/themes.dart';

class SelectedFoodScreen extends StatelessWidget {
  final List<_Categories> categories = [
    _Categories('Chicken Big Burger', 'Ala carte', '380 LKR'),
    _Categories('Chicken Spicy Burger', 'Ala carte', '320 LKR'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('BURGER',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black)),
            Text('C I T Y',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Colors.black)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: primary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // TITULO :
          const Titles('Chicken Burgers', 'Please select your burger type'),
          // IMAGEN :
          _ImagenCustom(),
          // ACCESORIO :
          Expanded(
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, i) => _CategoriesFood(categories[i].subtitulo,
                    categories[i].titulo, categories[i].calories),
                separatorBuilder: (_, i) => const SizedBox(height: 15),
                itemCount: categories.length),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigatorBar(),
    );
  }
}

class _ImagenCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 240,
      child: Image.asset('images/3-hamburguesas.png'),
    );
  }
}

class _CategoriesFood extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String calories;

  const _CategoriesFood(this.titulo, this.subtitulo, this.calories);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => PayFoodScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(this.subtitulo,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(this.titulo,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500)),
                ],
              ),
              const Spacer(),
              Text(this.calories,
                  style:
                      TextStyle(color: primary, fontWeight: FontWeight.bold)),
              const SizedBox(width: 15),
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_right_rounded, size: 25),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class _Categories {
  final String titulo;
  final String subtitulo;
  final String calories;

  _Categories(this.titulo, this.subtitulo, this.calories);
}
