import 'package:flutter/material.dart';

//Universal Theme
//Passed to the MaterialApp Widget in main.dart
ThemeData fireappTheme() {
  return ThemeData(
    //Auto-Theme - Automatically creates many theme elements just from this base colour
    primarySwatch: Colors.red, //Needs to use a MaterialColor not just color
    //- see: https://material.io/design/style/color.html#color-color-palette

    //Light & Dark Theme - Needs work
    brightness: Brightness.light, //- overall theme brightness

    /* Main Background Colour */
    canvasColor: Color.fromARGB(255, 241, 240, 240),

    /* Core App Components */
    //appBarTheme:
    //navigationBarTheme:
    //    const NavigationBarThemeData(backgroundColor: Colors.red)
    // Color.fromARGB(255, 235, 235, 235) - This color is almost exactly the default nav bar...

    /* Buttons & Forms */
    //buttonTheme:
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.red[900]),
    //checkboxTheme:

    /* Other Components */
    cardColor: Colors.white,
  );
}

/* --- CONSTANTS --- */ // (Note: Not part of core theme data)
Color? leadingRepeatIndicatorColor =
    Colors.red[100];  //Color.fromARGB(113, 231, 145, 139);
