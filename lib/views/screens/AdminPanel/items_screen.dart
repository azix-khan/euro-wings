import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euro_wings/constants/colors.dart';
import 'package:euro_wings/views/screens/AdminPanel/add_item_screen.dart';
import 'package:euro_wings/views/screens/AdminPanel/items_details_screen.dart';
import 'package:euro_wings/views/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({Key? key}) : super(key: key);

  @override
  ItemsScreenState createState() => ItemsScreenState();
}

class ItemsScreenState extends State<ItemsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('foodItems');
  late Stream<QuerySnapshot> _stream;

  List<String> categoriesList = [
    'Pizza',
    'Burger',
    'Shwarma',
    'Wings',
    'Fries',
    'Pasta',
    'Chowmien',
  ];

  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    _stream = _reference.snapshots();
    selectedCategory = categoriesList.isNotEmpty ? categoriesList[0] : '';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Items'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        // leading: InkWell(
        //   onTap: () {
        //     Navigator.of(context).pop();
        //   },
        //   child: const Icon(
        //     Icons.arrow_back_ios_new,
        //   ),
        // ),
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
                // Handle sign out error
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
                            categoriesList[index] == selectedCategory
                                ? Colors.blueAccent
                                : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedCategory = categoriesList[index];
                        });
                      },
                      child: Text(
                        categoriesList[index],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: height * 0.03),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  try {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (snapshot.hasData) {
                      QuerySnapshot querySnapshot = snapshot.data;
                      List<QueryDocumentSnapshot> documents =
                          querySnapshot.docs;

                      List<Map> items = documents
                          .where((e) => e['category'] == selectedCategory)
                          .map((e) => {
                                'id': e.id,
                                'name': e['name'],
                                'price': e['price'],
                                'description': e['description'],
                                'image': e['image'],
                              })
                          .toList();

                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map thisItem = items[index];
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ItemDetailsScreen(thisItem['id']),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }

                    return const Center(child: CircularProgressIndicator());
                  } catch (error) {
                    return Center(
                      child: Text(error.toString()),
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
            MaterialPageRoute(
              builder: (context) =>
                  AddItemScreen(selectedCategory: selectedCategory),
            ),
          );
        },
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
