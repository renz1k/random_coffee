import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/exceptions.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/core/utils/sync_logger.dart';
import 'package:random_coffee/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:random_coffee/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:random_coffee/features/cart/domain/entities/cart.dart';
import 'package:random_coffee/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;
  final CartLocalDataSource _localDataSource;

  CartRepositoryImpl(this._remoteDataSource, this._localDataSource);

  static const int _maxAttempts = 2;

  @override
  Future<Either<Failure, Cart>> getCart() async {
    return _retryRequest<Cart>(() async {
      final cartModel = await _remoteDataSource.getCart();
      // Сохраняем полученные данные в локальное хранилище
      await _localDataSource.saveCart(cartModel);
      return cartModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, Cart>> addProduct(int productId, int quantity) async {
    // Проверка лимита quantity
    if (quantity < 1 || quantity > 10) {
      return Left(ValidationFailure('Количество должно быть от 1 до 10'));
    }

    return _retryRequest<Cart>(() async {
      final cartModel = await _remoteDataSource.addToCart(productId, quantity);
      // Сохраняем в локальное хранилище
      await _localDataSource.saveCart(cartModel);
      return cartModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, Cart>> updateQuantity(
    int productId,
    int quantity,
  ) async {
    // Проверка лимита quantity
    if (quantity < 0 || quantity > 10) {
      return Left(ValidationFailure('Количество должно быть от 0 до 10'));
    }

    // Если quantity < 1, удаляем товар
    if (quantity < 1) {
      return await removeProduct(productId);
    }

    return _retryRequest<Cart>(() async {
      final cartModel = await _remoteDataSource.updateCartItem(
        productId,
        quantity,
      );
      // Сохраняем в локальное хранилище
      await _localDataSource.saveCart(cartModel);
      return cartModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, Cart>> removeProduct(int productId) async {
    return _retryRequest<Cart>(() async {
      final cartModel = await _remoteDataSource.removeFromCart(productId);
      // Сохраняем в локальное хранилище
      await _localDataSource.saveCart(cartModel);
      return cartModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, Cart>> clearCart() async {
    return _retryRequest<Cart>(() async {
      final cartModel = await _remoteDataSource.clearCart();
      // Сохраняем в локальное хранилище
      await _localDataSource.saveCart(cartModel);
      return cartModel.toEntity();
    });
  }

  /// Загружает корзину из локального хранилища
  @override
  Future<Either<Failure, Cart>> loadCartLocal() async {
    try {
      final cartModel = await _localDataSource.loadCart();
      if (cartModel != null) {
        SyncLogger.logCartSync(
          SyncState.success,
          SyncSource.local,
          'Корзина загружена из локального хранилища',
          itemCount: cartModel.items.length,
        );
        return Right(cartModel.toEntity());
      }
      log('[ПРЕДУПРЕЖДЕНИЕ] Нет корзины в локальном хранилище, возвращаю пустую');
      return const Right(Cart());
    } catch (e) {
      SyncLogger.logCartSync(
        SyncState.failure,
        SyncSource.local,
        'Ошибка загрузки корзины из локального хранилища',
        error: e,
      );
      return const Right(Cart()); // Возвращаем пустую корзину как fallback
    }
  }

  /// Очищает корзину из локального хранилища
  Future<void> clearCartLocal() async {
    await _localDataSource.clearCart();
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

    return const Left(ServerFailure('Неизвестная ошибка'));
  }
}

