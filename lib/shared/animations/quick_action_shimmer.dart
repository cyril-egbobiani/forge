import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/app_colors.dart';

class QuickActionShimmer extends StatelessWidget {
  const QuickActionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.background,
      highlightColor: AppColors.primary.withOpacity(0.2),
      child: Container(
        height: 72,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 16, width: 80, color: Colors.white24),
                    SizedBox(height: 8),
                    Container(height: 12, width: 120, color: Colors.white24),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
