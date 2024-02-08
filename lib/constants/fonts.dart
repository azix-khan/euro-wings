import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final popins = GoogleFonts.poppins();
//Padding + Margin
const kPaddingMargin = EdgeInsets.all(20);

TextTheme textTheme = TextTheme(
  displayLarge:
      GoogleFonts.philosopher(fontSize: 23.sp, fontWeight: FontWeight.w700),
  displayMedium:
      GoogleFonts.philosopher(fontSize: 22.sp, fontWeight: FontWeight.w700),
  headlineLarge: GoogleFonts.poppins(
      fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 0.25),
  titleLarge: GoogleFonts.poppins(
      fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
);

ButtonStyle btnStyle(Color txtColor, Color bgColor) {
  return ButtonStyle(
      foregroundColor: MaterialStateProperty.all(txtColor),
      backgroundColor: MaterialStateProperty.all(bgColor));
}
