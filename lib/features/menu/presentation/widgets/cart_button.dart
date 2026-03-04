import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_state.dart';
import 'package:random_coffee/features/cart/presentation/widgets/cart_bottom_sheet.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
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
          right: 16,
          child: GestureDetector(
            onTap: () => CartBottomSheet.show(context),
            child: Container(
              width: 105,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      weight: 40,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${state.cart.total}₽',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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
