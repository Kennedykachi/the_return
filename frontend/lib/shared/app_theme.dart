import 'package:flutter/material.dart';

abstract final class AppColors {
  static const terracotta = Color(0xFFC04A35);
  static const deepIndigo = Color(0xFF1A2A44);
  static const cream = Color(0xFFF5F0E6);
}

ThemeData buildAppTheme() => ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.terracotta,
        primary: AppColors.terracotta,
        secondary: AppColors.deepIndigo,
        surface: AppColors.cream,
      ),
    );
