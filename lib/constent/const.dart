import 'package:flutter/material.dart';
class Constants{

  static String appName = "Your App";

  static Color lightPrimary = const Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.red;
  static Color darkAccent = Colors.red.shade400;
  static Color lightBG = const Color(0xfffcfcff);
  static Color darkBG = Colors.black;
  static Color ratingBG = Colors.yellow.shade700;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
   primaryColorLight: lightBG,
    primaryColor: lightPrimary,
    // ignore: deprecated_member_use
    colorScheme: const  ColorScheme.light(),
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
     titleTextStyle: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      
    ), textSelectionTheme: TextSelectionThemeData(cursorColor: lightAccent),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
   primaryColorDark: darkBG,
    primaryColor: darkPrimary,
   
    colorScheme:const ColorScheme.dark(),
    scaffoldBackgroundColor: darkBG,
    appBarTheme: AppBarTheme(
      titleTextStyle: 
        TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),

     textSelectionTheme: TextSelectionThemeData(cursorColor: darkAccent),
  );


}