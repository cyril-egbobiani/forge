import 'package:flutter/material.dart';
import '../../design_system.dart';
import '../../models/quick_action.dart';

class QuickActionButton extends StatelessWidget {
  final QuickAction action;
  final VoidCallback? onTap;

  const QuickActionButton({super.key, required this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () {
            // Default action - can be overridden
            debugPrint('${action.title} tapped');
          },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: 80,
        height: 80,
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.outlineVariant, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: AppIconSizes.lg,
              height: AppIconSizes.lg,
              child: action.icon,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              action.title,
              style: AppTypography.quickActionLabel,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
