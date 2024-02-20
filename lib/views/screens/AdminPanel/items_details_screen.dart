import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String categoryName;
  final String itemId;

  ItemDetailsScreen({required this.categoryName, required this.itemId});

  final CollectionReference _itemsReference =
      FirebaseFirestore.instance.collection('categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _itemsReference
            .doc(categoryName)
            .collection('items')
            .doc(itemId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var itemData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          var itemName = itemData['name'] as String? ?? '';
          var itemPrice = itemData['price'] as String? ?? '';
          var itemDescription = itemData['description'] as String? ?? '';
          var itemImage = itemData['image'] as String? ?? '';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                child: Image.network(
                  itemImage,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price: $itemPrice',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Description: $itemDescription',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implement update item functionality
                      // Navigate to the update item screen
                    },
                    child: const Text('Update Item'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement delete item functionality
                      // Show a confirmation dialog before deleting
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // Change the button color to red
                    ),
                    child: const Text('Delete Item'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
