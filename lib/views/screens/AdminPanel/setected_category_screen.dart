import 'package:euro_wings/constants/colors.dart';
import 'package:euro_wings/views/screens/AdminPanel/items_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SelectedCategoryScreen extends StatelessWidget {
  final String categoryName;
  final String categoryImage;

  SelectedCategoryScreen(
      {required this.categoryName, required this.categoryImage});

  final CollectionReference _categoriesReference =
      FirebaseFirestore.instance.collection('categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              height: 200,
              child: Image.network(categoryImage),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              categoryName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _buildItemsList(categoryName),
          ),
        ],
      ),
    );
  }

  // list of items in each category
  Widget _buildItemsList(String categoryName) {
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesReference
          .doc(categoryName)
          .collection('items')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: orangeColor));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var items = snapshot.data!.docs;

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index].data() as Map<String, dynamic>? ?? {};
            return Card(
              elevation: 5,
              margin: const EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(item['name'] as String? ?? ''),
                subtitle: Text(item['description'] as String? ?? ''),
                trailing: Text('\$${item['price'] as String? ?? ''}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailsScreen(
                        categoryName: categoryName,
                        itemId: items[index].id,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
