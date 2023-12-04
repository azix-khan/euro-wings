import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euro_wings/views/new_screens/widgets/utils/utils.dart';
import 'package:flutter/material.dart';

class DeleteItemDialog {
  final BuildContext context;
  final DocumentReference? reference;

  DeleteItemDialog({
    required this.context,
    this.reference,
  });

  Widget build() {
    return AlertDialog(
      title: const Text(
        'Delete',
        style: TextStyle(color: Colors.red),
      ),
      content: const Text('Do you really want to delete this item?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _deleteTask();
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  void _deleteTask() {
    if (reference != null) {
      reference!.delete().then((value) {
        Utils().toastMessage('Item Deleted');
        Navigator.pop(context);
        Navigator.pop(context);
      }).catchError((error) {
        Utils().toastMessage(error.toString());
      });
    } else {
      Utils().toastMessage('Invalid reference');
    }
  }
}
