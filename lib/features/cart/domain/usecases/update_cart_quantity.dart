import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/features/cart/domain/entities/cart.dart';
import 'package:random_coffee/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartQuantity {
  const UpdateCartQuantity(this.repository);

  final CartRepository repository;

  Future<Either<Failure, Cart>> call(int productId, int quantity) async {
    return await repository.updateQuantity(productId, quantity);
  }
}

