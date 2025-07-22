import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2196F3),
        primary: const Color(0xFF2196F3),
        secondary: const Color(0xFF64B5F6),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get dark {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2196F3),
        primary: const Color(0xFF2196F3),
        secondary: const Color(0xFF64B5F6),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
} 