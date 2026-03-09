import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/features/cart/domain/entities/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();

  Future<Either<Failure, Cart>> loadCartLocal();

  Future<Either<Failure, Cart>> addProduct(int productId, int quantity);

  Future<Either<Failure, Cart>> updateQuantity(int productId, int quantity);

  Future<Either<Failure, Cart>> removeProduct(int productId);

  Future<Either<Failure, Cart>> clearCart();
}

