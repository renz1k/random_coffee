import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/features/cart/domain/entities/cart_item.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_state.dart';
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

    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderError) {
          OrderSnackBar.showError(context, state.message);
          return;
        }

        if (state is OrderSuccess) {
          Navigator.pop(context);
          OrderSnackBar.showSuccess(context);
          context.read<OrderCubit>().reset();
        }
      },
      child: SizedBox(
        height: height,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildHandle(),
              const SizedBox(height: 16),
              _buildHeader(context),
              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.grey.shade200),
              Expanded(
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    if (state is CartLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CartError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            state.error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }

                    if (state is CartLoaded) {
                      if (state.cart.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              'Корзина пуста',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }

                      return _buildCartContent(context, state);
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

  Widget _buildHandle() {
    return Container(
      width: 32,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Ваш заказ',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _handleClear(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartLoaded state) {
    final items = _flattenItems(state.cart.items);

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _buildCartItem(items[index]);
            },
          ),
        ),
        const SizedBox(height: 24),
        Divider(height: 1, color: Colors.grey.shade200),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Итого',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                '${state.cart.total} ₽',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _handleCreateOrder(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Оформить заказ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<CartItem> _flattenItems(List<CartItem> items) {
    return items
        .expand((item) => List.generate(item.quantity, (_) => item))
        .toList();
  }

  Widget _buildCartItem(CartItem item) {
    final imageUrl = item.product.imageUrl.replaceFirst('https://', 'http://');

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 55,
            height: 55,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 55,
                height: 55,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            item.product.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${item.product.price} ₽',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Future<void> _handleClear(BuildContext context) async {
    final cubit = context.read<CartCubit>();
    await cubit.clearCart();
    if (!context.mounted) return;
    Navigator.pop(context);
  }

  Future<void> _handleCreateOrder(BuildContext context) async {
    await context.read<OrderCubit>().submitOrder();
  }
}
