import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/features/orders/domain/entities/order.dart'
    as order_entity;

abstract class OrdersRepository {
  Future<Either<Failure, order_entity.Order>> createOrder();
}

