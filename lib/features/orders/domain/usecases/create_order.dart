import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/features/orders/domain/entities/order.dart'
    as order_entity;
import 'package:random_coffee/features/orders/domain/repositories/orders_repository.dart';

class CreateOrder {
  const CreateOrder(this.repository);

  final OrdersRepository repository;

  Future<Either<Failure, order_entity.Order>> call() async {
    return repository.createOrder();
  }
}
