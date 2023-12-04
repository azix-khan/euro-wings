import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euro_wings/constants/colors.dart';
import 'package:euro_wings/views/new_screens/widgets/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateItemScreen extends StatefulWidget {
  UpdateItemScreen(this._foodItem, {Key? key}) {
    _controllerName = TextEditingController(text: _foodItem['name']);
    _controllerPrice = TextEditingController(text: _foodItem['price']);
    _controllerDesc = TextEditingController(text: _foodItem['description']);

    _reference =
        FirebaseFirestore.instance.collection('foodItems').doc(_foodItem['id']);
  }

  final Map _foodItem;
  late DocumentReference _reference;

  late TextEditingController _controllerName;
  late TextEditingController _controllerPrice;
  late TextEditingController _controllerDesc;
  final GlobalKey<FormState> _key = GlobalKey();
  String imageUrl = '';

  @override
  _UpdateItemScreenState createState() => _UpdateItemScreenState();
}

class _UpdateItemScreenState extends State<UpdateItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update an item',
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
          child: Form(
            key: widget._key,
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: backgroundColor),
                  ),
                  child: widget.imageUrl.isEmpty
                      ? IconButton(
                          onPressed: () async {
                            //Pick image
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );

                            if (file != null) {
                              _updateImageUrl(file);
                            }
                          },
                          icon: const Icon(
                            Icons.photo,
                            size: 55,
                            color: Colors.blue,
                          ),
                        )
                      : Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  controller: widget._controllerName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: 'Name',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  controller: widget._controllerPrice,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: 'Price',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item price';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  controller: widget._controllerDesc,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: 'Description',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item description';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: greenColor),
                  onPressed: () async {
                    if (widget._key.currentState!.validate()) {
                      String name = widget._controllerName.text;
                      String price = widget._controllerPrice.text;
                      String description = widget._controllerDesc.text;

                      // Create the Map of data
                      Map<String, String> dataToUpdate = {
                        'name': name,
                        'price': price,
                        'description': description,
                        'image': widget.imageUrl,
                      };

                      // Call update()
                      widget._reference.update(dataToUpdate);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Utils().toastMessage('Item Updated');
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateImageUrl(XFile file) async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceImageToUpload =
        FirebaseStorage.instance.refFromURL(widget._foodItem['image']);

    try {
      await referenceImageToUpload.putFile(File(file.path));
      widget.imageUrl = await referenceImageToUpload.getDownloadURL();
      setState(() {});
    } catch (error) {
      Utils().toastMessage(error.toString());
    }
  }
}
