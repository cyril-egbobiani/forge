import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_dimensions.dart';
import '../utils/app_colors.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
         itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Container(
              margin: EdgeInsets.only(right: AppSpacing.sm),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
               ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.dark900,
                borderRadius: BorderRadius.circular(25),
               
               
              ),
              child: Center(
                child: Text(
                  category,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
