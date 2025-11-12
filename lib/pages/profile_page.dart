import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/responsive_helper.dart';
import '../utils/app_colors.dart';

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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.w(20),
              vertical: ResponsiveHelper.h(16),
            ),
            child: Text(
              'Games',
              style: AppTextStyles.h5.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.dark900,
        border: Border.all(color: AppColors.dark800, width: 2),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Card with enhanced design
          Row(
            children: [
              // Profile Picture with enhanced design
              Container(
                width: ResponsiveHelper.w(70),
                height: ResponsiveHelper.w(70),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
                  color: const Color(0xFF2196F3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
                  child: Icon(
                    Icons.person,
                    color: AppColors.white,
                    size: ResponsiveHelper.w(32),
                  ),
                ),
              ),

              SizedBox(width: ResponsiveHelper.w(16)),

              // Name and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Michael Smith',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveHelper.sp(18),
                      ),
                    ),

                    SizedBox(height: ResponsiveHelper.h(6)),

                    Text(
                      'Let\'s schedule a meeting to discuss',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withOpacity(0.7),
                        fontSize: ResponsiveHelper.sp(14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.dark950,
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(16)),
            ),
            child: Column(
              children: [
               

 
                // Stats row with dividers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('32', 'Posts'),

                    // Vertical divider
                    Container(
                      height: ResponsiveHelper.h(40),
                      width: 1,
                      color: AppColors.white.withOpacity(0.2),
                    ),

                    _buildStatItem('40', 'Following'),

                    // Vertical divider
                    Container(
                      height: ResponsiveHelper.h(40),
                      width: 1,
                      color: AppColors.white.withOpacity(0.2),
                    ),

                    _buildStatItem('2025', 'Joined'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.sp(20),
          ),
        ),
        SizedBox(height: ResponsiveHelper.h(4)),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white.withOpacity(0.7),
            fontSize: ResponsiveHelper.sp(14),
          ),
        ),
      ],
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
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(8)),
          decoration: BoxDecoration(
            color: isLogout
                ? Colors.red.withOpacity(0.2)
                : AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
          ),
          child: Icon(
            icon,
            color: isLogout ? Colors.red : AppColors.primary,
            size: ResponsiveHelper.w(20),
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isLogout ? Colors.red : AppColors.white,
            fontWeight: FontWeight.w500,
            fontSize: ResponsiveHelper.sp(14),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white.withOpacity(0.6),
            fontSize: ResponsiveHelper.sp(12),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.white.withOpacity(0.4),
          size: ResponsiveHelper.w(16),
        ),
        onTap: () {
          // TODO: Handle option tap
        },
      ),
    );
  }
}
