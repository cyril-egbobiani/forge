import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context, designWidth: 375, designHeight: 812);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.h(16)),

          // User Profile Section
          _buildUserProfile(),

          SizedBox(height: ResponsiveHelper.h(24)),

          // The Word Section
          _buildTheWordSection(),

          SizedBox(height: ResponsiveHelper.h(32)),

          // Quick Actions Section
          _buildQuickActionsSection(),

          SizedBox(
            height: ResponsiveHelper.h(100),
          ), // Bottom padding for nav bar
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      children: [
        // User Avatar
        Container(
          width: ResponsiveHelper.w(48),
          height: ResponsiveHelper.w(48),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
          ),
          child: CircleAvatar(
            radius: ResponsiveHelper.w(22),
            backgroundColor: Colors.grey[700],
            child: const Icon(Icons.person, color: Colors.white), // Fallback
          ),
        ),

        SizedBox(width: ResponsiveHelper.w(12)),

        // Greeting Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey,',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: ResponsiveHelper.sp(14),
                ),
              ),
              Text(
                'Egbobiani Cyril',
                style: AppTextStyles.h6.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveHelper.sp(16),
                ),
              ),
            ],
          ),
        ),

        // Notification Icon
        Container(
          width: ResponsiveHelper.w(40),
          height: ResponsiveHelper.w(40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: ResponsiveHelper.w(20),
          ),
        ),
      ],
    );
  }

  Widget _buildTheWordSection() {
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
          // Header
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.md, left: AppSpacing.sm),
            child: Text(
              'The Word',
              style: AppTextStyles.h6.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveHelper.sp(18),
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          // Teaching Card with enhanced design
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.dark950,
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(16)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Teaching Image with rounded corners and shadow
                    Container(
                      width: ResponsiveHelper.w(70),
                      height: ResponsiveHelper.w(70),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.r(12),
                        ),
                        color: AppColors.grey700,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.r(12),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Placeholder for actual image
                            Container(
                              color: AppColors.grey700,
                              child: Icon(
                                Icons.person,
                                color: AppColors.white.withOpacity(0.7),
                                size: ResponsiveHelper.w(30),
                              ),
                            ),
                            // Play button overlay
                            Container(
                              width: ResponsiveHelper.w(32),
                              height: ResponsiveHelper.w(32),
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow,
                                color: AppColors.black,
                                size: ResponsiveHelper.w(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(width: ResponsiveHelper.w(16)),

                    // Teaching Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Building and Maintaining',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: ResponsiveHelper.sp(16),
                            ),
                          ),

                          SizedBox(height: ResponsiveHelper.h(6)),

                          Text(
                            'Pastor Ikemefuna Chiedu',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.white.withOpacity(0.7),
                              fontSize: ResponsiveHelper.sp(13),
                            ),
                          ),

                          SizedBox(height: ResponsiveHelper.h(4)),

                          Text(
                            '1hr 42mins',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.white.withOpacity(0.5),
                              fontSize: ResponsiveHelper.sp(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.h(20)),

                // Controls with improved design
                Row(
                  children: [
                    // Previous Teachings Button
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to previous teachings
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.w(12),
                          vertical: ResponsiveHelper.h(8),
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.white.withOpacity(0.7),
                              size: ResponsiveHelper.w(14),
                            ),
                            SizedBox(width: ResponsiveHelper.w(4)),
                            Text(
                              'Previous Teachings',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.white.withOpacity(0.7),
                                fontSize: ResponsiveHelper.sp(12),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Enhanced Listen Button
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(12),
                        vertical: ResponsiveHelper.h(8),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.r(25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow,
                            color: AppColors.black,
                            size: ResponsiveHelper.w(18),
                          ),
                          SizedBox(width: ResponsiveHelper.w(6)),
                          Text(
                            'Listen',
                            style: AppTextStyles.buttonMedium.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: ResponsiveHelper.sp(14),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.h6.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.sp(18),
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(16)),

        // Action Cards
        _buildActionCard(
          title: 'Prayer Request',
          subtitle:
              'Submit your prayer requests and let the community pray with you',
          iconPath: 'assets/icons/prayer.svg',
          onTap: () {
            // TODO: Navigate to prayer request
          },
        ),

        SizedBox(height: ResponsiveHelper.h(12)),

        _buildActionCard(
          title: 'Donation',
          subtitle:
              'Support the ministry and make a difference in the community',
          iconPath: 'assets/icons/donation.svg',
          onTap: () {
            // TODO: Navigate to donation
          },
        ),

        SizedBox(height: ResponsiveHelper.h(12)),

        _buildActionCard(
          title: 'Devotionals',
          subtitle:
              'Daily devotionals to strengthen your faith and spiritual growth',
          iconPath: 'assets/icons/devotional.svg',
          onTap: () {
            // TODO: Navigate to devotionals
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.dark900,
          border: Border.all(color: AppColors.dark800, width: 2),
          borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.sp(16),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.h(4)),

                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: ResponsiveHelper.sp(12),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: ResponsiveHelper.w(12)),

            // Icon
            Container(
              width: ResponsiveHelper.w(48),
              height: ResponsiveHelper.w(48),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: ResponsiveHelper.w(24),
                  height: ResponsiveHelper.w(24),
                  colorFilter: ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
