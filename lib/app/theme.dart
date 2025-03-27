import 'package:flutter/material.dart';
import 'package:srms/config/constants.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(AppConstants.primaryColor),
    colorScheme: ColorScheme.light(
      primary: Color(AppConstants.primaryColor),
      secondary: Color(AppConstants.secondaryColor),
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(AppConstants.primaryColor),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(AppConstants.primaryColor),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(AppConstants.accentColor),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Color(AppConstants.primaryColor),
    colorScheme: ColorScheme.dark(
      primary: Color(AppConstants.primaryColor),
      secondary: Color(AppConstants.secondaryColor),
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Color(AppConstants.primaryColor),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey[850],
      selectedItemColor: Color(AppConstants.secondaryColor),
      unselectedItemColor: Colors.grey[500],
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(AppConstants.accentColor),
    ),
  );
}