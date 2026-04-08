import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/cart/domain/entities/cart.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_state.dart';
import 'package:random_coffee/features/cart/presentation/widgets/cart_content.dart';
import 'package:random_coffee/features/cart/presentation/widgets/cart_header.dart';
import 'package:random_coffee/features/cart/presentation/widgets/handle_widget.dart';
import 'package:random_coffee/features/orders/presentation/cubit/order_cubit.dart';
import 'package:random_coffee/features/orders/presentation/cubit/order_state.dart';
import 'package:random_coffee/features/orders/presentation/widgets/order_snackbar.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CartBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.88;
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderError) {
          OrderSnackBar.showError(context, state.message);
          return;
        }

        if (state is OrderSuccess) {
          _onOrderSuccess(context);
        }
      },

      child: SizedBox(
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: isLight
                ? theme.colorScheme.surface
                : AppColors.textLightPrimary,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusExtraLarge),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: AppConstants.paddingMedium),

              HandleWidget(),

              const SizedBox(height: AppConstants.paddingMedium),

              CartHeader(onClearPressed: () => _handleClear(context)),

              const SizedBox(height: AppConstants.paddingExtraLarge),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                ),
                child: Divider(
                  height: 1,
                  color: isLight
                      ? AppColors.dividerLight
                      : AppColors.dividerDark,
                ),
              ),

              Expanded(
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    if (state is CartLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CartError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(
                            AppConstants.paddingMedium,
                          ),
                          child: Text(
                            state.error.toString(),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    if (state is CartLoaded) {
                      if (state.cart.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(AppConstants.paddingHuge),
                            child: Text(
                              'Корзина пуста',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: isLight
                                    ? AppColors.textLightPrimary
                                    : AppColors.textDarkSecondary,
                              ),
                            ),
                          ),
                        );
                      }

                      return CartContent(
                        state: state,
                        onCreateOrder: () => _handleCreateOrder(context),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onOrderSuccess(BuildContext context) {
    context.read<CartCubit>().loadCart();
    Navigator.pop(context);
    OrderSnackBar.showSuccess(context);
    context.read<OrderCubit>().reset();
  }

  Future<void> _handleClear(BuildContext context) async {
    final cubit = context.read<CartCubit>();

    final currentState = cubit.state;
    Cart? cartBeforeClear;
    if (currentState is CartLoaded) {
      cartBeforeClear = currentState.cart;
    }

    await cubit.clearCart();

    if (!context.mounted) return;

    final resultState = cubit.state;
    if (resultState is CartLoaded && resultState.cart.isEmpty) {
      Navigator.pop(context);
    } else if (resultState is CartLoaded &&
        cartBeforeClear != null &&
        resultState.cart.items.length == cartBeforeClear.items.length) {
      Navigator.pop(context);
      if (context.mounted) {
        OrderSnackBar.showError(
          context,
          'Ошибка при очистке корзины. Проверьте интернет и попробуйте снова.',
        );
      }
    }
  }

  Future<void> _handleCreateOrder(BuildContext context) async {
    await context.read<OrderCubit>().submitOrder();
  }
}
