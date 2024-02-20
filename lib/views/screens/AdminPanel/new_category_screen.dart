import 'dart:io';

import 'package:euro_wings/constants/colors.dart';
import 'package:euro_wings/views/custom_widgets/widgets/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);

  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _controllerName = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  final CollectionReference _categoriesReference =
      FirebaseFirestore.instance.collection('categories');

  String imageUrl = '';

  Future<void> _uploadImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      setState(() {});
    } catch (error) {
      Utils().toastMessage(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Category'),
        elevation: 0,
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
                          onPressed: _uploadImage,
                          icon: const Icon(
                            Icons.photo,
                            size: 55,
                            color: Colors.blue,
                          ),
                        )
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
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: 'Enter the new category name',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the category name';
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please upload an image')));
                      return;
                    }

                    if (key.currentState!.validate()) {
                      await _categoriesReference.add({
                        'name': _controllerName.text,
                        'image': imageUrl,
                      });

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add Category'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
