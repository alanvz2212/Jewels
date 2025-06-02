import 'package:flutter/material.dart';

class AppTheme {
  static const mainColor = Color.fromARGB(255, 3, 37, 32);

  static ThemeData lightTheme = ThemeData(
    primaryColor: mainColor,
    colorScheme: ColorScheme.light(
      primary: mainColor,
      secondary: mainColor.withValues(),
      surface: Colors.white,
      // surface: Colors.grey[50]!,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
      backgroundColor: mainColor,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
    ),
    // cardTheme: CardTheme(
    //   elevation: 2,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: mainColor,
    colorScheme: ColorScheme.dark(
      primary: mainColor,
      // ignore: deprecated_member_use
      secondary: mainColor.withOpacity(0.8),
      surface: Color(0xFF1E1E1E),
      // background: Color(0xFF121212),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  );
}
