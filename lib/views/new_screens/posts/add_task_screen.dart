import 'dart:io';

import 'package:euro_wings/views/new_screens/widgets/round_button.dart';
import 'package:euro_wings/views/new_screens/widgets/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? imageURL;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 2,
              controller: postController,
              decoration: const InputDecoration(
                labelText: 'Add post',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              maxLines: 2,
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'name',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              maxLines: 2,
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'price',
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              maxLines: 2,
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'description',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String? imageUrl = await uploadImage();
                if (imageUrl != null) {
                  setState(() {
                    imageURL = imageUrl;
                  });
                }
              },
              child: const Text('Pick Image'),
            ),
            if (imageURL != null)
              Image.network(imageURL!), // Display the image if available
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              loading: loading,
              title: 'Add Item',
              onTap: () {
                setState(() {
                  loading = true;
                });

                final tasksCollection =
                    FirebaseFirestore.instance.collection('foodItems');

                // Create a new foodItem document in Firestore with the user's ID
                tasksCollection.add({
                  'userId': user?.uid,
                  'title': postController.text.toString(),
                  'name': nameController.text.toString(),
                  'description': descriptionController.text.toString(),
                  'price': priceController.text.toString(),
                  'image':
                      imageURL ?? '', // Use empty string if imageURL is null
                }).then((_) {
                  postController.text = '';
                  Utils().toastMessage('Food Item Added');
                  setState(() {
                    loading = false;
                  });
                }).catchError((error) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Method to handle image picking and uploading
Future<String?> uploadImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    try {
      final imageFile = File(pickedFile.path);

      // Generate a unique filename or use a dynamic one
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

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
