import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static final Color _lightPrimaryColor = Color(0xFF007BFF);
  static final Color _lightSecondaryColor = Color(0xFF17A2B8);
  static final Color _lightBackgroundColor = Color(0xFFF8F9FA);
  static final Color _lightCardColor = Colors.white;
  static final Color _lightTextColor = Color(0xFF212529);

  // Dark Theme Colors
  static final Color _darkPrimaryColor = Color(0xFF0D6EFD);
  static final Color _darkSecondaryColor = Color(0xFF20C997);
  static final Color _darkBackgroundColor = Color(0xFF121212);
  static final Color _darkCardColor = Color(0xFF1E1E1E);
  static final Color _darkTextColor = Color(0xFFE0E0E0);

  // Common Button Theme
  static final ButtonThemeData _buttonTheme = ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    buttonColor: _lightPrimaryColor,
    textTheme: ButtonTextTheme.primary,
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _lightPrimaryColor,
    scaffoldBackgroundColor: _lightBackgroundColor,
    cardColor: _lightCardColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: _lightTextColor),
      bodyMedium: TextStyle(color: _lightTextColor),
    ),
    buttonTheme: _buttonTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightPrimaryColor,
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
        color: _lightSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _darkPrimaryColor,
    scaffoldBackgroundColor: _darkBackgroundColor,
    cardColor: _darkCardColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: _darkTextColor),
      bodyMedium: TextStyle(color: _darkTextColor),
    ),
    buttonTheme: _buttonTheme.copyWith(buttonColor: _darkPrimaryColor),
    appBarTheme: AppBarTheme(
      backgroundColor: _darkPrimaryColor,
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
        color: _darkSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
