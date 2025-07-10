import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryColor = Color(0xFF1E90FF);
  static final Color scaffoldBackgroundColor = Color(0xFFF7F8FD);
  static final Color cardColor = Colors.white;
  static final Color unselectedTabColor = Color(0xFFADB5BD);
  static final Color activeBottomNavColor = Color(0xFF1EB980);
  static final Color lightGreyChipColor = Color(0xFFE5E7EF);

  static final Color darkScaffoldBackgroundColor = Color(0xFF121212);
  static final Color darkCardColor = Color(0xFF1E1E1E);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      fontFamily: 'Inter',
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 1,
        shadowColor: Colors.black.withAlpha(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: activeBottomNavColor,
        unselectedItemColor: unselectedTabColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkScaffoldBackgroundColor,
      fontFamily: 'Inter',
      cardTheme: CardThemeData(
        color: darkCardColor,
        elevation: 1,
        shadowColor: Colors.white.withAlpha(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: activeBottomNavColor,
        unselectedItemColor: unselectedTabColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showUnselectedLabels: true,
        backgroundColor: darkCardColor,
      ),
    );
  }
}
