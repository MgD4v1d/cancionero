import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const colorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.deepPurple,
  Colors.deepPurpleAccent,
  Colors.cyanAccent,
  Colors.orange,
  Colors.deepOrange,
  Colors.deepOrangeAccent,
  Colors.pink,
  Colors.pinkAccent
];



class AppTheme {

  final int selectedColor;
  final bool isDarkmode;

  AppTheme({
    this.selectedColor = 0,
    this.isDarkmode = false
  }) : assert(selectedColor >= 0, 'Selected color must be greater then 0'),
    assert(selectedColor < colorList.length, 'Selected color must be less or equal than ${colorList.length - 1}');

  ThemeData getTheme() => ThemeData(
    brightness: isDarkmode ? Brightness.dark : Brightness.light,
    colorSchemeSeed: colorList[selectedColor],


    //* Texts
    textTheme: TextTheme(
      titleLarge: GoogleFonts.robotoMono()
        .copyWith(fontSize: 23, fontWeight: FontWeight.bold),
      titleMedium: GoogleFonts.robotoMono()
        .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
      titleSmall: GoogleFonts.robotoMono()
        .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
      bodySmall: GoogleFonts.robotoMono()
        .copyWith(fontSize: 12) 
    ),

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

  );

  // copia la instacia de la clase
  AppTheme copyWith ({
    int ? selectedColor,
    bool? isDarkmode
  }) => AppTheme(
    selectedColor: selectedColor ?? this.selectedColor,
    isDarkmode: isDarkmode ?? this.isDarkmode
  );

}