import 'package:flutter/material.dart';

class AppColors {
  static const bgPrimary = Color(0xFF12121E);
  static const bgCard = Color(0xFF1E1E2E);
  static const bgCardLight = Color(0xFF252538);
  static const bgCardMid = Color(0xFF1A1A2A);

  static const accentOrange = Color(0xFFFFA040);
  static const accentOrangeLight = Color(0xFFFFB865);
  static const accentOrangeDark = Color(0xFFE08830);

  static const accentGreen = Color(0xFF4CAF82);
  static const accentGreenLight = Color(0xFF5DD99A);

  static const accentRed = Color(0xFFE05C5C);
  static const accentBlue = Color(0xFF5B8DEF);
  static const accentPurple = Color(0xFF9B7FE8);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0C8);
  static const textMuted = Color(0xFF6A6A88);
  static const textHint = Color(0xFF4A4A60);

  static const divider = Color(0xFF2A2A3E);
  static const cardBorder = Color(0xFF2E2E42);

  static const scoreRingBg = Color(0xFF2A2A3E);
  static const scoreRingFg = accentOrange;
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
