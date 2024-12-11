import 'package:flutter/material.dart';

// Define a custom theme class
class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      dropdownMenuTheme: DropdownMenuThemeData(inputDecorationTheme: InputDecorationTheme(alignLabelWithHint: true)),
        elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white), // White background
    foregroundColor: MaterialStateProperty.all(Colors.black), // Black text color for contrast
    elevation: MaterialStateProperty.all(0.1), // Optional: add some elevation for a shadow effect
    ),),
      primaryColor: Colors.teal,  // Main color for the app
      primaryColorLight: Colors.green,  // Accent color for buttons, icons, etc.
      scaffoldBackgroundColor: Colors.grey[50], // Background color for scaffold
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.normal, // Text color in buttons
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
