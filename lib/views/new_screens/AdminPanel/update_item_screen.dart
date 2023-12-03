import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euro_wings/views/new_screens/widgets/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateItemScreen extends StatelessWidget {
  UpdateItemScreen(this._foodItem, {Key? key}) {
    _controllerName = TextEditingController(text: _foodItem['name']);
    _controllerPrice = TextEditingController(text: _foodItem['price']);
    _controllerDesc = TextEditingController(text: _foodItem['description']);

    _reference =
        FirebaseFirestore.instance.collection('foodItems').doc(_foodItem['id']);
  }

  Map _foodItem;
  late DocumentReference _reference;

  late TextEditingController _controllerName;
  late TextEditingController _controllerPrice;
  late TextEditingController _controllerDesc;
  GlobalKey<FormState> _key = GlobalKey();
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
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
                    // Reference referenceRoot = FirebaseStorage.instance.ref();
                    // Reference referenceDirImages =
                    //     referenceRoot.child('images');

                    // //Create a reference for the image to be stored
                    // Reference referenceImageToUpload =
                    //     referenceDirImages.child(uniqueFileName);

                    //Get a reference of the existring image

                    Reference referenceImageToUpload =
                        FirebaseStorage.instance.refFromURL(_foodItem['image']);

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
                    if (_key.currentState!.validate()) {
                      String name = _controllerName.text;
                      String price = _controllerPrice.text;
                      String description = _controllerDesc.text;

                      //Create the Map of data
                      Map<String, String> dataToUpdate = {
                        'name': name,
                        'price': price,
                        'description': description,
                        'image': imageUrl,
                      };

                      //Call update()
                      _reference.update(dataToUpdate);
                    }
                  },
                  child: const Text('Update'))
            ],
          ),
        ),
      ),
    );
  }
}
