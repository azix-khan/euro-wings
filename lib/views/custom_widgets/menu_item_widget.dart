import 'package:euro_wings/Models/menu_model.dart';
import 'package:euro_wings/views/screens/selectedFood.dart';
import 'package:flutter/material.dart';

class MenuItems extends StatelessWidget {
  final Menu menu;

  MenuItems({required this.menu});

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
                child: Image.asset(menu.image),
              ),
              const SizedBox(height: 20),
              // DESCRIPTION :
              Text(
                menu.description,
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
