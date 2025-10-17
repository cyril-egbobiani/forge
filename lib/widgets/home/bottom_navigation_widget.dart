import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../design_system.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavigationWidget({super.key, this.currentIndex = 0, this.onTap});

  // Helper method to create colored SVG icons
  Widget _buildNavIcon(String assetPath, int itemIndex) {
    final bool isSelected = currentIndex == itemIndex;
    return SvgPicture.asset(
      assetPath,
      colorFilter: ColorFilter.mode(
        isSelected ? AppColors.primary : AppColors.tertiaryText,
        BlendMode.srcIn,
      ),
      width: AppIconSizes.lg,
      height: AppIconSizes.lg,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5), // 50% opacity
        border: const Border(
          top: BorderSide(
            color: Colors.white, // White top stroke
            width: 1.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.tertiaryText,
        showUnselectedLabels: true,
        backgroundColor: Colors.transparent, // Make background transparent
        elevation: 0, // Remove default elevation
        onTap: onTap ?? _handleNavigationTap,
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelSmall,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavIcon('assets/home.svg', 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon('assets/event_b.svg', 1),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon('assets/chat.svg', 2),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon('assets/user.svg', 3),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _handleNavigationTap(int index) {
    // TODO: Implement navigation logic
    switch (index) {
      case 0:
        debugPrint('Navigate to Home');
        break;
      case 1:
        debugPrint('Navigate to Events');
        break;
      case 2:
        debugPrint('Navigate to Chats');
        break;
      case 3:
        debugPrint('Navigate to Profile');
        break;
    }
  }
}
