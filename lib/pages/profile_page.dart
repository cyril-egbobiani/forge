import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/responsive_helper.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context, designWidth: 375, designHeight: 812);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.h(16)),

          // Profile Header
          _buildProfileHeader(),

          SizedBox(height: ResponsiveHelper.h(32)),

          // Profile Options
          _buildProfileOptions(),

          SizedBox(height: ResponsiveHelper.h(100)),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(16)),
      ),
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: ResponsiveHelper.w(80),
            height: ResponsiveHelper.w(80),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFD700), width: 3),
            ),
            child: CircleAvatar(
              radius: ResponsiveHelper.w(37),
              backgroundColor: Colors.grey[700],
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: ResponsiveHelper.w(40),
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          Text(
            'Egbobiani Cyril',
            style: AppTextStyles.h5.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.sp(20),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(4)),

          Text(
            'Member since 2023',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontSize: ResponsiveHelper.sp(14),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(16),
              vertical: ResponsiveHelper.h(8),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.2),
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
            ),
            child: Text(
              'Edit Profile',
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFFFFD700),
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveHelper.sp(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions() {
    final options = [
      {
        'icon': Icons.bookmark_outline,
        'title': 'Saved Teachings',
        'subtitle': 'Your bookmarked content',
      },
      {
        'icon': Icons.history,
        'title': 'Listening History',
        'subtitle': 'Recently played teachings',
      },
      {
        'icon': Icons.favorite_outline,
        'title': 'Prayer Requests',
        'subtitle': 'Your submitted requests',
      },
      {
        'icon': Icons.card_giftcard,
        'title': 'Donations',
        'subtitle': 'Your giving history',
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Notifications',
        'subtitle': 'Manage your alerts',
      },
      {
        'icon': Icons.settings_outlined,
        'title': 'Settings',
        'subtitle': 'App preferences',
      },
      {
        'icon': Icons.help_outline,
        'title': 'Help & Support',
        'subtitle': 'Get assistance',
      },
      {
        'icon': Icons.logout,
        'title': 'Sign Out',
        'subtitle': 'Log out of your account',
      },
    ];

    return Column(
      children: options
          .map(
            (option) => _buildOptionCard(
              icon: option['icon'] as IconData,
              title: option['title'] as String,
              subtitle: option['subtitle'] as String,
              isLogout: option['title'] == 'Sign Out',
            ),
          )
          .toList(),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isLogout = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(8)),
          decoration: BoxDecoration(
            color: isLogout
                ? Colors.red.withOpacity(0.2)
                : const Color(0xFFFFD700).withOpacity(0.2),
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
          ),
          child: Icon(
            icon,
            color: isLogout ? Colors.red : const Color(0xFFFFD700),
            size: ResponsiveHelper.w(20),
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isLogout ? Colors.red : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: ResponsiveHelper.sp(14),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.6),
            fontSize: ResponsiveHelper.sp(12),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white.withOpacity(0.4),
          size: ResponsiveHelper.w(16),
        ),
        onTap: () {
          // TODO: Handle option tap
        },
      ),
    );
  }
}
