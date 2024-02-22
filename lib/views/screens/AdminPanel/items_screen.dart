import 'package:euro_wings/constants/colors.dart';
import 'package:euro_wings/constants/themes.dart';
import 'package:euro_wings/views/screens/AdminPanel/add_item_screen.dart';
import 'package:euro_wings/views/screens/AdminPanel/new_category_screen.dart';
import 'package:euro_wings/views/screens/AdminPanel/setected_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeScreen extends StatelessWidget {
  final CollectionReference _categoriesReference =
      FirebaseFirestore.instance.collection('categories');

  AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          'Categories',
          style: TextStyle(color: greenColor),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _categoriesReference.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(
              color: orangeColor,
            );
          }

          var categories = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectedCategoryScreen(
                        categoryName: category.get('name'),
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Image.network(
                          category.get('image'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        color: greenColor,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          category.get('name'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xff002244),
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddItemScreen()));
              },
              child: const Text(
                'Add Item',
                style: TextStyle(
                    color: primary, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddCategoryScreen()));
              },
              child: const Text(
                'Add Category',
                style: TextStyle(
                    color: primary, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
