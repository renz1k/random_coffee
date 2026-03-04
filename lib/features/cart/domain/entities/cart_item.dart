import 'package:equatable/equatable.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';

class CartItem extends Equatable {
  const CartItem({
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  final Product product;
  final int quantity;
  final int totalPrice;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      totalPrice:
          (product?.price ?? this.product.price) * (quantity ?? this.quantity),
    );
  }

  @override
  List<Object?> get props => [product, quantity, totalPrice];
}
