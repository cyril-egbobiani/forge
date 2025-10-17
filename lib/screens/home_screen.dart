import 'package:flutter/material.dart';
import '../design_system.dart';
import '../data/mock_data.dart';
import '../widgets/common/section_widget.dart';
import '../widgets/home/header_widget.dart';
import '../widgets/home/teaching_card_widget.dart';
import '../widgets/home/quick_actions_widget.dart';
import '../widgets/home/activity_grid_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: AppSpacing.page + AppSpacing.lg, // Account for status bar
          bottom: AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header with user greeting and avatar
            HeaderWidget(userInfo: MockData.userInfo),

            SizedBox(height: AppSpacing.section),

            // 2. Latest Teaching Section
            SectionWidget(
              title: 'Word',
              content: TeachingCardWidget(teaching: MockData.latestTeaching),
            ),

            SizedBox(height: AppSpacing.page),

            // 3. Quick Actions Section
            SectionWidget(
              title: 'Quick Actions',
              content: QuickActionsWidget(actions: MockData.quickActions),
            ),

            SizedBox(height: AppSpacing.page),

            // 4. Latest Activity Section
            SectionWidget(
              title: 'Latest Activity',
              content: ActivityGridWidget(
                activities: MockData.latestActivities,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
