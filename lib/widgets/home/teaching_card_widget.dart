import 'package:flutter/material.dart';
import '../../design_system.dart';
import '../../models/teaching.dart';

class TeachingCardWidget extends StatelessWidget {
  final Teaching teaching;

  const TeachingCardWidget({super.key, required this.teaching});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row (Image, Title, Speaker, Duration)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Image.network(
                  teaching.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.surfaceContainerLow,
                    child: Center(
                      child: Icon(
                        Icons.image,
                        color: AppColors.secondaryText,
                        size: AppIconSizes.xl,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        teaching.title,
                        style: AppTypography.cardTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(teaching.speaker, style: AppTypography.cardSubtitle),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        teaching.duration,
                        style: AppTypography.cardMetadata,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          // Description
          Text(
            teaching.description,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.secondaryText,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Divider(
            height: AppSpacing.xxxl,
            thickness: 0.5,
            color: AppColors.divider,
          ),
          // Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  // TODO: Navigate to previous teachings
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: AppIconSizes.sm,
                  color: AppColors.primary,
                ),
                label: Wrap(
                  children: [
                    Text('Previous', style: AppTypography.actionButton),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Play teaching
                },
                icon: Icon(
                  Icons.play_circle_fill,
                  size: AppIconSizes.lg,
                  color: AppColors.primary,
                ),
                label: Text('Listen', style: AppTypography.actionButton),
                // style: TextButton.styleFrom(
                //   padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                // ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
