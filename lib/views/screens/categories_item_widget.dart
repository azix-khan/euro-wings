import 'package:euro_wings/Models/categories_model.dart';
import 'package:euro_wings/constants/themes.dart';
import 'package:euro_wings/views/screens/payFood.dart';
import 'package:flutter/material.dart';

class CategoriesFood extends StatelessWidget {
  final Categories categories;

  // const CategoriesFood(subtitle, {super.key, required this.categories});
  const CategoriesFood(
      {Key? key, required this.categories, required String title})
      : super(key: key);

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
            boxShadow: const [
              BoxShadow(
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
                  Text(categories.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(categories.subtitle,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade500)),
                ],
              ),
              const Spacer(),
              Text(categories.price,
                  style: const TextStyle(
                      color: primary, fontWeight: FontWeight.bold)),
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
