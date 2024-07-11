import 'package:flutter/material.dart';

// ThemeData darkMode = ThemeData(
//   brightness: Brightness.dark,
//   colorScheme: ColorScheme.dark(
//       background: Colors.grey.shade900,
//       onBackground: Color.fromARGB(255, 37, 37, 38),
//       primary: Colors.grey.shade800,
//       secondary: Colors.grey.shade700,
//       onSecondary: Colors.blueGrey.shade500,
//       inversePrimary: Colors.grey.shade300, ),
//   textTheme: ThemeData.dark()
//       .textTheme
//       .apply(bodyColor: Colors.grey[300], displayColor: Colors.white),
// );

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.blueGrey.shade900,
    onBackground: const Color.fromARGB(255, 34, 57, 68),
    primary: Colors.blueGrey.shade800,
    secondary: Colors.blueGrey.shade700,
    onSecondary: Colors.blueGrey.shade500,
    onInverseSurface: const Color.fromARGB(255, 210, 108, 53),
    inversePrimary: Colors.blueGrey.shade300,
    error: Colors.redAccent, // Adjust the error color if needed
    // Add more color adjustments as necessary
  ),
  textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.blueGrey.shade100,
        displayColor: Colors.blueGrey.shade200,
        // Adjust other text colors as needed
      ),
);
