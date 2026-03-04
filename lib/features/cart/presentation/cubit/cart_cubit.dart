import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/features/cart/domain/entities/cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/add_product_to_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/clear_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/get_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/remove_cart_product.dart';
import 'package:random_coffee/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCart _getCart;
  final AddProductToCart _addProductToCart;
  final UpdateCartQuantity _updateCartQuantity;
  final RemoveCartProduct _removeCartProduct;
  final ClearCart _clearCart;

  CartCubit(
    this._getCart,
    this._addProductToCart,
    this._updateCartQuantity,
    this._removeCartProduct,
    this._clearCart,
  ) : super(const CartInitial());

  Cart? _currentCart;

  Cart? get currentCart => _currentCart;

  Future<void> loadCart() async {
    emit(const CartLoading());

    final result = await _getCart();

    result.fold((failure) => emit(CartError(failure)), (cart) {
      _currentCart = cart;
      emit(CartLoaded(cart));
    });
  }

  Future<void> addProduct(int productId, int quantity) async {
    // Проверка лимита
    if (quantity < 1 || quantity > 10) {
      emit(const CartError('Количество должно быть от 1 до 10'));
      return;
    }

    final result = await _addProductToCart(productId, quantity);

    result.fold((failure) => emit(CartError(failure)), (cart) {
      _currentCart = cart;
      emit(CartLoaded(cart));
    });
  }

  Future<void> incrementQuantity(int productId) async {
    if (_currentCart == null) return;

    // Найти текущее количество
    final currentItemIndex = _currentCart!.items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (currentItemIndex == -1) return;

    final currentItem = _currentCart!.items[currentItemIndex];
    final newQuantity = currentItem.quantity + 1;

    // Проверка лимита
    if (newQuantity > 10) {
      emit(const CartError('Максимальное количество - 10'));
      // Восстанавливаем предыдущее состояние
      if (_currentCart != null) {
        emit(CartLoaded(_currentCart!));
      }
      return;
    }

    await updateQuantity(productId, newQuantity);
  }

  Future<void> decrementQuantity(int productId) async {
    if (_currentCart == null) return;

    // Найти текущее количество
    final currentItemIndex = _currentCart!.items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (currentItemIndex == -1) return;

    final currentItem = _currentCart!.items[currentItemIndex];
    final newQuantity = currentItem.quantity - 1;

    // Если меньше 1 - удаляем
    if (newQuantity < 1) {
      await removeProduct(productId);
      return;
    }

    await updateQuantity(productId, newQuantity);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final result = await _updateCartQuantity(productId, quantity);

    result.fold((failure) => emit(CartError(failure)), (cart) {
      _currentCart = cart;
      emit(CartLoaded(cart));
    });
  }

  Future<void> removeProduct(int productId) async {
    final result = await _removeCartProduct(productId);

    result.fold((failure) => emit(CartError(failure)), (cart) {
      _currentCart = cart;
      emit(CartLoaded(cart));
    });
  }

  Future<void> clearCart() async {
    final result = await _clearCart();

    result.fold((failure) => emit(CartError(failure)), (cart) {
      _currentCart = cart;
      emit(CartLoaded(cart));
    });
  }

  int getProductQuantity(int productId) {
    if (_currentCart == null) return 0;

    final itemIndex = _currentCart!.items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (itemIndex == -1) return 0;

    return _currentCart!.items[itemIndex].quantity;
  }

  bool isProductInCart(int productId) {
    if (_currentCart == null) return false;

    return _currentCart!.items.any((item) => item.product.id == productId);
  }
}
