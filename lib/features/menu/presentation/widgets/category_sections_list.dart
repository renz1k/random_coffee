import 'package:flutter/material.dart';
import 'package:random_coffee/features/menu/domain/entities/category.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_card.dart';
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

    return Expanded(
      child: ScrollablePositionedList.builder(
        itemCount: categories.length + 1, // +1 для отступа снизу
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemBuilder: (context, index) {
          // Последний элемент - отступ для кнопок
          if (index == categories.length) {
            return const SizedBox(height: 80);
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 40,
                  child: Text(
                    category.name,
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                    mainAxisExtent: 200.0,
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
