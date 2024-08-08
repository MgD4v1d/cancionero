import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const colorSeed = Color(0xff424CB8);
const scaffoldBackgroundColor = Color(0xFFF8F7F7); 

class AppTheme {

  ThemeData getTheme() => ThemeData(
    colorSchemeSeed:  colorSeed,


    //* Texts
    textTheme: TextTheme(
      titleLarge: GoogleFonts.robotoMono()
        .copyWith(fontSize: 40, fontWeight: FontWeight.bold),
      titleMedium: GoogleFonts.robotoMono()
        .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
      titleSmall: GoogleFonts.robotoMono()
        .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
      bodySmall: GoogleFonts.robotoMono()
        .copyWith(fontSize: 12) 
    ),

    //* Scaffold Background Color
    scaffoldBackgroundColor: scaffoldBackgroundColor,

    //* Buttons

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          GoogleFonts.robotoMono()
            .copyWith(fontWeight: FontWeight.w700)
        )
      )
    ),


    //* AppBar

    appBarTheme: AppBarTheme(
      color: scaffoldBackgroundColor,
      titleTextStyle: GoogleFonts.robotoMono()
        .copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)
    ),

  );

}