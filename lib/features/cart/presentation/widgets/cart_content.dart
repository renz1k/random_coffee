import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/cart/domain/entities/cart_item.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_state.dart';
import 'package:random_coffee/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class CartContent extends StatelessWidget {
  const CartContent({
    super.key,
    required this.state,
    required this.onCreateOrder,
  });

  final CartLoaded state;
  final VoidCallback onCreateOrder;

  List<CartItem> _flattenItems(List<CartItem> items) {
    return items
        .expand((item) => List.generate(item.quantity, (_) => item))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final items = _flattenItems(state.cart.items);

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              0,
              AppConstants.paddingExtraLarge,
              0,
              0,
            ),
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppConstants.paddingSmall),
            itemBuilder: (context, index) {
              return CartItemWidget(item: items[index]);
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
          child: Divider(
            height: 1,
            color: isLight ? AppColors.dividerLight : AppColors.dividerDark,
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.paddingMedium,
            AppConstants.paddingMedium,
            AppConstants.paddingMedium,
            AppConstants.cartBottomSpacing,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Итого',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: isLight
                      ? AppColors.textLightPrimary
                      : AppColors.textDarkSecondary,
                ),
              ),

              Text(
                '${state.cart.total} ₽',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isLight
                      ? AppColors.textLightPrimary
                      : AppColors.textDarkSecondary,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.paddingMedium,
            0,
            AppConstants.paddingMedium,
            AppConstants.paddingMedium,
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: AppConstants.buttonHeightLarge,
              child: ElevatedButton(
                onPressed: onCreateOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLight
                      ? AppColors.primaryLight
                      : AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusButton,
                    ),
                  ),
                ),

                child: Text(
                  'Оформить заказ',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
