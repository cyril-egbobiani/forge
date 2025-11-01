import 'package:flutter/material.dart';
import 'responsive_helper.dart';

class AppSpacing {
  // Base spacing unit - adjust based on your design system
  static const double baseUnit = 8.0;

  // Predefined spacing values using responsive helper
  static double get xs => ResponsiveHelper.w(4); // 4px
  static double get sm => ResponsiveHelper.w(8); // 8px
  static double get md => ResponsiveHelper.w(16); // 16px
  static double get lg => ResponsiveHelper.w(24); // 24px
  static double get xl => ResponsiveHelper.w(32); // 32px
  static double get xxl => ResponsiveHelper.w(48); // 48px
  static double get xxxl => ResponsiveHelper.w(64); // 64px

  // Custom spacing
  static double custom(double value) => ResponsiveHelper.w(value);
}

class AppBorderRadius {
  static BorderRadius get xs => BorderRadius.circular(ResponsiveHelper.r(4));
  static BorderRadius get sm => BorderRadius.circular(ResponsiveHelper.r(8));
  static BorderRadius get md => BorderRadius.circular(ResponsiveHelper.r(12));
  static BorderRadius get lg => BorderRadius.circular(ResponsiveHelper.r(16));
  static BorderRadius get xl => BorderRadius.circular(ResponsiveHelper.r(24));
  static BorderRadius get circle =>
      BorderRadius.circular(ResponsiveHelper.r(999));

  // Custom radius
  static BorderRadius custom(double value) =>
      BorderRadius.circular(ResponsiveHelper.r(value));
}

class AppShadows {
  static BoxShadow get sm => BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: ResponsiveHelper.r(4),
    offset: Offset(0, ResponsiveHelper.h(2)),
  );

  static BoxShadow get md => BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: ResponsiveHelper.r(8),
    offset: Offset(0, ResponsiveHelper.h(4)),
  );

  static BoxShadow get lg => BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: ResponsiveHelper.r(16),
    offset: Offset(0, ResponsiveHelper.h(8)),
  );

  static BoxShadow get xl => BoxShadow(
    color: Colors.black.withOpacity(0.2),
    blurRadius: ResponsiveHelper.r(24),
    offset: Offset(0, ResponsiveHelper.h(12)),
  );
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
}
