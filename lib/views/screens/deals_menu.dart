// deals_screen.dart

import 'package:euro_wings/Models/deals_model.dart';
import 'package:euro_wings/views/custom_widgets/deals_item_widegt.dart';
import 'package:flutter/material.dart';

class DealsScreen extends StatelessWidget {
  final List<Deal> deals = [
    Deal(
      name: 'Deal 1',
      description: 'Description for Deal 1',
      image: 'images/deals/burger.jpeg',
    ),
    Deal(
      name: 'Deal 2',
      description: 'Description for Deal 2',
      image: 'images/deals/pizza.jpeg',
    ),
    Deal(
      name: 'Deal 3',
      description: 'Description for Deal 3',
      image: 'images/deals/pizza.jpeg',
    ),
    // Add more deals as needed
  ];

  DealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deals Menu'),
      ),
      body: ListView.builder(
        itemCount: deals.length,
        itemBuilder: (context, index) {
          return DealItem(deal: deals[index]);
        },
      ),
    );
  }
}
