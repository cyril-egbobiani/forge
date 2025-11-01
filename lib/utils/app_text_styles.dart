import 'package:flutter/material.dart';
import 'responsive_helper.dart';

class AppTextStyles {
  // Heading Styles - Adjust based on your Figma design
  static TextStyle get h1 => TextStyle(
    fontSize: ResponsiveHelper.sp(32),
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle get h2 => TextStyle(
    fontSize: ResponsiveHelper.sp(28),
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static TextStyle get h3 => TextStyle(
    fontSize: ResponsiveHelper.sp(24),
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get h4 => TextStyle(
    fontSize: ResponsiveHelper.sp(20),
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get h5 => TextStyle(
    fontSize: ResponsiveHelper.sp(18),
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle get h6 => TextStyle(
    fontSize: ResponsiveHelper.sp(16),
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body Text Styles
  static TextStyle get bodyLarge => TextStyle(
    fontSize: ResponsiveHelper.sp(16),
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontSize: ResponsiveHelper.sp(14),
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: ResponsiveHelper.sp(12),
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // Button Text Styles
  static TextStyle get buttonLarge => TextStyle(
    fontSize: ResponsiveHelper.sp(16),
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle get buttonMedium => TextStyle(
    fontSize: ResponsiveHelper.sp(14),
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle get buttonSmall => TextStyle(
    fontSize: ResponsiveHelper.sp(12),
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Caption and Label Styles
  static TextStyle get caption => TextStyle(
    fontSize: ResponsiveHelper.sp(12),
    fontWeight: FontWeight.normal,
    height: 1.3,
  );

  static TextStyle get overline => TextStyle(
    fontSize: ResponsiveHelper.sp(10),
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 1.5,
  );
}
