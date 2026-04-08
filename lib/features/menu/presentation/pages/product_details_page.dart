import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_image.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_local_image_placeholder.dart';
import 'package:random_coffee/features/menu/presentation/widgets/theme_button.dart';
import 'package:random_coffee/uikit/icons/app_icon.dart';
import 'package:random_coffee/uikit/icons/app_icons.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      floatingActionButton: Stack(children: [const ThemeButton()]),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.productDetailsTopPadding),

              BackToMenuButton(isLight: isLight),

              const SizedBox(height: AppConstants.paddingMedium),

              Center(
                child: ProductImage(
                  product: product,
                  placeholder: ProductLocalImagePlaceholder(
                    height: AppConstants.productDetailsImageHeight,
                    backgroundColor: theme.scaffoldBackgroundColor,
                  ),
                  height: AppConstants.productDetailsImageHeight,
                  color: isLight
                      ? AppColors.primaryLight
                      : AppColors.primaryDark,
                ),
              ),

              const SizedBox(height: AppConstants.spacingExtraLarge),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                child: Text(
                  product.name,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: isLight
                        ? AppColors.textLightPrimary
                        : AppColors.textDarkSecondary,
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                child: Text(
                  product.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isLight
                        ? AppColors.textLightPrimary
                        : AppColors.textDarkSecondary,
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
  const BackToMenuButton({super.key, required this.isLight});

  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: AppIcon(
        AppIcons.arrowBack,
        size: AppConstants.iconSizeSmall,
        color: isLight
            ? AppColors.textLightPrimary
            : AppColors.textDarkSecondary,
      ),
    );
  }
}
