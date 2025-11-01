import 'package:flutter/material.dart';

class ResponsiveHelper {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double designWidth;
  static late double designHeight;
  static late double scaleWidth;
  static late double scaleHeight;
  static late double scale;

  // Initialize with your Figma design size
  static void init(
    BuildContext context, {
    double designWidth = 375,
    double designHeight = 812,
  }) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    ResponsiveHelper.designWidth = designWidth;
    ResponsiveHelper.designHeight = designHeight;

    scaleWidth = screenWidth / designWidth;
    scaleHeight = screenHeight / designHeight;
    scale = scaleWidth < scaleHeight ? scaleWidth : scaleHeight;
  }

  // Responsive width
  static double w(double width) {
    return width * scaleWidth;
  }

  // Responsive height
  static double h(double height) {
    return height * scaleHeight;
  }

  // Responsive font size
  static double sp(double fontSize) {
    return fontSize * scale;
  }

  // Responsive radius
  static double r(double radius) {
    return radius * scale;
  }

  // Screen fractions
  static double screenWidthFraction(double fraction) {
    return screenWidth * fraction;
  }

  static double screenHeightFraction(double fraction) {
    return screenHeight * fraction;
  }

  // Device type helpers
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  // Orientation helpers
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Safe area helpers
  static EdgeInsets safeArea(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  static double statusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double bottomSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }
}
