import 'package:euro_wings/views/custom_widgets/customNavigation.dart';
import 'package:euro_wings/views/custom_widgets/more_menu_button.dart';
import 'package:euro_wings/constants/themes.dart';
import 'package:euro_wings/views/custom_widgets/menu_list.dart';
import 'package:euro_wings/views/custom_widgets/slogan.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('EURO',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black)),
            Text('W I N G S',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Colors.black)),
          ],
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: primary),
                borderRadius: const BorderRadius.all(Radius.circular(50))),
            child: const Image(
              image: AssetImage('images/staff/image0.png'),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
      body: Column(
        children: [
          Slogan(Colors.black.withOpacity(0.9),
              'F R E S H - I N D R I E D I E N T S', 'Tasty Thrills'),
          Slogan(Colors.blueGrey.shade900,
              'T R A D I T I O N A L - R E C I P I E', 'Affordable Bills'),
          // Tables Food :
          const Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              // Menu List
              child: MenuList(),
            ),
          ),
          // Botom secret menu :
          const MoreMenuButton(),
        ],
      ),
      bottomNavigationBar: const CustomNavigatorBar(),
    );
  }
}
