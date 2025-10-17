import 'package:flutter/material.dart';
import '../../design_system.dart';
import '../../models/user_info.dart';

class HeaderWidget extends StatelessWidget {
  final UserInfo userInfo;

  const HeaderWidget({super.key, required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xl,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.avatar),
              color: AppColors.surfaceContainerLow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.avatar),
              child: Image.network(
                userInfo.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(
                    Icons.person,
                    color: AppColors.secondaryText,
                    size: AppIconSizes.lg,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.xl),
          // Greeting Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${userInfo.greeting},', style: AppTypography.greeting),
                Text(userInfo.name, style: AppTypography.userName),
              ],
            ),
          ),
          // Notification Icon
          Icon(
            Icons.notifications_none,
            color: AppColors.secondaryText,
            size: AppIconSizes.lg,
          ),
        ],
      ),
    );
  }
}
