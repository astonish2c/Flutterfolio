import 'package:flutter/material.dart';

ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black12,
  fontFamily: 'Montserrat',
  backgroundColor: Colors.white.withOpacity(0.1),
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black12,
    elevation: 12,
    type: BottomNavigationBarType.fixed,
    selectedIconTheme: selectedIconThemeData,
    unselectedIconTheme: darkUnselectedIconThemeData,
    selectedItemColor: Colors.blue[900],
    unselectedItemColor: Colors.white70,
    selectedLabelStyle: const TextStyle(
      fontSize: 12,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 10,
    ),
    showUnselectedLabels: true,
  ),
  primaryIconTheme: darkIconThemeData,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.blue[900],
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 12,
      ),
      visualDensity: VisualDensity.standard,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      minimumSize: Size.zero,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white54,
    ),
    bodyLarge: TextStyle(
      color: Colors.white54,
      fontSize: 28,
    ),
    bodySmall: TextStyle(
      color: Colors.white54,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: Colors.white70,
      fontSize: 38,
    ),
  ),
);

ThemeData lightThemeData = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xffeff2f5),
  fontFamily: 'Montserrat',
  backgroundColor: Colors.blue[900]!.withOpacity(0.1),
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xffeff2f5),
    elevation: 12,
    type: BottomNavigationBarType.fixed,
    selectedIconTheme: selectedIconThemeData,
    unselectedIconTheme: lightUnselectedIconThemeData,
    selectedItemColor: Colors.blue[900],
    unselectedItemColor: Colors.black45,
    selectedLabelStyle: const TextStyle(
      fontSize: 12,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 10,
    ),
    showUnselectedLabels: true,
  ),
  primaryIconTheme: lightIconThemeData,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.blue[900],
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 12,
      ),
      visualDensity: VisualDensity.standard,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      minimumSize: Size.zero,
    ),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.black54,
    ),
    bodyLarge: TextStyle(
      color: Colors.black54,
      fontSize: 28,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      color: Colors.black87,
      fontSize: 38,
    ),
  ),
);

IconThemeData lightIconThemeData = const IconThemeData(
  color: Colors.black,
);
IconThemeData darkIconThemeData = const IconThemeData(
  color: Colors.white54,
);
IconThemeData selectedIconThemeData = const IconThemeData(
  color: Color(0xff3459e7),
);
IconThemeData lightUnselectedIconThemeData = const IconThemeData(
  color: Colors.black38,
);
IconThemeData darkUnselectedIconThemeData = const IconThemeData(
  color: Colors.white54,
);
