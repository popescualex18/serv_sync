import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static final Color lightSecondaryColor = Color(0xFF17A2B8);
  static final Color lightBackgroundColor = Color(0xFFFAF8FA);
  static final Color lightPrimaryColor = Color(0xFFFAF8FA);
  static final Color lightCardColor = Colors.white;
  static final Color lightTextColor = Color(0xFF212529);

  // Dark Theme Colors
  static final Color darkPrimaryColor = Color(0xFF0D6EFD);
  static final Color darkSecondaryColor = Color(0xFF20C997);
  static final Color darkBackgroundColor = Color(0xFF121212);
  static final Color darkCardColor = Color(0xFF1E1E1E);
  static final Color darkTextColor = Color(0xFFE0E0E0);

  // Common Button Theme
  static final ButtonThemeData buttonTheme = ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    buttonColor: lightPrimaryColor,
    textTheme: ButtonTextTheme.primary,
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    cardColor: lightCardColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: lightTextColor),
      bodyMedium: TextStyle(color: lightTextColor),
    ),
    buttonTheme: buttonTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: lightSecondaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.black54,
      indicator: BoxDecoration(
        color: lightSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    cardColor: darkCardColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: darkTextColor),
      bodyMedium: TextStyle(color: darkTextColor),
    ),
    buttonTheme: buttonTheme.copyWith(buttonColor: darkPrimaryColor),
    appBarTheme: AppBarTheme(
      backgroundColor: darkPrimaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey,
      indicator: BoxDecoration(
        color: darkSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
