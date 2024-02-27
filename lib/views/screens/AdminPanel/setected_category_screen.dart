import 'package:euro_wings/constants/colors.dart';
import 'package:euro_wings/views/screens/AdminPanel/items_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SelectedCategoryScreen extends StatelessWidget {
  final String categoryName;

  SelectedCategoryScreen({required this.categoryName});

  final CollectionReference _categoriesReference =
      FirebaseFirestore.instance.collection('categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _categoriesReference
            .doc(categoryName)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(
              color: orangeColor,
            );
          }

          var items = snapshot.data!.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: _categoriesReference.doc(categoryName).get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(); // Placeholder for loading image
                  }

                  var categoryData =
                      snapshot.data!.data() as Map<String, dynamic>? ?? {};
                  var categoryImage = categoryData['image'] as String? ?? '';

                  return Container(
                    // image container
                    height: 200,
                    child: FutureBuilder(
                      future: firebase_storage.FirebaseStorage.instance
                          .ref(categoryImage)
                          .getDownloadURL(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: greenColor,
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        return Image.network(
                          snapshot.data.toString(),
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  );
                },
              ),
              Container(
                // name list present in firebase
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
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item =
                        items[index].data() as Map<String, dynamic>? ?? {};
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(item['name'] as String? ?? ''),
                        subtitle: Text(item['description'] as String? ?? ''),
                        trailing: Text('\$${item['price'] as String? ?? ''}'),
                        // letter i customize the ListTile
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
