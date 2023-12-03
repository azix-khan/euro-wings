import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euro_wings/views/new_screens/AdminPanel/update_item_screen.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item details'),
        actions: [
          IconButton(
              onPressed: () {
                //add the id to the map
                data['id'] = itemId;

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UpdateItemScreen(data)));
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                //Delete the item
                _reference.delete();
              },
              icon: const Icon(Icons.delete))
        ],
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
            return Column(
              children: [
                Text('${data['name']}'),
                Text('${data['price']}'),
                Text('${data['description']}'),
                Container(
                  height: 40,
                  width: 40,
                  child: SingleChildScrollView(
                    child: Image.network(
                      data['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
