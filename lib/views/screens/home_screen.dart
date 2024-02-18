import 'package:euro_wings/constants/fonts.dart';
import 'package:euro_wings/views/custom_widgets/customNavigation.dart';
import 'package:euro_wings/views/custom_widgets/more_menu_button.dart';
import 'package:euro_wings/constants/themes.dart';
import 'package:euro_wings/views/screens/auth/login_screen.dart';
import 'package:euro_wings/views/screens/menu_list.dart';
import 'package:euro_wings/views/custom_widgets/slogan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.sizeOf(context).height * 1;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('EURO', style: textTheme.displayLarge),
              Text('W I N G S', style: textTheme.displayMedium),
            ],
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: primary),
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Image(
                  image: AssetImage('images/staff/image0.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 25,
            ),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slogan(Colors.black.withOpacity(0.9),
                'F R E S H - I N D R I E D I E N T S', 'Tasty Thrills'),
            Slogan(Colors.blueGrey.shade900,
                'T R A D I T I O N A L - R E C I P I E', 'Affordable Bills'),
            // Tables Food :
            Flexible(fit: FlexFit.loose, child: MenuList()),
            // Botom secret menu :
            const MoreMenuButton(),
          ],
        ),
        bottomNavigationBar: const CustomNavigatorBar(),
      ),
    );
  }
}
