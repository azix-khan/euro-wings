// import 'package:euro_wings/views/new_screens/auth/login_screen.dart';
// import 'package:euro_wings/views/new_screens/posts/add_task_screen.dart';
// import 'package:euro_wings/views/new_screens/widgets/utils/utils.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// class TasksScreen extends StatefulWidget {
//   const TasksScreen({Key? key}) : super(key: key);

//   @override
//   State<TasksScreen> createState() => _TasksScreenState();
// }

// class _TasksScreenState extends State<TasksScreen> {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final searchFilter = TextEditingController();
//   final itemsCollection = FirebaseFirestore.instance.collection('foodItems');

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     // final tasksCollection = FirebaseFirestore.instance.collection('foodItems');

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Notes Here'),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             onPressed: () {
//               auth.signOut().then((value) {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const LoginScreen(),
//                   ),
//                 );
//               }).onError((error, stackTrace) {
//                 Utils().toastMessage(error.toString());
//               });
//             },
//             icon: const Icon(Icons.logout),
//             tooltip: 'Sign Out',
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const AddItem(),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           children: [
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: TextFormField(
//                 controller: searchFilter,
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                     borderSide: const BorderSide(width: 1),
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     vertical: 0.0,
//                     horizontal: 18.0,
//                   ),
//                 ),
//                 onChanged: (_) => setState(() {}),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: itemsCollection
//                     .where('userId', isEqualTo: user?.uid)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text('No Items found.'));
//                   }

//                   final items = snapshot.data!.docs;

//                   return ListView.builder(
//                     itemCount: items.length,
//                     itemBuilder: (context, index) {
//                       final Map<String, dynamic> data =
//                           items[index].data() as Map<String, dynamic>;

//                       final title = data['title']?.toString() ?? '';
//                       final name = data['name']?.toString() ?? '';
//                       final description = data['description']?.toString() ?? '';
//                       final price = data['price']?.toString() ?? '';
//                       final imageReference =
//                           data['image'] != null ? data['image'].toString() : '';

//                       if (searchFilter.text.isEmpty ||
//                           title
//                               .toLowerCase()
//                               .contains(searchFilter.text.toLowerCase())) {
//                         return buildItemCard(
//                             title, name, description, price, imageReference);
//                       } else {
//                         return Container();
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildItemCard(String title, String name, String description,
//       String price, String imageReference) {
//     return Card(
//       elevation: 4,
//       color: Colors.teal,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 6.0,
//           horizontal: 0.0,
//         ),
//         title: InkWell(
//           onTap: () {
//             // Handle item click if needed
//           },
//           child: Card(
//             elevation: 4,
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             child: Container(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Text(
//                     title,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.black,
//                     ),
//                   ),
//                   Text(
//                     name,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.black,
//                     ),
//                   ),
//                   Text(
//                     description,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.black,
//                     ),
//                   ),
//                   Text(
//                     price,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       color: Colors.black,
//                     ),
//                   ),
//                   Container(
//                     height: 100,
//                     width: 100,
//                     child: imageReference.isNotEmpty
//                         ? FutureBuilder(
//                             future: FirebaseStorage.instance
//                                 .ref(imageReference)
//                                 .getDownloadURL(),
//                             builder: (BuildContext context,
//                                 AsyncSnapshot<String> snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return const CircularProgressIndicator();
//                               } else if (snapshot.hasError) {
//                                 return const Icon(Icons.error);
//                               } else {
//                                 return Image.network(snapshot.data!);
//                               }
//                             },
//                           )
//                         : const Placeholder(
//                             fallbackHeight: 100,
//                             fallbackWidth: 100,
//                             color: Colors.grey,
//                             child: Icon(
//                               Icons.error,
//                               color: Colors.red,
//                             ),
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         // trailing: PopupMenuButton(
//         //   icon: const Icon(Icons.more_vert),
//         //   itemBuilder: (context) => [
//         //     PopupMenuItem(
//         //       value: 1,
//         //       child: ListTile(
//         //         onTap: () {
//         //           Navigator.pop(context);
//         //           showMyDialog(
//         //             title,
//         //             items[index].id,
//         //           );
//         //         },
//         //         title: const Text('Edit'),
//         //         trailing: const Icon(Icons.edit),
//         //       ),
//         //     ),
//         //     PopupMenuItem(
//         //       value: 1,
//         //       child: ListTile(
//         //         onTap: () {
//         //           Navigator.pop(context);
//         //           showMyDialogForDelete(
//         //             items[index].id,
//         //           );
//         //         },
//         //         title: const Text(
//         //           'Delete',
//         //           style: TextStyle(color: Colors.red),
//         //         ),
//         //         trailing: const Icon(
//         //           Icons.delete,
//         //           color: Colors.red,
//         //         ),
//         //       ),
//         //     ),
//         //   ],
//         // ),
//       ),
//     );
//   }
// }
// //   Future<void> showMyDialogForUpdate(String title, String id) async {
// //     final editingController = TextEditingController(text: title);

// //     return showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: const Text('Update'),
// //           content: Container(
// //             child: TextField(
// //               maxLines: 6,
// //               controller: editingController,
// //               decoration: const InputDecoration(
// //                 border: OutlineInputBorder(),
// //                 hintText: 'Edit here',
// //               ),
// //             ),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.pop(context);
// //               },
// //               child: const Text('Cancel'),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 final tasksCollection =
// //                     FirebaseFirestore.instance.collection('tasks');
// //                 tasksCollection.doc(id).update({
// //                   'title': editingController.text.toString(),
// //                 }).then((value) {
// //                   Utils().toastMessage('Task Updated');
// //                   Navigator.pop(context);
// //                 }).catchError((error) {
// //                   Utils().toastMessage(error.toString());
// //                 });
// //               },
// //               child: const Text('Update'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// Future<void> showMyDialogForDelete(String id) async {
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text(
//           'Delete',
//           style: TextStyle(color: Colors.red),
//         ),
//         content: const Text('Do you really want to delete this task?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               final tasksCollection =
//                   FirebaseFirestore.instance.collection('tasks');
//               tasksCollection.doc(id).delete().then((value) {
//                 Utils().toastMessage('Task Deleted');
//                 Navigator.pop(context);
//               }).catchError((error) {
//                 Utils().toastMessage(error.toString());
//               });
//             },
//             child: const Text(
//               'Delete',
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euro_wings/views/new_screens/AdminPanel/add_item_screen.dart';
import 'package:euro_wings/views/new_screens/AdminPanel/items_details_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ItemsScreen extends StatelessWidget {
  ItemsScreen({Key? key}) : super(key: key) {
    _stream = _reference.snapshots();
  }

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('foodItems');

  late Stream<QuerySnapshot> _stream;
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Items'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //Check error
          if (snapshot.hasError) {
            return Center(child: Text('Some error occurred ${snapshot.error}'));
          }

          //Check if data arrived
          if (snapshot.hasData) {
            //get the data
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

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
                              '${thisItem['image']}, ',
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
        },
      ), //Display a list // Add a FutureBuilder
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

// void showCustomBottomSheet(
//     BuildContext context, String title, price, desc, image) {
//   showModalBottomSheet(
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//         top: Radius.circular(20.0),
//       ),
//     ),
//     builder: (BuildContext context) {
//       return Container(
//         padding: const EdgeInsets.all(20.0),
//         height: double.infinity,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const Divider(
//               thickness: 5.5,
//               indent: 130,
//               endIndent: 130,
//               color: Colors.black,
//             ),
//             const Divider(
//               thickness: 2.0,
//               color: Colors.teal,
//             ),
//             Container(
//               height: 40,
//               child: SingleChildScrollView(
//                 child: Text(
//                   title,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//               ),
//             ),
//             Container(
//               height: 40,
//               child: SingleChildScrollView(
//                 child: Text(
//                   price,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//               ),
//             ),
//             Container(
//               height: 40,
//               child: SingleChildScrollView(
//                 child: Text(
//                   desc,
//                   style: const TextStyle(fontSize: 20),
//                 ),
//               ),
//             ),
//             Container(
//               height: 40,
//               width: 40,
//               child: SingleChildScrollView(
//                 child: Image.network(
//                   image,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
