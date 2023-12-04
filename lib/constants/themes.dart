import 'package:euro_wings/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color primary = Color(0xffFE8800);

ThemeData personaliteTheme = ThemeData.light().copyWith(
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    unselectedItemColor: Colors.blueGrey,
    selectedItemColor: primary,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedLabelStyle: TextStyle(fontSize: 13),
    unselectedLabelStyle: TextStyle(fontSize: 13),
    type: BottomNavigationBarType.fixed,
  ),
  scaffoldBackgroundColor: Colors.grey.shade100,
  // scaffoldBackgroundColor: Color(0xffC4EAFF),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    titleTextStyle: TextStyle(
        color: orangeColor, fontSize: 20, fontWeight: FontWeight.w500),
    centerTitle: true,
    elevation: 0,
    iconTheme: const IconThemeData(color: primary),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
);
