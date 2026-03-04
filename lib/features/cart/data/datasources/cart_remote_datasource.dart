import 'package:dio/dio.dart';
import 'package:random_coffee/core/error/exceptions.dart';
import 'package:random_coffee/core/network/coffee_api_service.dart';
import 'package:random_coffee/features/cart/data/models/add_to_cart_request_model.dart';
import 'package:random_coffee/features/cart/data/models/cart_model.dart';
import 'package:random_coffee/features/cart/data/models/update_cart_item_request_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();

  Future<CartModel> addToCart(int productId, int quantity);

  Future<CartModel> updateCartItem(int productId, int quantity);

  Future<CartModel> removeFromCart(int productId);

  Future<CartModel> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final CoffeeApiService _apiService;

  CartRemoteDataSourceImpl(this._apiService);

  @override
  Future<CartModel> getCart() async {
    try {
      final result = await _apiService.getCart();
      return result;
    } on DioException catch (e) {
      throw ServerException(_getErrorMessage(e));
    } catch (e) {
      throw ServerException('Failed to load cart: $e');
    }
  }

  @override
  Future<CartModel> addToCart(int productId, int quantity) async {
    try {
      final request = AddToCartRequestModel(
        productId: productId,
        quantity: quantity,
      );
      return await _apiService.addToCart(request);
    } on DioException catch (e) {
      throw ServerException(_getErrorMessage(e));
    } catch (e) {
      throw ServerException('Failed to add product: $e');
    }
  }

  @override
  Future<CartModel> updateCartItem(int productId, int quantity) async {
    try {
      final request = UpdateCartItemRequestModel(quantity: quantity);
      return await _apiService.updateCartItem(productId, request);
    } on DioException catch (e) {
      throw ServerException(_getErrorMessage(e));
    } catch (e) {
      throw ServerException('Failed to update cart item: $e');
    }
  }

  @override
  Future<CartModel> removeFromCart(int productId) async {
    try {
      return await _apiService.removeFromCart(productId);
    } on DioException catch (e) {
      throw ServerException(_getErrorMessage(e));
    } catch (e) {
      throw ServerException('Failed to remove product: $e');
    }
  }

  @override
  Future<CartModel> clearCart() async {
    try {
      return await _apiService.clearCart();
    } on DioException catch (e) {
      throw ServerException(_getErrorMessage(e));
    } catch (e) {
      throw ServerException('Failed to clear cart: $e');
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
