import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/responsive_helper.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

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
            'Events',
            style: AppTextStyles.h4.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.sp(24),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(24)),

          // Upcoming Events
          Text(
            'Upcoming Events',
            style: AppTextStyles.h6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.sp(18),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          // Event Cards
          ...List.generate(3, (index) => _buildEventCard(index)),

          SizedBox(height: ResponsiveHelper.h(24)),

          // Past Events
          Text(
            'Past Events',
            style: AppTextStyles.h6.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.sp(18),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16)),

          ...List.generate(2, (index) => _buildPastEventCard(index)),

          SizedBox(height: ResponsiveHelper.h(100)),
        ],
      ),
    );
  }

  Widget _buildEventCard(int index) {
    final events = [
      {'title': 'Sunday Service', 'date': 'Nov 3, 2024', 'time': '10:00 AM'},
      {'title': 'Prayer Meeting', 'date': 'Nov 5, 2024', 'time': '6:00 PM'},
      {'title': 'Youth Conference', 'date': 'Nov 10, 2024', 'time': '9:00 AM'},
    ];

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16)),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(16)),
        border: Border.all(
          color: const Color(0xFFFFD700).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Date Circle
          Container(
            width: ResponsiveHelper.w(60),
            height: ResponsiveHelper.w(60),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  events[index]['date']!.split(' ')[1].replaceAll(',', ''),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveHelper.sp(16),
                  ),
                ),
                Text(
                  events[index]['date']!.split(' ')[0],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black,
                    fontSize: ResponsiveHelper.sp(10),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: ResponsiveHelper.w(16)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  events[index]['title']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: ResponsiveHelper.sp(16),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.h(4)),

                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.white.withOpacity(0.7),
                      size: ResponsiveHelper.w(14),
                    ),
                    SizedBox(width: ResponsiveHelper.w(4)),
                    Text(
                      events[index]['time']!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: ResponsiveHelper.sp(12),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveHelper.h(8)),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.w(12),
                    vertical: ResponsiveHelper.h(6),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
                  ),
                  child: Text(
                    'Register',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFFFFD700),
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.sp(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastEventCard(int index) {
    final pastEvents = [
      {'title': 'Harvest Festival', 'date': 'Oct 15, 2024'},
      {'title': 'Baptism Service', 'date': 'Oct 8, 2024'},
    ];

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a).withOpacity(0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
      ),
      child: Row(
        children: [
          Container(
            width: ResponsiveHelper.w(40),
            height: ResponsiveHelper.w(40),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
            ),
            child: Icon(
              Icons.event,
              color: Colors.white.withOpacity(0.5),
              size: ResponsiveHelper.w(20),
            ),
          ),

          SizedBox(width: ResponsiveHelper.w(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pastEvents[index]['title']!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveHelper.sp(14),
                  ),
                ),

                SizedBox(height: ResponsiveHelper.h(4)),

                Text(
                  pastEvents[index]['date']!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
