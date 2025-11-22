import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forge/utils/app_colors.dart';
import '../utils/responsive_helper.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.background),
      child: SafeArea(
        child: Container(
          height: ResponsiveHelper.h(70),
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.w(16),
            vertical: ResponsiveHelper.h(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                iconPath: 'assets/icons/home.svg',
                activeIconPath: 'assets/icons/home.svg',
                index: 0,
              ),
              _buildNavItem(
                iconPath: 'assets/icons/events.svg',
                activeIconPath: 'assets/icons/events.svg',
                index: 1,
              ),
              _buildNavItem(
                iconPath: 'assets/icons/events.svg',
                activeIconPath: 'assets/icons/events.svg',
                index: 2,
              ),
              _buildNavItem(
                iconPath: 'assets/icons/games.svg',
                activeIconPath: 'assets/icons/games.svg',
                index: 3,
              ),
              _buildNavItem(
                iconPath: 'assets/icons/chat.svg',
                activeIconPath: 'assets/icons/chat.svg',
                index: 4,
              ),
              _buildNavItem(
                iconPath: 'assets/icons/home.svg',
                activeIconPath: 'assets/icons/home.svg',
                index: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String activeIconPath,

    required int index,
  }) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.w(8),
          vertical: ResponsiveHelper.h(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isActive ? activeIconPath : iconPath,
              color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
              width: ResponsiveHelper.w(24),
              height: ResponsiveHelper.w(24),
            ),
            SizedBox(height: ResponsiveHelper.h(4)),
          ],
        ),
      ),
    );
  }
}
