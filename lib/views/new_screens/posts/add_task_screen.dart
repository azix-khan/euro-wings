// import 'dart:io';

// import 'package:euro_wings/views/new_screens/widgets/round_button.dart';
// import 'package:euro_wings/views/new_screens/widgets/utils/utils.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:image_picker/image_picker.dart';

// class AddTaskScreen extends StatefulWidget {
//   const AddTaskScreen({Key? key}) : super(key: key);

//   @override
//   State<AddTaskScreen> createState() => _AddTaskScreenState();
// }

// class _AddTaskScreenState extends State<AddTaskScreen> {
//   final postController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   String? imageURL;
//   bool loading = false;

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add New Item'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 30),
//               TextFormField(
//                 maxLines: 2,
//                 controller: postController,
//                 decoration: const InputDecoration(
//                   labelText: 'Add post',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               TextFormField(
//                 maxLines: 2,
//                 controller: nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               TextFormField(
//                 maxLines: 2,
//                 controller: priceController,
//                 decoration: const InputDecoration(
//                   labelText: 'price',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               TextFormField(
//                 maxLines: 2,
//                 controller: descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'description',
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               ElevatedButton(
//                 onPressed: () async {
//                   String? imageUrl = await uploadImage();
//                   if (imageUrl != null) {
//                     setState(() {
//                       this.imageURL = imageUrl;
//                     });
//                   }
//                 },
//                 child: const Text('Pick Image'),
//               ),
//               if (imageURL != null)
//                 Container(
//                     height: 100,
//                     width: 200,
//                     child: Image.network(
//                         imageURL!)), // Display the image if available
//               const SizedBox(height: 30),
//               RoundButton(
//                 loading: loading,
//                 title: 'Add Item',
//                 onTap: () async {
//                   setState(() {
//                     loading = true;
//                   });

//                   final tasksCollection =
//                       FirebaseFirestore.instance.collection('foodItems');

//                   // Create a new foodItem document in Firestore with the user's ID
//                   await tasksCollection.add({
//                     'userId': user?.uid,
//                     'title': postController.text.toString(),
//                     'name': nameController.text.toString(),
//                     'description': descriptionController.text.toString(),
//                     'price': priceController.text.toString(),
//                     'image':
//                         imageURL ?? '', // Use empty string if imageURL is null
//                     'timestamp': FieldValue.serverTimestamp(),
//                   }).then((_) {
//                     postController.text = '';
//                     nameController.text = '';
//                     priceController.text = '';
//                     descriptionController.text = '';
//                     Utils().toastMessage('Food Item Added');
//                   }).catchError((error) {
//                     Utils().toastMessage(error.toString());
//                   }).whenComplete(() {
//                     setState(() {
//                       loading = false;
//                     });
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Method to handle image picking and uploading
//   Future<String?> uploadImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       try {
//         final imageFile = File(pickedFile.path);

//         // Generate a unique filename or use a dynamic one
//         final String fileName =
//             DateTime.now().millisecondsSinceEpoch.toString();

//         // Upload the image to Firebase Storage and get the URL
//         final storageReference = firebase_storage.FirebaseStorage.instance
//             .ref('food_items_images')
//             .child(fileName);
//         await storageReference.putFile(imageFile);

//         // Get the download URL
//         String imageURL = await storageReference.getDownloadURL();
//         return imageURL;
//       } catch (e) {
//         print('Error uploading image: $e');
//         return null; // or handle accordingly
//       }
//     } else {
//       // User canceled the image picking
//       return null; // or handle accordingly
//     }
//   }
// }

import 'dart:io';

import 'package:euro_wings/views/new_screens/widgets/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('foodItems');

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _controllerName,
                decoration: const InputDecoration(
                    hintText: 'Enter the name of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _controllerPrice,
                decoration: const InputDecoration(
                    hintText: 'Enter the price of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item price';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _controllerDesc,
                decoration: const InputDecoration(
                    hintText: 'Enter the description of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item description';
                  }

                  return null;
                },
              ),
              IconButton(
                  onPressed: () async {
                    /*Pick image*/
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    // print('${file?.path}');

                    if (file == null) return;
                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    /* Upload to Firebase storage*/

                    //Get a reference to storage root
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('images');

                    //Create a reference for the image to be stored
                    Reference referenceImageToUpload =
                        referenceDirImages.child(uniqueFileName);

                    //Handle errors/success
                    try {
                      //Store the file
                      await referenceImageToUpload.putFile(File(file!.path));
                      //Success: get the download URL
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {
                      //Some error occurred
                      Utils().toastMessage(error.toString());
                    }
                  },
                  icon: const Icon(Icons.camera_alt)),
              ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please upload an image')));

                      return;
                    }

                    if (key.currentState!.validate()) {
                      String itemName = _controllerName.text;
                      String itemPrice = _controllerPrice.text;
                      String itemdesc = _controllerDesc.text;

                      //Create a Map of data
                      Map<String, String> dataToSend = {
                        'name': itemName,
                        'price': itemPrice,
                        'description': itemdesc,
                        'image': imageUrl,
                      };

                      //Add a new item
                      _reference.add(dataToSend);
                    }
                  },
                  child: const Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
