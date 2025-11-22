import 'package:flutter/material.dart';
import 'responsive_helper.dart';
import 'app_colors.dart';

class AppSpacing {
  // Base spacing unit - adjust based on your design system
  static const double baseUnit = 8.0;

  // Predefined spacing values using responsive helper
  static double get xs => ResponsiveHelper.w(4); // 4px
  static double get sm => ResponsiveHelper.w(8); // 8px
  static double get md =>
      ResponsiveHelper.w(16); // 16px - Card Gap: Bento Grid spacing
  static double get lg =>
      ResponsiveHelper.w(24); // 24px - Internal Padding: Inside cards
  static double get xl =>
      ResponsiveHelper.w(32); // 32px - Major Padding: Page/scaffold padding
  static double get xxl =>
      ResponsiveHelper.w(48); // 48px - Premium Major Padding
  static double get xxxl => ResponsiveHelper.w(64); // 64px

  // MANDATORY RULES FOR INDUSTRIAL LUXURY:
  // - Major Padding (scaffold/sliver): Use xl (32px) or xxl (48px) for premium feel
  // - Card Gap (Bento Grid spacing): Use md (16px)
  // - Internal Padding (inside cards): Use lg (24px)

  // Industrial Luxury presets
  static double get majorPadding => xl; // 32px - Primary page padding
  static double get premiumPadding => xxl; // 48px - Premium page padding
  static double get cardGap => md; // 16px - Between Bento Grid cards
  static double get cardInternal => lg; // 24px - Inside card padding

  // List Layout Constants (extracted from transaction UI patterns)
  static double get listRowHeight =>
      ResponsiveHelper.h(72); // Standard list row height
  static double get listIconSize =>
      ResponsiveHelper.w(24); // Standard list icon size
  static double get listAvatarSize =>
      ResponsiveHelper.w(48); // Standard avatar/leading element
  static double get listPaddingHorizontal =>
      ResponsiveHelper.w(16); // Horizontal list padding
  static double get listPaddingVertical =>
      ResponsiveHelper.h(12); // Vertical list padding
  static double get listItemSpacing =>
      ResponsiveHelper.w(12); // Between icon and content

  // Custom spacing
  static double custom(double value) => ResponsiveHelper.w(value);
}

class AppBorderRadius {
  // Industrial Luxury Design System - Squircle Standards
  static BorderRadius get xs => BorderRadius.circular(ResponsiveHelper.r(4));
  static BorderRadius get sm => BorderRadius.circular(ResponsiveHelper.r(8));
  static BorderRadius get md => BorderRadius.circular(
    ResponsiveHelper.r(12),
  ); // Small components: buttons, avatars
  static BorderRadius get lg => BorderRadius.circular(ResponsiveHelper.r(16));
  static BorderRadius get xl => BorderRadius.circular(
    ResponsiveHelper.r(24),
  ); // Main Cards: Bento Grid cards
  static BorderRadius get xxl =>
      BorderRadius.circular(ResponsiveHelper.r(32)); // Premium deep curves
  static BorderRadius get circle =>
      BorderRadius.circular(ResponsiveHelper.r(999));

  // MANDATORY RULES:
  // - Main Cards (Bento Grid): Use xl (24px) or custom(32.0) for premium feel
  // - Small Components (Buttons/Avatars): Use md (12px) or sm (8px)

  // Industrial Luxury presets
  static BorderRadius get squircle => xl; // 24px - The signature squircle
  static BorderRadius get deepSquircle => xxl; // 32px - Deep luxury curves
  static BorderRadius get buttonRadius => md; // 12px - Perfect for buttons
  static BorderRadius get avatarRadius => md; // 12px - Perfect for avatars

  // Custom radius
  static BorderRadius custom(double value) =>
      BorderRadius.circular(ResponsiveHelper.r(value));
}

class AppShadows {
  // Industrial Luxury Shadows - Enhanced for Dark Theme
  static BoxShadow get sm => BoxShadow(
    color: Colors.black.withOpacity(0.15), // More prominent for dark theme
    blurRadius: ResponsiveHelper.r(4),
    offset: Offset(0, ResponsiveHelper.h(2)),
  );

  static BoxShadow get md => BoxShadow(
    color: Colors.black.withOpacity(0.25), // Stronger shadows for luxury feel
    blurRadius: ResponsiveHelper.r(8),
    offset: Offset(0, ResponsiveHelper.h(4)),
  );

  static BoxShadow get lg => BoxShadow(
    color: Colors.black.withOpacity(0.35), // Deep shadows for cards
    blurRadius: ResponsiveHelper.r(16),
    offset: Offset(0, ResponsiveHelper.h(8)),
  );

  static BoxShadow get xl => BoxShadow(
    color: Colors.black.withOpacity(0.45), // Premium deep shadows
    blurRadius: ResponsiveHelper.r(24),
    offset: Offset(0, ResponsiveHelper.h(12)),
  );

  // Gold Glow Shadow - For Active States (Prayer Streak, Game Buttons, etc.)
  static BoxShadow get goldGlow => BoxShadow(
    // Use the gold color with high transparency for soft neon effect
    color: AppColors.primary.withOpacity(0.5),
    // Increase blur heavily for the soft neon effect
    blurRadius: AppSizes.iconLg, // Using 32px blur (large and diffused)
    spreadRadius: AppSpacing.xs, // 4px spread
    offset: const Offset(0, 0), // Centered glow
  );

  // Industrial Luxury presets
  static BoxShadow get cardShadow => lg; // Perfect for Bento Grid cards
  static BoxShadow get buttonShadow => sm; // Subtle for buttons
  static BoxShadow get premiumShadow => xl; // Deep luxury shadow
  static BoxShadow get activeShadow => goldGlow; // Active states with gold glow
}

// Helper class for consistent sizing
class AppSizes {
  // Button heights
  static double get buttonHeightSm => ResponsiveHelper.h(32);
  static double get buttonHeightMd => ResponsiveHelper.h(44);
  static double get buttonHeightLg => ResponsiveHelper.h(56);

  // Icon sizes
  static double get iconXs => ResponsiveHelper.w(12);
  static double get iconSm => ResponsiveHelper.w(16);
  static double get iconMd => ResponsiveHelper.w(24);
  static double get iconLg => ResponsiveHelper.w(32);
  static double get iconXl => ResponsiveHelper.w(48);

  // Avatar sizes
  static double get avatarSm => ResponsiveHelper.w(32);
  static double get avatarMd => ResponsiveHelper.w(48);
  static double get avatarLg => ResponsiveHelper.w(64);
  static double get avatarXl => ResponsiveHelper.w(96);

  // List Layout Constants (extracted from transaction UI patterns)
  static double get listRowHeight =>
      ResponsiveHelper.h(72); // Standard list row height
  static double get listIconSize =>
      ResponsiveHelper.w(24); // Standard list icon size
  static double get listAvatarSize =>
      ResponsiveHelper.w(48); // Standard avatar/leading element
  static double get listPaddingHorizontal =>
      ResponsiveHelper.w(16); // Horizontal list padding
  static double get listPaddingVertical =>
      ResponsiveHelper.h(12); // Vertical list padding
  static double get listItemSpacing =>
      ResponsiveHelper.w(12); // Between icon and content
}

// Typography scaling for list hierarchies (extracted from transaction UI)
class AppTypographyScale {
  static double get primaryText => ResponsiveHelper.sp(16); // Main content text
  static double get secondaryText =>
      ResponsiveHelper.sp(14); // Subtitle/description
  static double get metadataText =>
      ResponsiveHelper.sp(12); // Timestamps, labels
  static double get amountText => ResponsiveHelper.sp(16); // Financial amounts
  static double get captionText =>
      ResponsiveHelper.sp(11); // Very small details
}

// List design patterns extracted from transaction UI
class AppListLayout {
  static EdgeInsets get standardListPadding => EdgeInsets.symmetric(
    horizontal: AppSizes.listPaddingHorizontal,
    vertical: AppSizes.listPaddingVertical,
  );

  static EdgeInsets get listItemContentPadding =>
      EdgeInsets.only(left: AppSizes.listItemSpacing, right: AppSpacing.sm);

  // Row layout pattern from transaction UI
  static EdgeInsets get listRowPadding =>
      EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm);
}
