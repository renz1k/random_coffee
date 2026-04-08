import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_state.dart';
import 'package:random_coffee/features/cart/presentation/widgets/cart_bottom_sheet.dart';
import 'package:random_coffee/uikit/icons/app_icon.dart';
import 'package:random_coffee/uikit/icons/app_icons.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final isEmpty = state is! CartLoaded || state.cart.isEmpty;

        if (isEmpty) {
          return const Positioned(
            bottom: 0,
            right: 16,
            child: SizedBox.shrink(),
          );
        }

        return Positioned(
          bottom: 0,
          right: AppConstants.paddingMedium,
          child: GestureDetector(
            onTap: () => CartBottomSheet.show(context),
            child: Container(
              width: AppConstants.cartButtonWidth,
              height: AppConstants.cartButtonHeight,
              decoration: BoxDecoration(
                color: isLight ? AppColors.primaryLight : AppColors.primaryDark,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppConstants.paddingMedium,
                ),
                child: Row(
                  children: [
                    const AppIcon(
                      AppIcons.cart,
                      color: Colors.white,
                      size: AppConstants.iconSizeSmall,
                    ),

                    const SizedBox(width: AppConstants.paddingSmall),

                    Text(
                      '${state.cart.total}₽',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
