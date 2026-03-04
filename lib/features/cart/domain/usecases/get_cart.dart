import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/features/cart/domain/entities/cart.dart';
import 'package:random_coffee/features/cart/domain/repositories/cart_repository.dart';

class GetCart {
  const GetCart(this.repository);

  final CartRepository repository;

  Future<Either<Failure, Cart>> call() async {
    return await repository.getCart();
  }
}
