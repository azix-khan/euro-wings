import 'package:euro_wings/Models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _imageURL = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('food_items').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var foodItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              var food =
                  Food.fromMap(foodItems[index].data() as Map<String, dynamic>);
              food.id = foodItems[index].id;

              return ListTile(
                title: Text(food.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\$${food.price}'),
                    Text(food.title),
                    Text(food.description),
                  ],
                ),
                leading: Image.network(food.imageURL),
                onTap: () {
                  // Implement the logic for editing the food item
                  _nameController.text = food.name;
                  _priceController.text = food.price.toString();
                  _titleController.text = food.title;
                  _descriptionController.text = food.description;
                  _imageURL = food.imageURL;

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Edit Food Item'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration:
                                    const InputDecoration(labelText: 'Name'),
                              ),
                              TextFormField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(labelText: 'Price'),
                              ),
                              TextFormField(
                                controller: _titleController,
                                decoration:
                                    const InputDecoration(labelText: 'Title'),
                              ),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                    labelText: 'Description'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  String? imageUrl = await uploadImage();
                                  if (imageUrl != null) {
                                    setState(() {
                                      _imageURL = imageUrl;
                                    });
                                  }
                                },
                                child: const Text('Pick Image'),
                              ),
                              if (_imageURL.isNotEmpty)
                                Image.network(_imageURL),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Implement the logic to update the food item
                              await editFoodItem(
                                food.id,
                                _nameController.text,
                                double.parse(_priceController.text),
                              );
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onLongPress: () {
                  // Implement the logic for deleting the food item
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Food Item'),
                        content: Text(
                            'Are you sure you want to delete ${food.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Implement the logic to delete the food item
                              await deleteFoodItem(food.id);
                              Navigator.pop(context); // Close the dialog
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement the logic for adding a new food item
          _showAddFoodDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Edit existing food item
  Future<void> editFoodItem(String id, String name, double price) async {
    await _firestore.collection('food_items').doc(id).update({
      'name': name,
      'price': price,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imageURL': _imageURL,
    });
  }

  // Delete food item
  Future<void> deleteFoodItem(String id) async {
    await _firestore.collection('food_items').doc(id).delete();
  }

  // Method to handle image picking and uploading
  Future<String?> uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final imageFile = File(pickedFile.path);

        // Generate a unique filename or use a dynamic one
        final String fileName =
            DateTime.now().millisecondsSinceEpoch.toString();

        // Upload the image to Firebase Storage and get the URL
        final storageReference = firebase_storage.FirebaseStorage.instance
            .ref('food_items_images')
            .child(fileName);
        await storageReference.putFile(imageFile);

        // Get the download URL
        String imageURL = await storageReference.getDownloadURL();
        return imageURL;
      } catch (e) {
        print('Error uploading image: $e');
        return null; // or handle accordingly
      }
    } else {
      // User canceled the image picking
      return null; // or handle accordingly
    }
  }

  // Show dialog for adding a new food item
  void _showAddFoodDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Food Item'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String? imageUrl = await uploadImage();
                    if (imageUrl != null) {
                      setState(() {
                        _imageURL = imageUrl;
                      });
                    }
                  },
                  child: const Text('Pick Image'),
                ),
                if (_imageURL.isNotEmpty) Image.network(_imageURL),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Implement the logic to add the new food item
                await addNewFoodItem();
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Add new food item
  Future<void> addNewFoodItem() async {
    try {
      await _firestore.collection('food_items').add({
        'name': _nameController.text,
        'price': double.parse(_priceController.text),
        'title': _titleController.text,
        'description': _descriptionController.text,
        'imageURL': _imageURL,
      });

      // Clear the controllers and imageURL after adding the item
      _nameController.clear();
      _priceController.clear();
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _imageURL = '';
      });
    } catch (e) {
      print('Error adding new food item: $e');
      // Handle the error, you can show a snackbar or dialog with an error message
      // Or any other error handling mechanism you prefer
    }
  }
}
