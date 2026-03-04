import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_state.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';
import 'package:random_coffee/features/menu/presentation/pages/product_details_page.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_bottom_panel.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_image.dart';
import 'package:random_coffee/features/menu/presentation/widgets/product_local_image_placeholder.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        final quantity = cubit.getProductQuantity(product.id);

        return Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),

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
                  placeholder: const ProductLocalImagePlaceholder(),
                  height: 100,
                  color: Colors.white,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 8),

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
