import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    headline1: GoogleFonts.rubik(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontSize: 35,
    ),
    headline2: GoogleFonts.rubik(
      color: Colors.black,
      fontWeight: FontWeight.w800,
      fontSize: 22,
    ),
    headline3: GoogleFonts.rubik(
      fontWeight: FontWeight.w700,
      fontSize: 25,
      color: Colors.black,
    ),
    headline5: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
    headline6: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    bodyText1: TextStyle(
      color: Colors.black.withOpacity(0.5),
      fontSize: 13,
    ),
    subtitle1: GoogleFonts.rubik(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    subtitle2: GoogleFonts.rubik(
      color: Colors.black.withOpacity(0.5),
      fontSize: 15,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromRGBO(240, 240, 240, 1),
  ),
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: Colors.black.withOpacity(0.2),
    labelColor: Colors.black,
  ),
  cardColor: Color.fromRGBO(31, 78, 130, 1),
  hintColor: Colors.black,
  splashColor: Color.fromRGBO(0, 0, 0, 0.1),
  highlightColor: Color.fromRGBO(0, 0, 0, 0.1),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color.fromRGBO(106, 165, 228, 1),
    selectedIconTheme: IconThemeData(
      color: Color.fromRGBO(0, 0, 0, 1),
    ),
    unselectedIconTheme: IconThemeData(
      color: Color.fromRGBO(0, 0, 0, 0.2),
    ),
    selectedLabelStyle: TextStyle(
      color: Color.fromRGBO(0, 0, 0, 1),
      fontWeight: FontWeight.w800,
    ),
    unselectedLabelStyle: TextStyle(
      color: Color.fromRGBO(0, 0, 0, 1),
      fontWeight: FontWeight.w800,
    ),
    unselectedItemColor: Color.fromRGBO(0, 0, 0, 1),
    selectedItemColor: Color.fromRGBO(0, 0, 0, 1),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  backgroundColor: Color.fromRGBO(14, 15, 21, 1),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Color.fromRGBO(14, 15, 21, 1),
  ),
  textTheme: TextTheme(
    headline1: GoogleFonts.rubik(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 28,
    ),
    headline2: GoogleFonts.rubik(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 22,
    ),
    headline3: GoogleFonts.rubik(
      fontWeight: FontWeight.w700,
      fontSize: 25,
      color: Colors.white,
    ),
    headline5: TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
    headline6: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    bodyText1: TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontSize: 13,
    ),
    subtitle1: GoogleFonts.rubik(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    subtitle2: GoogleFonts.rubik(
      color: Colors.white.withOpacity(0.5),
      fontSize: 15,
    ),
  ),
  tabBarTheme: TabBarTheme(
    unselectedLabelColor: Colors.white.withOpacity(0.2),
    labelColor: Colors.white,
  ),
  hintColor: Colors.white,
  cardColor: Color.fromRGBO(31, 78, 130, 1),
  splashColor: Color.fromRGBO(0, 0, 0, 0.1),
  highlightColor: Color.fromRGBO(0, 0, 0, 0.1),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color.fromRGBO(31, 78, 130, 1),
    selectedIconTheme: IconThemeData(
      color: Color.fromRGBO(0, 0, 0, 1),
    ),
    unselectedIconTheme: IconThemeData(
      color: Color.fromRGBO(0, 0, 0, 0.2),
    ),
    selectedLabelStyle: TextStyle(
      color: Color.fromRGBO(0, 0, 0, 1),
      fontWeight: FontWeight.w800,
    ),
    unselectedLabelStyle: TextStyle(
      color: Color.fromRGBO(0, 0, 0, 1),
      fontWeight: FontWeight.w800,
    ),
    unselectedItemColor: Color.fromRGBO(0, 0, 0, 1),
    selectedItemColor: Color.fromRGBO(0, 0, 0, 1),
  ),
);
