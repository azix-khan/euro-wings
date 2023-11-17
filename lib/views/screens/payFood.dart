import 'package:euro_wings/views/custom_widgets/customNavigation.dart';
import 'package:euro_wings/constants/themes.dart';
import 'package:euro_wings/views/custom_widgets/tiles.dart';
import 'package:flutter/material.dart';

class PayFoodScreen extends StatelessWidget {
  final List<_ExtrasFood> extras = [
    _ExtrasFood('10 Nuggets', 'images/nuggets.png', false),
    _ExtrasFood('Coca cola (250 ml)', 'images/cocacola.png', true),
    _ExtrasFood('Fries pack', 'images/papasfritas.png', true),
    _ExtrasFood('Salads', 'images/ensalada.png', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          // Texto :
          const Titles('Cheese Burger Meal', 'Please customize your meal'),
          // Imagen :
          _ImageCustom(),
          // Botones :
          _BottomsCustoms(),
          // Text Includes :
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: 30,
              child: const Text('Includes',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
          ),
          // Includes :
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, i) => _IncludesExtraFood(
                  extras[i].article, extras[i].image, extras[i].change),
              separatorBuilder: (_, i) => const SizedBox(height: 15),
              itemCount: extras.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigatorBar(),
    );
  }
}

class _ImageCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      child: Image.asset('images/comboCompleto.png'),
    );
  }
}

class _BottomsCustoms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        child: Row(
          children: [
            // Botom Select Number :
            _BottomSelectNumber(),
            const SizedBox(width: 10),
            // Add to Cart :
            _BottomAddToCart(),
          ],
        ),
      ),
    );
  }
}

class _BottomSelectNumber extends StatefulWidget {
  @override
  __BottomSelectNumberState createState() => __BottomSelectNumberState();
}

class __BottomSelectNumberState extends State<_BottomSelectNumber> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // menos :
          GestureDetector(
            onTap: () {
              setState(() {
                if (count == 0) {
                  count = 0;
                } else {
                  count--;
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.shade300),
              child: const Text('-', style: TextStyle(fontSize: 18)),
            ),
          ),
          // numero :
          Text('${this.count}', style: const TextStyle(fontSize: 18)),
          // mas :
          GestureDetector(
            onTap: () {
              setState(() {
                count++;
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey.shade300),
              child: const Text('+', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomAddToCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
          ),
        ],
      ),
      child: const Text('Add to Cart',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}

class _IncludesExtraFood extends StatelessWidget {
  final String article;
  final String image;
  final bool change;

  const _IncludesExtraFood(this.article, this.image, this.change);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: 300,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            const BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            // IMAGEN :
            Container(
              width: 70,
              height: 70,
              child: Image.asset(this.image),
            ),
            // NAME :
            const SizedBox(width: 15),
            Text(this.article,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const Spacer(),
            // CHANGE :
            if (change)
              Container(
                alignment: Alignment.center,
                width: 85,
                height: 45,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Change',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}

class _ExtrasFood {
  final String article;
  final String image;
  final bool change;

  _ExtrasFood(this.article, this.image, this.change);
}
