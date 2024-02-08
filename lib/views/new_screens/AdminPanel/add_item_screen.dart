import 'dart:io';

import 'package:euro_wings/constants/colors.dart';
import 'package:euro_wings/views/new_screens/widgets/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
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
        title: const Text('Add an Item'),
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
          child: Form(
            key: key,
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: backgroundColor),
                  ),
                  child: imageUrl.isEmpty
                      ? IconButton(
                          onPressed: () async {
                            /*Pick image*/
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.gallery);
                            // print('${file?.path}');

                            if (file == null) return;
                            String uniqueFileName = DateTime.now()
                                .millisecondsSinceEpoch
                                .toString();

                            /* Upload to Firebase storage*/

                            //Get a reference to storage root
                            Reference referenceRoot =
                                FirebaseStorage.instance.ref();
                            Reference referenceDirImages =
                                referenceRoot.child('images');

                            //Create a reference for the image to be stored
                            Reference referenceImageToUpload =
                                referenceDirImages.child(uniqueFileName);

                            //Handle errors/success
                            try {
                              //Store the file
                              await referenceImageToUpload
                                  .putFile(File(file!.path));
                              //Success: get the download URL
                              imageUrl =
                                  await referenceImageToUpload.getDownloadURL();
                              setState(() {});
                            } catch (error) {
                              //Some error occurred
                              Utils().toastMessage(error.toString());
                            }
                          },
                          icon: const Icon(
                            Icons.photo,
                            size: 55,
                            color: Colors.blue,
                          ),
                        ) // show image if selected
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  controller: _controllerName,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      labelText: 'Enter the name of the item'),
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
                  controller: _controllerPrice,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: 'Enter the price of the item'),
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
                  controller: _controllerDesc,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      labelText: 'Enter the description of the item'),
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
                    onPressed: () async {
                      if (imageUrl.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
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
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Submit'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
