import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF2563EB);

  static final ColorScheme lightScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
  );

  static final ColorScheme darkScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
  );

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
        scaffoldBackgroundColor: lightScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: lightScheme.primary,
          foregroundColor: lightScheme.onPrimary,
          elevation: 0,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: lightScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
        scaffoldBackgroundColor: darkScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: darkScheme.primary,
          foregroundColor: darkScheme.onPrimary,
          elevation: 0,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      );
}
