import 'package:flutter/material.dart';

class AppColors {
  static const bgPrimary = Color(0xFF050814);
  static const bgCard = Color(0xFF111827);
  static const bgCardLight = Color(0xFF1F2937);
  static const bgCardMid = Color(0xFF0F172A);

  static const accentOrange = Color(0xFFFFB03A);
  static const accentOrangeLight = Color(0xFFFFCA7C);
  static const accentOrangeDark = Color(0xFFE28B10);

  static const accentGreen = Color(0xFF10B981);
  static const accentGreenLight = Color(0xFF34D399);

  static const accentRed = Color(0xFFEF4444);
  static const accentBlue = Color(0xFF38BDF8);
  static const accentPurple = Color(0xFF818CF8);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9CA3AF);
  static const textMuted = Color(0xFF6B7280);
  static const textHint = Color(0xFF4B5563);

  static const divider = Color(0xFF1F2937);
  static const cardBorder = Color(0xFF1F2937);

  static const scoreRingBg = Color(0xFF1F2937);
  static const scoreRingFg = Color(0xFFFFB03A);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentOrange,
      surface: AppColors.bgCard,
      background: AppColors.bgPrimary,
    ),
    fontFamily: 'SF Pro Display',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgPrimary,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bgCard,
      selectedItemColor: AppColors.accentOrange,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      unselectedLabelStyle: TextStyle(fontSize: 11),
    ),
  );
}
