import 'package:euro_wings/constants/themes.dart';
import 'package:euro_wings/views/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: FirebaseOptions(
      //   apiKey:
      //       "BFt0SSBD3tGoTmlaosRvhsy1KNrtpNkk1N2bpV3J5slDf6SEf05ummoCZvUU6-jSZdRFEUUE3Cm_zFPcC_wSiL8",
      //   appId: "1:314590315268:android:b1528f501a691060fb0651",
      //   messagingSenderId: "314590315268",
      //   projectId: "euro-wings",
      // ),
      );
  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: personaliteTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
