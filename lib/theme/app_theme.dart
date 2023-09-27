import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor =  Color(0xFF1E2036);

  static ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: primaryColor,
      appBarTheme: const AppBarTheme(
        color: primaryColor,
        elevation: 0,
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xff353759),
            elevation: 2,
            shadowColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)
              ),
          )
      ),

      //FloatingActionButton

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor, 
          elevation: 5
      ),

      //elevatedButtonTheme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor:  const Color(0xff353759), 
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
             
            elevation: 2
            ),
      )
    );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    appBarTheme: const AppBarTheme(
      color: primaryColor,
      elevation: 0,
    ),
  );
}
