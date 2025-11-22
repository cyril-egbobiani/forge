import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/lucide.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Iconify(Lucide.heart, size: 48, color: Colors.grey),
              SizedBox(height: AppSpacing.md),
              Text(
                'No prayer requests found',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                'Be the first to share a prayer request with the community.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
