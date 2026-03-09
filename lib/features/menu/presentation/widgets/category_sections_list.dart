import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/menu/domain/entities/category.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_card.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CategorySectionsList extends StatelessWidget {
  const CategorySectionsList({
    super.key,
    required ItemScrollController itemScrollController,
    required ItemPositionsListener itemPositionsListener,
    required this.categories,
    required this.allProducts,
  }) : _itemScrollController = itemScrollController,
       _itemPositionsListener = itemPositionsListener;

  final ItemScrollController _itemScrollController;
  final ItemPositionsListener _itemPositionsListener;
  final List<Category> categories;
  final List<Product> allProducts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Expanded(
      child: ScrollablePositionedList.builder(
        itemCount: categories.length + 1,
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemBuilder: (context, index) {
          // Последний элемент - отступ для кнопок
          if (index == categories.length) {
            return const SizedBox(
              height: AppConstants.floatingButtonBottomSpacing,
            );
          }

          final category = categories[index];

          final categoryProducts = allProducts
              .where((p) => p.categoryId == category.id)
              .toList();

          if (categoryProducts.isEmpty) {
            return const SizedBox();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                child: SizedBox(
                  height: AppConstants.categoryTitleHeight,
                  child: Text(
                    category.name,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: isLight
                          ? AppColors.textLightPrimary
                          : AppColors.textDarkSecondary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingExtraLarge),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.categoryPaddingHorizontal,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    bottom: AppConstants.paddingExtraLarge,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppConstants.spacingSmall,
                    crossAxisSpacing: AppConstants.paddingMedium,
                    childAspectRatio: 0.8,
                    mainAxisExtent: AppConstants.productCardHeight,
                  ),
                  itemCount: categoryProducts.length,
                  itemBuilder: (context, productIndex) =>
                      ProductCard(product: categoryProducts[productIndex]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
