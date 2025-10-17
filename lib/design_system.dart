import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =============================================================================
// COMPREHENSIVE DESIGN SYSTEM
// A complete design system for the Forward Nation App
// =============================================================================

// -----------------------------------------------------------------------------
// 1. COLOR SYSTEM
// Semantic color tokens for consistent theming
// -----------------------------------------------------------------------------
class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFFFA4A04);
  static const Color primaryLight = Color(0xFFFF7F50);
  static const Color primaryDark = Color(0xFFB8371A);

  // Surface & Background Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFF8F9FA);
  static const Color surfaceContainerLow = Color(0xFFF1F3F4);
  static const Color surfaceContainerHigh = Color(0xFFE8EAED);
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF9F9FA);

  // Text Colors
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454F);
  static const Color primaryText = Color(0xFF262626);
  static const Color secondaryText = Color(0xFF6F6F6F);
  static const Color tertiaryText = Color(0xFFAAAAAA);
  static const Color disabledText = Color(0xFFBDBDBD);

  // Outline & Border Colors
  static const Color outline = Color(0xFFEBEBEB);
  static const Color outlineVariant = Color(0xFFEBEBEB);
  static const Color divider = Color(0xFFE8EAED);
  static const Color border = Color(0xFFDDE1E6);
  static const Color borderFocus = Color(0xFFE94E1B);

  // Semantic Colors
  static const Color success = Color(0xFF34A853);
  static const Color warning = Color(0xFFFBBC04);
  static const Color error = Color(0xFFEA4335);
  static const Color info = Color(0xFF4285F4);

  // Shadow & Elevation Colors
  static const Color shadow = Color(0x0A000000);
  static const Color shadowMedium = Color(0x14000000);
  static const Color shadowHigh = Color(0x1F000000);

  // Interactive States
  static const Color hover = Color(0x08000000);
  static const Color pressed = Color(0x12000000);
  static const Color focus = Color(0x1F000000);
  static const Color selected = Color(0xFFE94E1B);
  static const Color disabled = Color(0x38000000);
}

// -----------------------------------------------------------------------------
// 2. SPACING SYSTEM (8pt Grid)
// Consistent spacing tokens based on 8-point grid system
// -----------------------------------------------------------------------------
class AppSpacing {
  // Base spacing units
  static const double xs = 2.0; // 2px
  static const double sm = 4.0; // 4px
  static const double md = 8.0; // 8px
  static const double lg = 12.0; // 12px
  static const double xl = 16.0; // 16px
  static const double xxl = 20.0; // 20px
  static const double xxxl = 24.0; // 24px

  // Semantic spacing
  static const double element = 8.0; // Between related elements
  static const double component = 16.0; // Between components
  static const double section = 24.0; // Between sections
  static const double page = 40.0; // Page margins

  // Specific use cases
  static const double cardPadding = 16.0;
  static const double screenPadding = 20.0;
  static const double buttonPadding = 12.0;
  static const double iconSpacing = 8.0;
}

// -----------------------------------------------------------------------------
// 3. TYPOGRAPHY SYSTEM
// Comprehensive text styles with semantic naming
// -----------------------------------------------------------------------------
class AppTypography {
  static const String fontFamily = 'Instrumental Sans';

  // Display Styles (Large headlines)
  static TextStyle displayLarge = GoogleFonts.instrumentSans(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
    color: AppColors.onSurface,
  );

  static TextStyle displayMedium = GoogleFonts.instrumentSans(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
    color: AppColors.onSurface,
  );

  static TextStyle displaySmall = GoogleFonts.instrumentSans(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
    color: AppColors.onSurface,
  );

  // Headline Styles
  static TextStyle headlineLarge = GoogleFonts.instrumentSans(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
    color: AppColors.onSurface,
  );

  static TextStyle headlineMedium = GoogleFonts.instrumentSans(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
    color: AppColors.onSurface,
  );

  static TextStyle headlineSmall = GoogleFonts.instrumentSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
    color: AppColors.onSurface,
  );

  // Title Styles
  static TextStyle titleLarge = GoogleFonts.instrumentSans(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
    color: AppColors.onSurface,
  );

  static TextStyle titleMedium = GoogleFonts.instrumentSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.33,
    color: AppColors.onSurface,
  );

  static TextStyle titleSmall = GoogleFonts.instrumentSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.25,
    color: AppColors.onSurface,
  );

  // Label Styles
  static TextStyle labelLarge = GoogleFonts.instrumentSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
    color: AppColors.onSurface,
  );

  static TextStyle labelMedium = GoogleFonts.instrumentSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
    color: AppColors.onSurface,
  );

  static TextStyle labelSmall = GoogleFonts.instrumentSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
    color: AppColors.onSurface,
  );

  // Body Styles
  static TextStyle bodyLarge = GoogleFonts.instrumentSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    height: 1.5,
    color: AppColors.onSurface,
  );

  static TextStyle bodyMedium = GoogleFonts.instrumentSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
    color: AppColors.onSurface,
  );

  static TextStyle bodySmall = GoogleFonts.instrumentSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
    color: AppColors.onSurface,
  );

  // Semantic Text Styles (App-specific)
  static TextStyle sectionTitle = titleMedium.copyWith(
    color: AppColors.primaryText,
  );

  static TextStyle cardTitle = titleSmall.copyWith(
    color: AppColors.primaryText,
    height: 1.2,
  );

  static TextStyle cardSubtitle = bodySmall.copyWith(
    color: AppColors.secondaryText,
    fontSize: 13,
  );

  static TextStyle cardMetadata = bodySmall.copyWith(
    color: AppColors.tertiaryText,
  );

  static TextStyle greeting = bodyMedium.copyWith(
    color: AppColors.secondaryText,
  );

  static TextStyle userName = bodyLarge.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static TextStyle actionButton = labelLarge.copyWith(
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    fontSize: 14,
  );

  static TextStyle quickActionLabel = labelSmall.copyWith(
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static TextStyle activityTitle = labelMedium.copyWith(
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: AppColors.primaryText,
    height: 1.3,
  );
}

// -----------------------------------------------------------------------------
// 4. BORDER RADIUS SYSTEM
// Consistent border radius tokens
// -----------------------------------------------------------------------------
class AppRadius {
  static const double none = 0.0;
  static const double xs = 2.0;
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 14.0;
  static const double xxl = 20.0;
  static const double xxxl = 24.0;
  static const double full = 9999.0;

  // Semantic radius
  static const double button = 8.0;
  static const double card = 12.0;
  static const double container = 16.0;
  static const double avatar = 8.0;
}

// -----------------------------------------------------------------------------
// 5. ELEVATION & SHADOW SYSTEM
// Consistent elevation tokens with corresponding shadows
// -----------------------------------------------------------------------------
class AppElevation {
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> low = [
    BoxShadow(color: AppColors.shadow, blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: AppColors.shadowMedium,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> high = [
    BoxShadow(color: AppColors.shadowHigh, blurRadius: 8, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2)),
  ];
}

// -----------------------------------------------------------------------------
// 6. COMPONENT DECORATIONS
// Pre-built decorations for common UI components
// -----------------------------------------------------------------------------
class AppDecorations {
  // Card decorations
  static BoxDecoration card = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppRadius.card),
    border: Border.all(color: AppColors.outline, width: 1),
    boxShadow: AppElevation.card,
  );

  static BoxDecoration cardElevated = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppRadius.card),
    boxShadow: AppElevation.high,
  );

  // Container decorations
  static BoxDecoration container = BoxDecoration(
    color: AppColors.surfaceContainer,
    borderRadius: BorderRadius.circular(AppRadius.container),
    border: Border.all(color: AppColors.outlineVariant, width: 1),
  );

  // Button decorations
  static BoxDecoration primaryButton = BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(AppRadius.button),
  );

  static BoxDecoration secondaryButton = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppRadius.button),
    border: Border.all(color: AppColors.outline, width: 1),
  );

  // Input decorations
  static BoxDecoration input = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppRadius.md),
    border: Border.all(color: AppColors.outline, width: 1),
  );

  static BoxDecoration inputFocused = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppRadius.md),
    border: Border.all(color: AppColors.borderFocus, width: 2),
  );
}

// -----------------------------------------------------------------------------
// 7. ANIMATION DURATIONS
// Consistent animation timing
// -----------------------------------------------------------------------------
class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  // Specific use cases
  static const Duration button = Duration(milliseconds: 150);
  static const Duration page = Duration(milliseconds: 300);
  static const Duration modal = Duration(milliseconds: 400);
}

// -----------------------------------------------------------------------------
// 8. BREAKPOINTS & RESPONSIVE DESIGN
// Screen size breakpoints for responsive design
// -----------------------------------------------------------------------------
class AppBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double largeDesktop = 1440;
}

// -----------------------------------------------------------------------------
// 9. ICON SIZES
// Consistent icon sizing
// -----------------------------------------------------------------------------
class AppIconSizes {
  static const double xs = 12.0;
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
