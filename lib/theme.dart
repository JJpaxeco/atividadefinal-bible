import 'package:flutter/material.dart';

class AppTheme {
  static final Color primaryColor = Color(0xFF1E90FF);
  static final Color scaffoldBackgroundColor = Color(0xFFF7F8FD);
  static final Color cardColor = Colors.white;
  static final Color unselectedTabColor = Color(0xFFADB5BD);
  static final Color activeBottomNavColor = Color(0xFF1EB980);
  static final Color lightGreyChipColor = Color(0xFFE5E7EF);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      fontFamily: 'Inter', // Usando Inter como uma alternativa comum
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 1,
        shadowColor: Colors.black.withAlpha(20), // 8% opacity
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
}
