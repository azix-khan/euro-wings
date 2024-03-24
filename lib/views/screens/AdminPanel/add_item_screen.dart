import 'dart:io';

import 'package:euro_wings/constants/colors.dart';
import 'package:euro_wings/views/custom_widgets/custom_text_form_field.dart';
import 'package:euro_wings/views/custom_widgets/widgets/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../custom_widgets/widgets/round_button.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerDesc = TextEditingController();
  bool loading = false;

  GlobalKey<FormState> key = GlobalKey();

  final CollectionReference _categoriesReference =
      FirebaseFirestore.instance.collection('categories');

  String imageUrl = '';
  String selectedCategory = '';

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
        title: const Text('Add Item'),
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
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: greenColor),
                  ),
                  child: imageUrl.isEmpty
                      ? IconButton(
                          onPressed: _uploadImage,
                          icon: Icon(
                            Icons.photo,
                            size: 55,
                            color: greenColor,
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
                // Fetch category names from Firestore
                StreamBuilder<QuerySnapshot>(
                  stream: _categoriesReference.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator(
                        color: greenColor,
                      );
                    }

                    var categories = snapshot.data!.docs;

                    return DropdownButtonFormField<String>(
                      value: selectedCategory.isNotEmpty
                          ? selectedCategory
                          : categories.isNotEmpty
                              ? categories[0].get('name')
                              : '',
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.get('name'),
                          child: Text(category.get('name')),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        prefixIcon: Icon(
                          Icons.category_outlined,
                          color: greenColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: greenColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: greenColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: greenColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                CustomTextFormField(
                  controller: _controllerName,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item name';
                    }
                    return null;
                  },
                  prefixIcon: Icon(
                    Icons.text_snippet_outlined,
                    color: greenColor,
                  ),
                  labelText: 'Item Name',
                  hintText: 'Enter the name of the item',
                ),

                const SizedBox(
                  height: 18,
                ),
                CustomTextFormField(
                  controller: _controllerPrice,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item price';
                    }
                    return null;
                  },
                  prefixIcon: Icon(
                    Icons.price_check_outlined,
                    color: greenColor,
                  ),
                  labelText: 'Item Price',
                  hintText: 'Enter the price of the item',
                ),

                const SizedBox(
                  height: 18,
                ),
                CustomTextFormField(
                  controller: _controllerDesc,
                  maxline: 3,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the item description';
                    }
                    return null;
                  },
                  prefixIcon: Icon(
                    Icons.description_outlined,
                    color: greenColor,
                  ),
                  labelText: 'Enter Description',
                  hintText: 'Enter the description of the item',
                ),
                const SizedBox(
                  height: 18,
                ),

                // add prices for S,M,L pizza

                // Container(
                //   padding: const EdgeInsets.all(10),
                //   color: Colors.grey[200],
                //   child: const Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Prices:',
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           fontSize: 16,
                //         ),
                //       ),
                //       Row(
                //         children: [
                //           Expanded(
                //             child: TextField(
                //               // controller: smallPriceController,
                //               decoration: InputDecoration(
                //                 labelText: 'Small',
                //                 prefixText: 'RS - ',
                //               ),
                //               keyboardType: TextInputType.numberWithOptions(
                //                   decimal: true),
                //             ),
                //           ),
                //           SizedBox(width: 10),
                //           Expanded(
                //             child: TextField(
                //               // controller: mediumPriceController,
                //               decoration: InputDecoration(
                //                 labelText: 'Medium',
                //                 prefixText: 'RS - ',
                //               ),
                //               keyboardType: TextInputType.numberWithOptions(
                //                   decimal: true),
                //             ),
                //           ),
                //           SizedBox(width: 10),
                //           Expanded(
                //             child: TextField(
                //               // controller: largePriceController,
                //               decoration: InputDecoration(
                //                 labelText: 'Large',
                //                 prefixText: 'RS - ',
                //               ),
                //               keyboardType: TextInputType.numberWithOptions(
                //                   decimal: true),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(
                //   height: 18,
                // ),
                RoundButton(
                  loading: loading,
                  title: 'Add Item',
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });

                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please upload an image'),
                      ));
                      setState(() {
                        loading = false;
                      });
                      return;
                    }

                    if (key.currentState!.validate()) {
                      String itemName = _controllerName.text;
                      String itemPrice = _controllerPrice.text;
                      String itemdesc = _controllerDesc.text;

                      // Add the item to the 'items' subcollection of the selected category
                      await _categoriesReference
                          .doc(selectedCategory)
                          .collection('items')
                          .add({
                        'name': itemName,
                        'price': itemPrice,
                        'description': itemdesc,
                        'image': imageUrl,
                      });

                      Utils().toastMessage("Item added in $selectedCategory");

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
}
