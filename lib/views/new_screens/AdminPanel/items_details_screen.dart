import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euro_wings/constants/colors.dart';
import 'package:euro_wings/views/new_screens/AdminPanel/update_item_screen.dart';
import 'package:euro_wings/views/new_screens/widgets/utils/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ItemDetailsScreen extends StatelessWidget {
  ItemDetailsScreen(this.itemId, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('foodItems').doc(itemId);
    _futureData = _reference.get();
  }

  String itemId;
  late DocumentReference _reference;

  late Future<DocumentSnapshot> _futureData;
  late Map data;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Item Details',
        ),
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
            )),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            //Get the data
            DocumentSnapshot documentSnapshot = snapshot.data;
            data = documentSnapshot.data() as Map;

            //display the data
            return Stack(
              children: [
                Container(
                  child: SizedBox(
                    height: height * .45,
                    width: width,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: data['image'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: height * 0.6,
                  margin: EdgeInsets.only(top: height * .4),
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Center(
                        child: Text(
                          '${data['name']}',
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                backgroundColor: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteItemDialog(
                                    context: context,
                                    reference: _reference,
                                  ).build();
                                },
                              );
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: whiteColor),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                backgroundColor: greenColor),
                            onPressed: () {
                              //add the id to the map
                              data['id'] = itemId;

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateItemScreen(data)));
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(color: whiteColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      Center(
                        child: Text(
                          'Price: ${data['price']}',
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: blueColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Divider(),
                      Text(
                        'Description: \n\n${data['description']}',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
