import 'dart:developer';

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
      _logError(e);
      throw const ServerException('Возникла ошибка при заказе');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw const ServerException('Возникла ошибка при заказе');
    }
  }

  void _logError(DioException e) {
    log('[ОШИБКА] Ошибка создания заказа:');
    log('[ОШИБКА] Тип: ${e.type}');
    log('[ОШИБКА] Сообщение: ${e.message}');
    if (e.response != null) {
      log('[ОШИБКА] Статус: ${e.response?.statusCode}');
      log('[ОШИБКА] Данные: ${e.response?.data}');
    }
  }
}

