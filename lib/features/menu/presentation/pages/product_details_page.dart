import 'package:flutter/material.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_image.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_local_image_placeholder.dart';
import 'package:random_coffee/features/menu/presentation/widgets/theme_button.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: Stack(children: [ThemeButton()]),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              BackToMenuButton(),

              const SizedBox(height: 16),

              Center(
                child: ProductImage(
                  product: product,
                  placeholder: ProductLocalImagePlaceholder(
                    height: 218,
                    backgroundColor: AppColors.background,
                  ),
                  height: 218,
                  color: AppColors.primaryColor,
                ),
              ),

              const SizedBox(height: 64),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  product.name,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  product.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackToMenuButton extends StatelessWidget {
  const BackToMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back_ios_new, size: 20, weight: 40),
    );
  }
}
