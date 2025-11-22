import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Replace with your Figma design colors
  static const Color primary = Color(0xFFD19E00);
  static const Color secondary = Color(0xFF5856D6);

  // Background Colors - Only main screen backgrounds are black
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1C1C1E);
  static const Color cardBackground = Color(0xFF0A0A0A);
  static const Color modalBackground = Color(0xFF1C1C1E);
  static const Color bottomSheetBackground = Color(0xFF1C1C1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFFC7C7CC);

  // Accent Colors
  static const Color accent = Color(0xFFFF9500);
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey100 = Color(0xFFF2F2F7);
  static const Color grey200 = Color(0xFFE5E5EA);
  static const Color grey300 = Color(0xFFD1D1D6);
  static const Color grey400 = Color(0xFFC7C7CC);
  static const Color grey500 = Color(0xFFAEAEB2);
  static const Color grey600 = Color(0xFF8E8E93);
  static const Color grey700 = Color(0xFF636366);
  static const Color grey800 = Color(0xFF48484A);
  static const Color grey900 = Color(0xFF1C1C1E);

  // Dark Colors - Pure Black Theme
  static const Color dark50 = Color(0xFFF8F8F8);
  static const Color dark100 = Color(0xFFF4F4F4);
  static const Color dark200 = Color(0xFFEEEEEE);
  static const Color dark300 = Color(0xFFE1E1E1);
  static const Color dark400 = Color(0xFFC7C7C7);
  static const Color dark500 = Color(0xFF3A3A3A);
  static const Color dark600 = Color(0xFF2E2E2E);
  static const Color dark700 = Color(0xFF242424);
  static const Color dark800 = Color(0xFF1A1A1A);
  static const Color dark900 = Color(0xFF151515);
  static const Color dark950 = Color(0xFF0A0A0A);

  // Text colors
  static const Color high = Color(0xFF0A0C11);
  static const Color medium = Color(0xFF5B616D);
  static const Color low = Color(0xFF8C929C);
  static const Color base = Color(0xFFC3C6CC);

  // Luxury Gold Colors for Industrial Design
  static const Color lightGold = Color(
    0xFFFFD700,
  ); // Brighter Gold for highlights

  // Luxury Gradients - Required for the 'Industrial Luxury' look
  static const LinearGradient goldGradient = LinearGradient(
    colors: [
      AppColors.lightGold, // The bright highlight
      AppColors.primary, // The deep primary gold
      AppColors.dark900, // A hint of the dark background for depth
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Alternative gradients for different use cases
  static const LinearGradient pureGoldGradient = LinearGradient(
    colors: [
      AppColors.lightGold, // Bright gold
      AppColors.primary, // Primary gold
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient subtleGoldGradient = LinearGradient(
    colors: [
      AppColors.primary, // Primary gold
      AppColors.accent, // Accent orange-gold
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Utility method to ensure pure black backgrounds
  static Color get pureBlackBackground => Colors.black;
  static Color get containerBackground => Colors.black;
  // static Color get cardColor => Colors.black;
  // static Color get modalBackground => Colors.black;
  static Color get overlayBackground => Colors.black;
}

// Helper extension for hex colors
extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
