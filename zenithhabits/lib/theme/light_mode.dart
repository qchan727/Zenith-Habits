import 'package:flutter/material.dart';

// ThemeData lightMode = ThemeData(
//   brightness: Brightness.light,
//   colorScheme: ColorScheme.light(
//       background: Colors.grey.shade300,
//       primary: Colors.grey.shade200,
//       secondary: Colors.grey.shade400,
//       inversePrimary: Colors.grey.shade800),
//   textTheme: ThemeData.light()
//       .textTheme
//       .apply(bodyColor: Colors.grey[800], displayColor: Colors.black),
// );

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.blue.shade50,
    onBackground: const Color.fromARGB(255, 179, 219, 252),
    primary: Colors.blue.shade100,
    secondary: const Color.fromARGB(255, 163, 212, 251),
    onSecondary: const Color.fromARGB(255, 117, 188, 245),
    onInverseSurface: const Color.fromARGB(255, 254, 178, 143),
    error: Colors.red, // Adjust the error color if needed
    // Add more color adjustments as necessary
  ),
  textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.blueGrey.shade800,
        displayColor: Colors.blueGrey.shade900,
        // Adjust other text colors as needed
      ),
);
