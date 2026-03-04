import 'package:flutter/material.dart';
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

    return SizedBox(
      height: 29,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, right: 300),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selectedCategoryId;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              key: categoryButtonKeys[category.id],
              onTap: () => onCategoryTap(category.id, index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  category.name,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
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
