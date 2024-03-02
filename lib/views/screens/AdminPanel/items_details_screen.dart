import 'package:euro_wings/constants/colors.dart';
import 'package:euro_wings/views/custom_widgets/widgets/utils/utils.dart';
import 'package:euro_wings/views/screens/AdminPanel/update_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String categoryName;
  final String itemId;

  const ItemDetailsScreen(
      {Key? key, required this.categoryName, required this.itemId})
      : super(key: key);

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final CollectionReference _itemsReference =
      FirebaseFirestore.instance.collection('categories');

  late String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          'Item Details',
          style: TextStyle(color: greenColor),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _itemsReference
            .doc(widget.categoryName)
            .collection('items')
            .doc(widget.itemId)
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

          imageUrl = itemImage;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                child: itemImage.isNotEmpty
                    ? Image.network(
                        itemImage,
                        fit: BoxFit.cover,
                      )
                    : const Placeholder(
                        color: Colors.green,
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 70,
                        ),
                      ), // You can replace Placeholder() with any other widget or message
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: greenColor),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Price: $itemPrice',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateItemScreen(
                                    categoryName: widget.categoryName,
                                    foodItem: {
                                      'id': widget.itemId,
                                      'name': itemName,
                                      'price': itemPrice,
                                      'description': itemDescription,
                                      'image': itemImage,
                                    },
                                  )));
                    },
                    child: const Text('Update Item'),
                  ),
                  ElevatedButton(
                    onPressed: _deleteItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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

  // delete item functionality

  Future<void> _deleteItem() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                Utils().toastMessage("Item deleted");
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete != null && confirmDelete) {
      await _itemsReference
          .doc(widget.categoryName)
          .collection('items')
          .doc(widget.itemId)
          .delete();

      if (imageUrl.isNotEmpty) {
        Reference referenceToDelete =
            FirebaseStorage.instance.refFromURL(imageUrl);
        await referenceToDelete.delete();
      }

      Navigator.pop(context);
    }
  }
}
