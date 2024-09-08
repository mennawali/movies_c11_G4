import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app_c11/AppColors.dart';

class MyThemeData {
  static ThemeData appTheme = ThemeData(
    appBarTheme: AppBarTheme(
      color: Appcolors.primary,
      titleTextStyle: TextStyle(
          color: Appcolors.whiteColor,
          fontSize: 22,
          fontWeight: FontWeight.w400),
      iconTheme: IconThemeData(color: Appcolors.whiteColor, size: 25),
    ),
    textTheme: TextTheme(
      bodySmall: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Appcolors.whiteColor),
      bodyMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Appcolors.whiteColor),
      bodyLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Appcolors.whiteColor),
      titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Appcolors.whiteColor),
    ),
  );
}