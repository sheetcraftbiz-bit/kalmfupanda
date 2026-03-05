import 'package:flutter/material.dart';

class AppColors {
  // Background colors
  static const Color background = Color(0xFF0E0E0E); // Midnight
  static const Color surface = Color(0xFF1A1A1A); // Panda Black

  // Text colors
  static const Color textPrimary = Color(0xFFF0ECE4); // Warm White
  static const Color textSecondary = Color(0xFF888888); // Stone

  // Accent colors
  static const Color accentGold = Color(0xFFC8A96E); // Bamboo Gold
  static const Color accentBlue = Color(0xFF7EB8F7); // Sky Blue
  static const Color accentRed = Color(0xFFE07A7A); // Soft Red
  static const Color accentGreen = Color(0xFF7EC89A); // Sage Green

  // Border
  static const Color border = Color(0xFF2A2A2A);

  // Share card gradients
  static const List<Color> igStoryGradient = [
    Color(0xFF833AB4),
    Color(0xFFfd1d1d),
    Color(0xFFfcb045),
  ];

  static const List<Color> fbStoryGradient = [
    Color(0xFF1877f2),
    Color(0xFF0d47a1),
  ];
}

class AppTextStyles {
  // Display / Quotes
  static const TextStyle quoteDisplay = TextStyle(
    fontFamily: 'Georgia',
    fontStyle: FontStyle.italic,
    fontSize: 22,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle quoteDisplayLarge = TextStyle(
    fontFamily: 'Georgia',
    fontStyle: FontStyle.italic,
    fontSize: 28,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // UI Labels
  static const TextStyle uiLabel = TextStyle(
    fontFamily: 'Courier New',
    fontSize: 10,
    letterSpacing: 2.0,
    color: AppColors.textSecondary,
  );

  static const TextStyle uiLabelAccent = TextStyle(
    fontFamily: 'Courier New',
    fontSize: 12,
    letterSpacing: 1.5,
    fontWeight: FontWeight.w600,
  );

  // Author
  static const TextStyle author = TextStyle(
    fontFamily: 'Courier New',
    fontSize: 12,
    letterSpacing: 1.0,
    color: AppColors.accentGold,
  );

  // Body
  static const TextStyle body = TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  // Button
  static const TextStyle button = TextStyle(
    fontFamily: '.SF Pro Text',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentGold,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        onPrimary: AppColors.background,
      ),
      textTheme: const TextTheme(
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTextStyles.uiLabelAccent,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        modalBackgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGold,
          foregroundColor: AppColors.background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentGold,
          side: const BorderSide(color: AppColors.accentGold, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
    );
  }

  // Accent color cycling
  static const List<Color> accentColors = [
    AppColors.accentGold,
    AppColors.accentBlue,
    AppColors.accentRed,
    AppColors.accentGreen,
  ];

  static Color getAccentColor(int index) {
    return accentColors[index % accentColors.length];
  }
}
