import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/cart/domain/entities/cart_item.dart';
import 'package:random_coffee/features/cart/presentation/widgets/cart_product_image.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
      ),
      child: SizedBox(
        height: AppConstants.cartItemHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CartProductImage(imageUrl: item.product.imageUrl),

            const SizedBox(width: AppConstants.paddingMedium),

            Expanded(
              child: Text(
                item.product.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: isLight
                      ? AppColors.textLightPrimary
                      : AppColors.textDarkSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: AppConstants.paddingMedium),

            Text(
              '${item.product.price} ₽',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isLight
                    ? AppColors.textLightPrimary
                    : AppColors.textDarkSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
