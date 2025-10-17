import 'package:flutter/material.dart';
import '../design_system.dart';
import '../widgets/common/section_widget.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Events', style: AppTypography.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.lg),

            // Upcoming Events Section
            SectionWidget(
              title: 'Upcoming Events',
              content: _buildUpcomingEvents(),
            ),

            SizedBox(height: AppSpacing.section),

            // Past Events Section
            SectionWidget(title: 'Past Events', content: _buildPastEvents()),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      children: [
        _buildEventCard(
          title: 'Sunday Service',
          date: 'October 20, 2025',
          time: '10:00 AM',
          location: 'Main Sanctuary',
          isUpcoming: true,
        ),
        SizedBox(height: AppSpacing.lg),
        _buildEventCard(
          title: 'Youth Fellowship',
          date: 'October 22, 2025',
          time: '6:00 PM',
          location: 'Youth Center',
          isUpcoming: true,
        ),
        SizedBox(height: AppSpacing.lg),
        _buildEventCard(
          title: 'Bible Study',
          date: 'October 24, 2025',
          time: '7:00 PM',
          location: 'Conference Room',
          isUpcoming: true,
        ),
      ],
    );
  }

  Widget _buildPastEvents() {
    return Column(
      children: [
        _buildEventCard(
          title: 'Prayer Conference',
          date: 'October 15, 2025',
          time: '9:00 AM',
          location: 'Main Sanctuary',
          isUpcoming: false,
        ),
        SizedBox(height: AppSpacing.lg),
        _buildEventCard(
          title: 'Community Outreach',
          date: 'October 10, 2025',
          time: '2:00 PM',
          location: 'Community Center',
          isUpcoming: false,
        ),
      ],
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String time,
    required String location,
    required bool isUpcoming,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: AppTypography.cardTitle)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isUpcoming
                      ? AppColors.primary
                      : AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Text(
                  isUpcoming ? 'Upcoming' : 'Past',
                  style: AppTypography.labelSmall.copyWith(
                    color: isUpcoming
                        ? AppColors.surface
                        : AppColors.secondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: AppIconSizes.sm,
                color: AppColors.secondaryText,
              ),
              SizedBox(width: AppSpacing.md),
              Text(date, style: AppTypography.bodyMedium),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: AppIconSizes.sm,
                color: AppColors.secondaryText,
              ),
              SizedBox(width: AppSpacing.md),
              Text(time, style: AppTypography.bodyMedium),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: AppIconSizes.sm,
                color: AppColors.secondaryText,
              ),
              SizedBox(width: AppSpacing.md),
              Text(location, style: AppTypography.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
