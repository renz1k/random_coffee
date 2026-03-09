import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_state.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';
import 'package:random_coffee/features/menu/presentation/pages/product_details_page.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_bottom_panel.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_image.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_local_image_placeholder.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        final quantity = cubit.getProductQuantity(product.id);

        return Container(
          height: AppConstants.productCardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            color: isLight
                ? theme.colorScheme.surface
                : AppColors.textLightPrimary,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppConstants.paddingExtraSmall),

              // КАРТИНКА 100px
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(product: product),
                  ),
                ),
                child: ProductImage(
                  product: product,
                  placeholder: ProductLocalImagePlaceholder(
                    backgroundColor: isLight
                        ? theme.colorScheme.surface
                        : AppColors.textLightPrimary,
                  ),
                  height: AppConstants.productCardImageHeight,
                  color: isLight
                      ? theme.colorScheme.surface
                      : AppColors.textLightPrimary,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingSmall,
                  vertical: AppConstants.paddingTiny,
                ),
                child: Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: isLight
                        ? AppColors.textLightPrimary
                        : AppColors.textDarkSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: AppConstants.paddingSmall),

              // НИЖНЯЯ ПАНЕЛЬ
              ProductBottomPanel(
                quantity: quantity,
                price: product.price,
                onPressedPlus: () => cubit.addProduct(product.id, 1),
                decrement: () => cubit.decrementQuantity(product.id),
                increment: () => cubit.incrementQuantity(product.id),
              ),
            ],
          ),
        );
      },
    );
  }
}
