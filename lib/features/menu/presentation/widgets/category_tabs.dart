import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/menu/domain/entities/category.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.scrollController,
    required this.categoryButtonKeys,
    required this.onCategoryTap,
  });

  final List<Category> categories;
  final int? selectedCategoryId;
  final ScrollController scrollController;
  final Map<int, GlobalKey> categoryButtonKeys;
  final Function(int, int) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return SizedBox(
      height: AppConstants.categoryTabHeight,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(
          left: AppConstants.paddingMedium,
          right: 300,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selectedCategoryId;

          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.spacingSmall),
            child: GestureDetector(
              key: categoryButtonKeys[category.id],
              onTap: () => onCategoryTap(category.id, index),
              child: AnimatedContainer(
                duration: AppConstants.animationDuration,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isLight
                            ? AppColors.primaryLight
                            : AppColors.primaryDark)
                      : (isLight
                            ? theme.colorScheme.surface
                            : AppColors.textLightPrimary),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusExtraLarge,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  category.name,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? (AppColors.textDarkPrimary)
                        : (isLight
                              ? AppColors.textLightPrimary
                              : AppColors.textDarkSecondary),
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
