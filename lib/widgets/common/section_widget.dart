import 'package:flutter/material.dart';
import '../../design_system.dart';

class SectionWidget extends StatelessWidget {
  final String title;
  final Widget content;
  final EdgeInsets? padding;

  const SectionWidget({
    super.key,
    required this.title,
    required this.content,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Padding(
              padding: EdgeInsets.only(
                bottom: AppSpacing.md,
                left: AppSpacing.lg,
                top: AppSpacing.md,
              ),
              child: Text(
                title,
                style: AppTypography.sectionTitle.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
            ),
            // Section Content
            content,
          ],
        ),
      ),
    );
  }
}
