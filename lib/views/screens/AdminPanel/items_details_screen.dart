// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
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
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
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
            return Center(
              child: CircularProgressIndicator(
                color: greenColor,
              ),
            );
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
              SizedBox(
                height: 200,
                child: itemImage.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: itemImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            color: greenColor,
                            strokeWidth: 4.0,
                          ),
                        ), // Placeholder while loading
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error), //in case of error
                      )
                    : Placeholder(
                        color: Colors.green,
                        child: Icon(
                          Icons.check_circle_outline,
                          color: blueColor,
                          size: 70,
                        ),
                      ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                    ),
                    onPressed: () {
                      // update item function
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
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Update Item',
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _deleteItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: redColor,
                    ),
                    child: Text(
                      'Delete Item',
                      style: TextStyle(color: whiteColor),
                    ),
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
          surfaceTintColor: whiteColor,
          backgroundColor: whiteColor,
          title: Text(
            'Confirm Delete',
            style: TextStyle(color: blueColor),
          ),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: greenColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                Utils().toastMessage("Item deleted");
              },
              child: Text(
                'Delete',
                style: TextStyle(color: redColor),
              ),
            ),
          ],
        );
      },
    );

    // ignore: unnecessary_null_comparison
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

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }
}
