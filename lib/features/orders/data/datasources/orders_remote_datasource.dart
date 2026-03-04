import 'package:dio/dio.dart';
import 'package:random_coffee/core/error/exceptions.dart';
import 'package:random_coffee/core/network/coffee_api_service.dart';
import 'package:random_coffee/features/orders/data/models/create_order_response_model.dart';
import 'package:random_coffee/features/orders/data/models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<OrderModel> createOrder();
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl(this._apiService);

  final CoffeeApiService _apiService;

  @override
  Future<OrderModel> createOrder() async {
    try {
      final CreateOrderResponseModel response = await _apiService.createOrder();

      if (!response.success) {
        throw ServerException(response.message);
      }

      final order = response.order;
      if (order == null) {
        throw const ServerException('Не удалось получить заказ');
      }

      return order;
    } on DioException catch (e) {
      throw ServerException(_getErrorMessage(e));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to create order: $e');
    }
  }

  String _getErrorMessage(DioException e) {
    if (e.response?.statusCode == 404) {
      return e.response?.data['detail'] ?? 'Не найдено';
    }
    if (e.response?.statusCode == 400) {
      return e.response?.data['detail'] ?? 'Ошибка запроса';
    }
    return 'Ошибка сервера';
  }
}
