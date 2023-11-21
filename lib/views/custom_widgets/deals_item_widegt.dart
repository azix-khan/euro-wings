// deal_item.dart

import 'package:euro_wings/Models/deals_model.dart';
import 'package:euro_wings/views/screens/selected_deal_screen.dart';
import 'package:flutter/material.dart';

class DealItem extends StatelessWidget {
  final Deal deal;

  const DealItem({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectedDealScreen(deal: deal),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 125,
                child: Image.asset(deal.image),
              ),
              const SizedBox(height: 20),
              Text(
                deal.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
