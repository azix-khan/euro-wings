import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euro_wings/constants/colors.dart';
import 'package:euro_wings/views/custom_widgets/custom_text_form_field.dart';
import 'package:euro_wings/views/custom_widgets/widgets/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../custom_widgets/widgets/round_button.dart';

class UpdateItemScreen extends StatefulWidget {
  final Map? foodItem;
  final String categoryName;

  const UpdateItemScreen({Key? key, required this.categoryName, this.foodItem})
      : super(key: key);

  @override
  UpdateItemScreenState createState() => UpdateItemScreenState();
}

class UpdateItemScreenState extends State<UpdateItemScreen> {
  late DocumentReference _reference;
  late TextEditingController _controllerName;
  late TextEditingController _controllerPrice;
  late TextEditingController _controllerDesc;
  final GlobalKey<FormState> _key = GlobalKey();
  String imageUrl = '';
  bool isUpdatingImage = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _controllerName =
        TextEditingController(text: widget.foodItem?['name'] ?? '');
    _controllerPrice =
        TextEditingController(text: widget.foodItem?['price'] ?? '');
    _controllerDesc =
        TextEditingController(text: widget.foodItem?['description'] ?? '');
    _reference = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryName)
        .collection('items')
        .doc(widget.foodItem?['id']);
    imageUrl = widget.foodItem?['image'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update an item'),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
          child: Form(
            key: _key,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (imageUrl.isNotEmpty)
                      CircleAvatar(
                        radius: 100.0,
                        backgroundImage: CachedNetworkImageProvider(imageUrl),
                      ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );

                          if (file != null) {
                            _updateImageUrl(file);
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            isUpdatingImage ? Icons.done : Icons.photo_camera,
                            size: 30,
                            color: isUpdatingImage ? Colors.green : greenColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                CustomTextFormField(
                  controller: _controllerName,
                  prefixIcon: Icon(
                    Icons.production_quantity_limits,
                    color: greenColor,
                  ),
                  labelText: 'Name',
                  hintText: 'Enter Name',
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
                CustomTextFormField(
                  controller: _controllerPrice,
                  prefixIcon: Icon(
                    Icons.price_check,
                    color: greenColor,
                  ),
                  labelText: 'Price',
                  hintText: 'Enter Price',
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
                CustomTextFormField(
                  maxline: 3,
                  controller: _controllerDesc,
                  prefixIcon: Icon(
                    Icons.description_outlined,
                    color: greenColor,
                  ),
                  labelText: 'Description',
                  hintText: 'Enter Description',
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
                RoundButton(
                  loading: loading,
                  title: 'Update',
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });

                    if (_key.currentState!.validate()) {
                      String name = _controllerName.text;
                      String price = _controllerPrice.text;
                      String description = _controllerDesc.text;

                      // Create the Map of data
                      Map<String, String> dataToUpdate = {
                        'name': name,
                        'price': price,
                        'description': description,
                        'image': imageUrl,
                      };

                      // Call update()
                      _reference.update(dataToUpdate);
                      Utils().toastMessage('Item Updated');

                      setState(() {
                        loading = false;
                      });

                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateImageUrl(XFile file) async {
    setState(() {
      isUpdatingImage = true;
    });

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceImageToUpload =
        FirebaseStorage.instance.ref().child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(file.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      setState(() {
        isUpdatingImage = false;
      });
    } catch (error) {
      Utils().toastMessage(error.toString());
      setState(() {
        isUpdatingImage = false;
      });
    }
  }
}
