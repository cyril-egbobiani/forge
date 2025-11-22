import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'responsive_helper.dart';

class AppTextStyles {
  // Massive Headlines - Archivo Black, w400 (already bold), -1.5 tracking, UPPERCASE
  static TextStyle get massiveHeadline => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(32),
    fontWeight: FontWeight.w900, // Archivo Black
    letterSpacing: -1.5,
    height: 1.2,
  );

  static TextStyle get h1 => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(28),
    fontWeight: FontWeight.w900, // Archivo Black
    letterSpacing: -1.5,
    height: 1.2,
  );

  // Sub-headers - Archivo, w700, -0.5 tracking, Sentence Case
  static TextStyle get subHeader => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(24),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static TextStyle get h2 => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(22),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static TextStyle get h3 => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(20),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static TextStyle get h4 => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(18),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.3,
  );

  static TextStyle get h5 => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(16),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.4,
  );

  static TextStyle get h6 => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(14),
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.4,
  );

  // Body Text - Archivo, w400, 0.0 tracking, Sentence Case
  static TextStyle get bodyLarge => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(16),
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.5,
  );

  static TextStyle get bodyMedium => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(14),
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(12),
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.5,
  );

  // Buttons/Tabs - Archivo, w600, +1.0 tracking, UPPERCASE
  static TextStyle get buttonLarge => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(16),
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.2,
  );

  static TextStyle get buttonMedium => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(14),
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.2,
  );

  static TextStyle get buttonSmall => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(12),
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.2,
  );

  // Tab Text Style
  static TextStyle get tabText => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(14),
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.2,
  );

  // Caption and Label Styles - Body text styling
  static TextStyle get caption => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(12),
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.3,
  );

  static TextStyle get overline => GoogleFonts.archivo(
    fontSize: ResponsiveHelper.sp(10),
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.6,
  );
}
