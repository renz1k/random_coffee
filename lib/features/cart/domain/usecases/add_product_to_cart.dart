import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/features/cart/domain/entities/cart.dart';
import 'package:random_coffee/features/cart/domain/repositories/cart_repository.dart';

class AddProductToCart {
  const AddProductToCart(this.repository);

  final CartRepository repository;

  Future<Either<Failure, Cart>> call(int productId, int quantity) async {
    return await repository.addProduct(productId, quantity);
  }
}
