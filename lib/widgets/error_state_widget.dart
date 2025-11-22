import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';

class ErrorStateWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Error loading prayer requests',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.red.shade600,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                error,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.md),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}
