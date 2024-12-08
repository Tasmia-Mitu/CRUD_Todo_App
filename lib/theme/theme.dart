// import 'package:flutter/material.dart';

// ThemeData lightMode = ThemeData(
//   brightness: Brightness.light,
//   colorScheme: ColorScheme.light(
//     primary: Colors.grey.shade300, 
//     onPrimary: Colors.grey.shade200, 
//     secondary: Colors.grey.shade400,
//     inversePrimary: Colors.grey.shade800,
//   )
// );

// ThemeData darkMode = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: ColorScheme.dark(
//     primary: const Color.fromARGB(255, 24, 24, 24),
//     onPrimary: const Color.fromARGB(255, 34, 34, 34),
//     secondary: const Color.fromARGB(255, 49, 49, 49),
//     inversePrimary: Colors.grey.shade300,
//   )
// );



import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: Colors.grey.shade300,
    onPrimary: Colors.black,
    secondary: Colors.grey.shade400,
    inversePrimary: Colors.white,
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.black,
    ),
    bodyMedium: TextStyle( 
      color: Colors.grey.shade800,
    ),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: const Color.fromARGB(255, 24, 24, 24),
    onPrimary: Colors.white,
    secondary: const Color.fromARGB(255, 49, 49, 49),
    inversePrimary: Colors.grey.shade300,
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white,
    ),
    bodyMedium: TextStyle( 
      color: Colors.grey.shade400,
    ),
  ),
);
