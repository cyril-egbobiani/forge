import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_colors.dart';
import '../utils/responsive_helper.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context, designWidth: 375, designHeight: 812);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(20),
                vertical: ResponsiveHelper.h(16),
              ),
              child: Text(
                'Events',
                style: GoogleFonts.archivoBlack(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(24),
                  letterSpacing: -1.5,
                  height: 1.0,
                ),
              ),
            ),

            // Events List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.w(20),
                ),
                itemCount: 4, // Show 4 events like in the design
                itemBuilder: (context, index) {
                  return _buildEventCard(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(int index) {
    // Event data matching the design
    final events = [
      {
        'title': 'Preparation for summer camp coaching',
        'date': 'Jun 06, 10:00AM',
        'image':
            'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=400',
      },
      {
        'title': 'Preparation for summer camp coaching',
        'date': 'Jun 06, 10:00AM',
        'image':
            'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=400',
      },
      {
        'title': 'Preparation for summer camp coaching',
        'date': 'Jun 06, 10:00AM',
        'image':
            'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=400',
      },
      {
        'title': 'Preparation for summer camp coaching',
        'date': 'Jun 06, 10:00AM',
        'image':
            'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=400',
      },
    ];

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to event details
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16)),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(ResponsiveHelper.r(20)),
        ),
        child: DottedBorder(
          dashPattern: [8, 8],
          strokeWidth: 2,
          color: AppColors.dark950,
          borderType: BorderType.RRect,
          radius: Radius.circular(ResponsiveHelper.r(20)),
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(8)),
            decoration: BoxDecoration(
              color: AppColors.dark950,
              borderRadius: BorderRadius.circular(ResponsiveHelper.r(18)),
            ),
            child: Row(
              children: [
                // Event Image
                Container(
                  width: ResponsiveHelper.w(60),
                  height: ResponsiveHelper.w(60),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
                    color: AppColors.dark700,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.r(12)),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.orange.shade400,
                            Colors.orange.shade600,
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.event,
                        color: Color(0xFF2a2a2a),
                        size: ResponsiveHelper.w(30),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: ResponsiveHelper.w(16)),

                // Event Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        events[index]['title']!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: ResponsiveHelper.sp(15),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        events[index]['date']!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.medium,
                          fontSize: ResponsiveHelper.sp(12),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.4),
                  size: ResponsiveHelper.w(24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
