import 'package:euro_wings/views/screens/AdminPanel/add_item_screen.dart';
import 'package:euro_wings/views/screens/AdminPanel/new_category_screen.dart';
import 'package:euro_wings/views/screens/AdminPanel/setected_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeScreen extends StatelessWidget {
  final CollectionReference _categoriesReference =
      FirebaseFirestore.instance.collection('categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _categoriesReference.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
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
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddItemScreen()));
              },
              child: Text(
                'Add Item',
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCategoryScreen()));
              },
              child: Text(
                'Add Category',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
