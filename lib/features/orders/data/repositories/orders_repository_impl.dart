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

  @override
  Future<Either<Failure, order_entity.Order>> createOrder() async {
    try {
      final orderModel = await _remoteDataSource.createOrder();
      return Right(orderModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Неизвестная ошибка'));
    }
  }
}
