import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/responsive_helper.dart';

class TeachingsPage extends StatelessWidget {
  const TeachingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context, designWidth: 375, designHeight: 812);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ResponsiveHelper.h(16)),

          Text(
            'Teachings',
            style: AppTextStyles.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.sp(24),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(24)),

          // Featured Teaching
          _buildFeaturedTeaching(),

          SizedBox(height: ResponsiveHelper.h(24)),

          // Recent Teachings List
          Text(
            'Recent Teachings',
            style: AppTextStyles.h6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.sp(18),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          // Teaching List
          ...List.generate(5, (index) => _buildTeachingCard(index)),

          SizedBox(height: ResponsiveHelper.h(100)),
        ],
      ),
    );
  }

  Widget _buildFeaturedTeaching() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(8),
                  vertical: ResponsiveHelper.h(4),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
                ),
                child: Text(
                  'FEATURED',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveHelper.sp(10),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.h(12)),

          Container(
            height: ResponsiveHelper.h(120),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
            ),
            child: Center(
              child: Icon(
                Icons.play_circle_filled,
                color: Colors.white,
                size: ResponsiveHelper.w(48),
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(12)),

          Text(
            'Faith That Moves Mountains',
            style: AppTextStyles.h6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.sp(16),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(4)),

          Text(
            'Pastor Ikemefuna Chiedu • 2hr 15mins',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.7),
              fontSize: ResponsiveHelper.sp(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeachingCard(int index) {
    final teachings = [
      'Building and Maintaining',
      'The Power of Prayer',
      'Walking in Purpose',
      'Divine Healing',
      'Spiritual Warfare',
    ];

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.w(60),
            height: ResponsiveHelper.w(60),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
            ),
            child: Icon(
              Icons.play_circle_filled,
              color: Colors.white,
              size: ResponsiveHelper.w(24),
            ),
          ),

          SizedBox(width: ResponsiveHelper.w(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teachings[index],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveHelper.sp(14),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.h(4)),

                Text(
                  'Pastor Ikemefuna Chiedu',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.h(4)),

                Text(
                  '1hr ${30 + index * 5}mins',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: ResponsiveHelper.sp(11),
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.more_vert,
            color: Colors.white.withOpacity(0.5),
            size: ResponsiveHelper.w(20),
          ),
        ],
      ),
    );
  }
}
