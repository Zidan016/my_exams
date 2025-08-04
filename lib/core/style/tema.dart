import 'package:flutter/material.dart';

class TemaClass {
  static ThemeData tema() {
    return ThemeData(
      primaryColor: const Color(0xFF3F51B5),
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF3F51B5),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white
        )
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          backgroundColor: const Color(0xFF3F51B5),
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.normal,
            
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF3F51B5),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF3F51B5),
          side: const BorderSide(color: Color(0xFF3F51B5)),
        ),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins'),
        headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins'),
        headlineSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins'),
        bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Poppins'),
        bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Poppins'),
        bodySmall: TextStyle(fontSize: 12.0, color: Colors.white, fontFamily: 'Poppins'),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: Color(0xFF3F51B5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3F51B5), width: 2.0),
        ),
        hintStyle: TextStyle(color: Colors.grey), 
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF3F51B5),
        foregroundColor: Colors.white,
        elevation: 6, 
      ),

      cardTheme: const CardThemeData(
        color: Color.fromARGB(255, 237, 237, 237)
      )

    );
  }
}
