import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euro_wings/constants/colors.dart';
import 'package:euro_wings/views/screens/AdminPanel/add_item_screen.dart';
import 'package:euro_wings/views/screens/AdminPanel/items_details_screen.dart';
import 'package:euro_wings/views/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../custom_widgets/widgets/utils/utils.dart';

// ignore: must_be_immutable
class ItemsScreen extends StatelessWidget {
  ItemsScreen({Key? key}) : super(key: key) {
    _stream = _reference.snapshots();
  }
  String categoryName = 'pizza'; // Default category
  int btnSelected = 0;
  String selectedCategory = 'Pizza';

  List<String> categoriesList = [
    'Pizza',
    'Burger',
    'Shwarma',
    'Wings',
    'Fries',
    'Pasta',
    'Chowmien',
  ];

  final FirebaseAuth auth = FirebaseAuth.instance;

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('foodItems');

  late Stream<QuerySnapshot> _stream;
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food Items',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
            )),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: Icon(
              Icons.logout,
              color: orangeColor,
            ),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.05,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor:
                                // categoriesList[index] == selectedCategory
                                // ? Colors.blueAccent
                                Colors.blueAccent
                            // : Colors.grey,
                            ),
                        onPressed: () {
                          // fetchDataForCategory(categoriesList[index]);
                        },
                        child: Text(
                          categoriesList[index],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(height: height * 0.03),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  try {
                    //Check error
                    if (snapshot.hasError) {
                      return Center(
                          child:
                              Utils().toastMessage(snapshot.error.toString()));
                    }

                    //Check if data arrived
                    if (snapshot.hasData) {
                      //get the data
                      QuerySnapshot querySnapshot = snapshot.data;
                      List<QueryDocumentSnapshot> documents =
                          querySnapshot.docs;

                      //Convert the documents to Maps
                      List<Map> items = documents
                          .map((e) => {
                                'id': e.id,
                                'name': e['name'],
                                'price': e['price'],
                                'description': e['description'],
                                'image': e['image'],
                              })
                          .toList();

                      //Display the list
                      return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            //Get the item at this index
                            Map thisItem = items[index];
                            //REturn the widget for the list items
                            return ListTile(
                              title: Text('${thisItem['name']}'),
                              trailing: Text('${thisItem['price']}'),
                              subtitle: Text('${thisItem['description']}'),
                              leading: SizedBox(
                                height: 80,
                                width: 80,
                                child: thisItem.containsKey('image')
                                    ? Image.network(
                                        '${thisItem['image']}',
                                        fit: BoxFit.cover,
                                      )
                                    : Container(),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ItemDetailsScreen(thisItem['id'])));
                              },
                            );
                          });
                    }

                    //Show loader
                    return const Center(child: CircularProgressIndicator());
                  } catch (error) {
                    return Center(
                      child: Utils().toastMessage(error.toString()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddItemScreen()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
