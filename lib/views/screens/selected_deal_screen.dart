// selected_deal_screen.dart

import 'package:euro_wings/Models/deals_model.dart';
import 'package:flutter/material.dart';
// import 'deal_model.dart'; // Import the Deal model

class SelectedDealScreen extends StatelessWidget {
  final Deal deal;

  SelectedDealScreen({required this.deal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Deal'),
      ),
      body: Column(
        children: [
          Image.asset(deal.image),
          Text('Name: ${deal.name}'),
          Text('Description: ${deal.description}'),
          // Add more details as needed
        ],
      ),
    );
  }
}
