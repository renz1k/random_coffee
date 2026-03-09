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
      return await _apiService.getCart();
    } catch (e) {
      throw ServerException('[ОШИБКА] Ошибка получения корзины: $e');
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
    } catch (e) {
      throw ServerException('[ОШИБКА] Ошибка добавления в корзину: $e');
    }
  }

  @override
  Future<CartModel> updateCartItem(int productId, int quantity) async {
    try {
      final request = UpdateCartItemRequestModel(quantity: quantity);
      return await _apiService.updateCartItem(productId, request);
    } catch (e) {
      throw ServerException('[ОШИБКА] Ошибка обновления товара: $e');
    }
  }

  @override
  Future<CartModel> removeFromCart(int productId) async {
    try {
      return await _apiService.removeFromCart(productId);
    } catch (e) {
      throw ServerException('[ОШИБКА] Ошибка удаления из корзины: $e');
    }
  }

  @override
  Future<CartModel> clearCart() async {
    try {
      return await _apiService.clearCart();
    } catch (e) {
      throw ServerException('[ОШИБКА] Ошибка очистки корзины: $e');
    }
  }
}
