import 'package:euro_wings/utils/customNavigation.dart';
import 'package:euro_wings/utils/themes.dart';
import 'package:euro_wings/views/selectedFood.dart';
import 'package:flutter/material.dart';

class OptionsFoods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: primary),
                borderRadius: const BorderRadius.all(Radius.circular(50))),
            child: const Image(
              image: AssetImage('images/staff/image0.png'),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
      body: Column(
        children: [
          // definicion de direccion :
          _DateTimes(Colors.black.withOpacity(0.9),
              'F R E S H - I N D R I E D I E N T S', 'Tasty Thrills'),
          // fecha actual :
          _DateTimes(Colors.blueGrey.shade900,
              'T R A D I T I O N A L - R E C I P I E', 'Affordable Bills'),
          // Tables Food :
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _TablesMenusOpts(),
            ),
          ),
          // Botom secret menu :
          _ButtomMoreMenus(),
        ],
      ),
      bottomNavigationBar: CustomNavigatorBar(),
    );
  }
}

class _DateTimes extends StatelessWidget {
  final String title;
  final String address;
  final Color color;
  const _DateTimes(this.color, this.address, this.title);

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
          Text(this.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22)),
          const SizedBox(height: 10),
          Text(this.address, style: const TextStyle(color: primary))
        ],
      ),
    );
  }
}

class _ButtomMoreMenus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        alignment: Alignment.center,
        height: 60,
        width: 350,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text('Secret Menu',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _TablesMenusOpts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      width: double.infinity,
      height: 620,
      child: Table(
        children: const <TableRow>[
          TableRow(
            children: [
              _TableRowsMenus('Combos Hamburgesas', 'images/hamburger.png'),
              _TableRowsMenus('Fajitas', 'images/fajita.png'),
            ],
          ),
          TableRow(
            children: [
              _TableRowsMenus('Salchipapas', 'images/salchipapa.png'),
              _TableRowsMenus('Pizzas', 'images/pizza.png'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TableRowsMenus extends StatelessWidget {
  final String description;
  final String image;
  const _TableRowsMenus(this.description, this.image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => SelectedFoodScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              // IMAGEN :
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 125,
                child: Image.asset(this.image),
              ),
              const SizedBox(height: 20),
              // DESCRIPTION :
              Text(
                this.description,
                style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                    color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
