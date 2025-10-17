import 'package:flutter/material.dart';
import '../../design_system.dart';
import '../../models/activity.dart';
import '../buttons/activity_card.dart';

class ActivityGridWidget extends StatelessWidget {
  final List<Activity> activities;

  const ActivityGridWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.xl,
        mainAxisSpacing: AppSpacing.xl,
        childAspectRatio: 0.8, // Adjust aspect ratio to fit image and text
      ),
      itemBuilder: (context, index) {
        return ActivityCard(
          activity: activities[index],
          onTap: () => _handleActivityTap(activities[index]),
        );
      },
    );
  }

  void _handleActivityTap(Activity activity) {
    // TODO: Implement navigation logic for activities
    debugPrint('Navigate to activity: ${activity.title}');
  }
}
