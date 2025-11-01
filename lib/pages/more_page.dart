import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/responsive_helper.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

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
            'More',
            style: AppTextStyles.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.sp(24),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(24)),

          // Quick Links Section
          _buildSection('Quick Links', [
            {
              'icon': Icons.book_outlined,
              'title': 'Bible Study',
              'subtitle': 'Daily scripture study',
            },
            {
              'icon': Icons.group_outlined,
              'title': 'Connect Groups',
              'subtitle': 'Join a small group',
            },
            {
              'icon': Icons.volunteer_activism_outlined,
              'title': 'Volunteer',
              'subtitle': 'Serve the community',
            },
            {
              'icon': Icons.calendar_today_outlined,
              'title': 'Calendar',
              'subtitle': 'Church calendar',
            },
          ]),

          SizedBox(height: ResponsiveHelper.h(24)),

          // Resources Section
          _buildSection('Resources', [
            {
              'icon': Icons.library_books_outlined,
              'title': 'Resources',
              'subtitle': 'Books and materials',
            },
            {
              'icon': Icons.music_note_outlined,
              'title': 'Worship Songs',
              'subtitle': 'Hymns and worship',
            },
            {
              'icon': Icons.podcasts_outlined,
              'title': 'Podcasts',
              'subtitle': 'Audio content',
            },
            {
              'icon': Icons.video_library_outlined,
              'title': 'Video Library',
              'subtitle': 'Video teachings',
            },
          ]),

          SizedBox(height: ResponsiveHelper.h(24)),

          // Support Section
          _buildSection('Support', [
            {
              'icon': Icons.contact_support_outlined,
              'title': 'Contact Us',
              'subtitle': 'Get in touch',
            },
            {
              'icon': Icons.info_outlined,
              'title': 'About',
              'subtitle': 'About the church',
            },
            {
              'icon': Icons.share_outlined,
              'title': 'Share App',
              'subtitle': 'Tell others about Forge',
            },
            {
              'icon': Icons.feedback_outlined,
              'title': 'Feedback',
              'subtitle': 'Share your thoughts',
            },
          ]),

          SizedBox(height: ResponsiveHelper.h(100)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h6.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.sp(18),
          ),
        ),

        SizedBox(height: ResponsiveHelper.h(16)),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2a2a2a),
            borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return _buildMenuItem(
                icon: item['icon'] as IconData,
                title: item['title'] as String,
                subtitle: item['subtitle'] as String,
                showDivider: !isLast,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(8)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.2),
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(8)),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFFD700),
              size: ResponsiveHelper.w(20),
            ),
          ),
          title: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
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
            // TODO: Handle menu item tap
          },
        ),

        if (showDivider)
          Divider(
            color: Colors.white.withOpacity(0.1),
            height: 1,
            indent: ResponsiveHelper.w(56),
            endIndent: ResponsiveHelper.w(16),
          ),
      ],
    );
  }
}
