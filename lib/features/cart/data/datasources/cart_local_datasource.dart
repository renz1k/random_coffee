import 'dart:developer';

import 'package:hive_ce/hive_ce.dart';
import 'package:random_coffee/core/utils/sync_logger.dart';
import 'package:random_coffee/features/cart/data/models/cart_model.dart';

abstract class CartLocalDataSource {
  Future<CartModel?> loadCart();
  Future<void> saveCart(CartModel cart);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _boxName = 'cart';
  static const String _cartKey = 'cart_data';

  @override
  Future<CartModel?> loadCart() async {
    try {
      final box = await Hive.openBox<CartModel>(_boxName);
      final cart = box.get(_cartKey);
      if (cart != null) {
        SyncLogger.logCartLoad(true, cart.items.length);
      } else {
        log('[ПРЕДУПРЕЖДЕНИЕ] В локальном хранилище не найдена корзина (null)');
      }
      return cart;
    } catch (e, stackTrace) {
      SyncLogger.logCartSync(
        SyncState.failure,
        SyncSource.local,
        'Ошибка загрузки корзины',
        error: e,
      );
      log('[ТРАССИРОВКА] Stack trace: $stackTrace');
      return null;
    }
  }

  @override
  Future<void> saveCart(CartModel cart) async {
    try {
      final box = await Hive.openBox<CartModel>(_boxName);
      await box.put(_cartKey, cart);
      SyncLogger.logCartSave(cart.items.length);

      // Проверяем что сохранилось
      final saved = box.get(_cartKey);
      if (saved != null) {
        log('[ОК] Проверка: в хранилище ${saved.items.length} позиций');
      } else {
        log('[ПРЕДУПРЕЖДЕНИЕ] Внимание: корзина пустая после сохранения!');
      }
    } catch (e, stackTrace) {
      SyncLogger.logCartSave(cart.items.length, error: e);
      log('[ТРАССИРОВКА] Stack trace: $stackTrace');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final box = await Hive.openBox<CartModel>(_boxName);
      await box.delete(_cartKey);
      SyncLogger.logCartSync(
        SyncState.success,
        SyncSource.local,
        'Корзина очищена из локального хранилища',
      );
    } catch (e) {
      SyncLogger.logCartSync(
        SyncState.failure,
        SyncSource.local,
        'Ошибка очистки корзины',
        error: e,
      );
    }
  }
}

