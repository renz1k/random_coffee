import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/exceptions.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:random_coffee/features/orders/domain/entities/order.dart'
    as order_entity;
import 'package:random_coffee/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this._remoteDataSource);

  final OrdersRemoteDataSource _remoteDataSource;

  static const int _maxAttempts = 2;

  @override
  Future<Either<Failure, order_entity.Order>> createOrder() async {
    return _retryRequest<order_entity.Order>(() async {
      final orderModel = await _remoteDataSource.createOrder();
      return orderModel.toEntity();
    });
  }

  Future<Either<Failure, T>> _retryRequest<T>(
    Future<T> Function() request,
  ) async {
    int attempt = 0;

    while (attempt < _maxAttempts) {
      try {
        final result = await request();
        return Right(result);
      } on ServerException catch (e) {
        attempt++;

        if (attempt >= _maxAttempts) {
          return Left(ServerFailure(e.message));
        }

        await Future.delayed(Duration(seconds: attempt));
      }
    }

    return const Left(ServerFailure('Unknown error'));
  }
}
