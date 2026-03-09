import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/core/utils/sync_logger.dart';
import 'package:random_coffee/features/cart/domain/entities/cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/add_product_to_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/clear_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/get_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/get_cart_local.dart';
import 'package:random_coffee/features/cart/domain/usecases/remove_cart_product.dart';
import 'package:random_coffee/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCart _getCart;
  final AddProductToCart _addProductToCart;
  final UpdateCartQuantity _updateCartQuantity;
  final RemoveCartProduct _removeCartProduct;
  final ClearCart _clearCart;
  final GetCartLocal _getCartLocal;

  CartCubit(
    this._getCart,
    this._addProductToCart,
    this._updateCartQuantity,
    this._removeCartProduct,
    this._clearCart,
    this._getCartLocal,
  ) : super(const CartInitial());

  Cart? _currentCart;

  Cart? get currentCart => _currentCart;

  Future<void> loadCart() async {
    final previousCart = _currentCart; // Сохраняем текущую корзину
    emit(const CartLoading());

    final result = await _getCart();

    result.fold(
      (failure) {
        SyncLogger.logCartSync(
          SyncState.failure,
          SyncSource.server,
          'Не удалось загрузить с сервера, используем локальную',
          error: failure,
        );
        // При ошибке загрузки с сервера, восстанавливаем предыдущую корзину
        if (previousCart != null) {
          emit(CartLoaded(previousCart));
        } else {
          // Если предыдущей корзины нет, пытаемся загрузить из локального хранилища
          _loadCartFromLocal();
        }
      },
      (cart) {
        _currentCart = cart;
        emit(CartLoaded(cart));
      },
    );
  }

  /// Загружает корзину из локального хранилища
  Future<void> _loadCartFromLocal() async {
    final localResult = await _getCartLocal();
    localResult.fold(
      (failure) {
        emit(const CartLoaded(Cart())); // Пустая корзина
      },
      (cart) {
        _currentCart = cart;
        emit(CartLoaded(cart));
      },
    );
  }

  /// Загружает корзину из локального хранилища при старте приложения
  Future<void> initializeCart() async {
    SyncLogger.logCartSync(
      SyncState.loading,
      SyncSource.local,
      'Инициализация корзины из локального хранилища',
    );

    // Сначала загружаем локальную версию
    final localResult = await _getCartLocal();

    localResult.fold(
      (failure) {
        SyncLogger.logCartSync(
          SyncState.failure,
          SyncSource.local,
          'Не удалось загрузить из локального хранилища, начинаем с пустой',
          error: failure,
        );
        _currentCart = const Cart();
        emit(const CartLoaded(Cart()));
        SyncLogger.logCartSync(
          SyncState.success,
          SyncSource.local,
          'Отправлена пустая корзина',
        );
      },
      (cart) {
        _currentCart = cart;
        emit(CartLoaded(cart));
        SyncLogger.logCartSync(
          SyncState.success,
          SyncSource.local,
          'Отправлена корзина с позициями',
          itemCount: cart.items.length,
        );
      },
    );

    // Потом пытаемся обновить с сервера в фоне
    _syncCartWithServer();
  }

  /// Синхронизирует корзину с сервером в фоне
  Future<void> _syncCartWithServer() async {
    try {
      SyncLogger.logCartSync(
        SyncState.loading,
        SyncSource.server,
        'Синхронизация корзины с сервером',
      );
      final result = await _getCart();

      result.fold(
        (failure) {
          SyncLogger.logCartSync(
            SyncState.failure,
            SyncSource.server,
            'Ошибка синхронизации, используем локальную',
            error: failure,
          );
        },
        (cart) {
          SyncLogger.logCartSync(
            SyncState.success,
            SyncSource.server,
            'Корзина получена с сервера',
            itemCount: cart.items.length,
          );
          if (_currentCart != cart) {
            SyncLogger.logCartSync(
              SyncState.success,
              SyncSource.server,
              'Корзина обновлена (отличается от локальной)',
              itemCount: cart.items.length,
            );
            _currentCart = cart;
            emit(CartLoaded(cart));
            SyncLogger.logCartSync(
              SyncState.success,
              SyncSource.server,
              'Отправлена обновленная корзина',
              itemCount: cart.items.length,
            );
          } else {
            SyncLogger.logCartSync(
              SyncState.success,
              SyncSource.server,
              'Корзина уже актуальна с сервером',
              itemCount: cart.items.length,
            );
          }
        },
      );
    } catch (e) {
      SyncLogger.logCartSync(
        SyncState.failure,
        SyncSource.server,
        'Ошибка при синхронизации корзины',
        error: e,
      );
    }
  }

  Future<void> addProduct(int productId, int quantity) async {
    // Проверка лимита
    if (quantity < 1 || quantity > 10) {
      emit(const CartError('Количество должно быть от 1 до 10'));
      return;
    }

    final previousCart = _currentCart;
    final result = await _addProductToCart(productId, quantity);

    result.fold(
      (failure) {
        if (previousCart != null) {
          emit(CartLoaded(previousCart));
        } else {
          emit(CartError(failure));
        }
      },
      (cart) {
        _currentCart = cart;
        emit(CartLoaded(cart));
      },
    );
  }

  Future<void> incrementQuantity(int productId) async {
    if (_currentCart == null) return;

    final currentItemIndex = _currentCart!.items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (currentItemIndex == -1) return;

    final currentItem = _currentCart!.items[currentItemIndex];
    final newQuantity = currentItem.quantity + 1;

    if (newQuantity > 10) {
      emit(const CartError('Максимальное количество - 10'));
      if (_currentCart != null) {
        emit(CartLoaded(_currentCart!));
      }
      return;
    }

    await updateQuantity(productId, newQuantity);
  }

  Future<void> decrementQuantity(int productId) async {
    if (_currentCart == null) return;

    final currentItemIndex = _currentCart!.items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (currentItemIndex == -1) return;

    final currentItem = _currentCart!.items[currentItemIndex];
    final newQuantity = currentItem.quantity - 1;

    if (newQuantity < 1) {
      await removeProduct(productId);
      return;
    }

    await updateQuantity(productId, newQuantity);
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    final previousCart = _currentCart;
    final result = await _updateCartQuantity(productId, quantity);

    result.fold(
      (failure) {
        if (previousCart != null) {
          emit(CartLoaded(previousCart));
        } else {
          emit(CartError(failure));
        }
      },
      (cart) {
        _currentCart = cart;
        emit(CartLoaded(cart));
      },
    );
  }

  Future<void> removeProduct(int productId) async {
    final previousCart = _currentCart;
    final result = await _removeCartProduct(productId);

    result.fold(
      (failure) {
        if (previousCart != null) {
          emit(CartLoaded(previousCart));
        } else {
          emit(CartError(failure));
        }
      },
      (cart) {
        _currentCart = cart;
        emit(CartLoaded(cart));
      },
    );
  }

  Future<void> clearCart() async {
    final previousCart = _currentCart;
    final result = await _clearCart();

    result.fold(
      (failure) {
        if (previousCart != null) {
          emit(CartLoaded(previousCart));
        }
      },
      (cart) {
        _currentCart = cart;
        emit(CartLoaded(cart));
      },
    );
  }

  int getProductQuantity(int productId) {
    if (_currentCart == null) return 0;

    final itemIndex = _currentCart!.items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (itemIndex == -1) return 0;

    return _currentCart!.items[itemIndex].quantity;
  }
}
