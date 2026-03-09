import 'package:equatable/equatable.dart';
import 'package:random_coffee/features/cart/domain/entities/cart.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];
}

class CartError extends CartState {
  final Object error;

  const CartError(this.error);

  @override
  List<Object?> get props => [error];
}

