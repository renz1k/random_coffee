import 'dart:developer' as dev;

/// Источник
enum SyncSource { local, server, error }

/// Текущее состояние
enum SyncState { initial, loading, success, failure }

class SyncLog {
  SyncLog({
    required this.timestamp,
    required this.feature,
    required this.state,
    required this.source,
    required this.message,
    this.itemCount,
    this.error,
  });

  final DateTime timestamp;
  final String feature; // 'cart', 'menu'
  final SyncState state;
  final SyncSource source;
  final String message;
  final int? itemCount;
  final Object? error;

  @override
  String toString() {
    final status = switch (state) {
      SyncState.initial => '[НАЧАЛО]',
      SyncState.loading => '[ЗАГРУЗКА]',
      SyncState.success => '[ОК]',
      SyncState.failure => '[ОШИБКА]',
    };

    final itemInfo = itemCount != null ? ' ($itemCount элементов)' : '';
    return '$status [$timestamp] $feature: $message$itemInfo';
  }

  void log() {
    dev.log(toString());
  }
}

class SyncLogger {
  static const String _tag = '[СИНХРО]';

  static void logCartSync(
    SyncState state,
    SyncSource source,
    String message, {
    int? itemCount,
    Object? error,
  }) {
    SyncLog(
      timestamp: DateTime.now(),
      feature: 'Корзина',
      state: state,
      source: source,
      message: message,
      itemCount: itemCount,
      error: error,
    ).log();
  }

  static void logMenuSync(
    SyncState state,
    SyncSource source,
    String message, {
    int? itemCount,
    Object? error,
  }) {
    SyncLog(
      timestamp: DateTime.now(),
      feature: 'Меню',
      state: state,
      source: source,
      message: message,
      itemCount: itemCount,
      error: error,
    ).log();
  }

  static void logCartLoad(bool fromLocal, int itemCount) {
    final source = fromLocal ? 'локально' : 'с сервера';
    dev.log('$_tag Корзина загружена $source: $itemCount элементов');
  }

  static void logCartSave(int itemCount, {Object? error}) {
    if (error != null) {
      dev.log('$_tag Ошибка при сохранении корзины: $error');
    } else {
      dev.log('$_tag Корзина сохранена: $itemCount элементов');
    }
  }

  static void logMenuLoad(bool fromLocal, int categories, int products) {
    final source = fromLocal ? 'локально' : 'с сервера';
    dev.log(
      '$_tag Меню загружено $source: $categories категорий, $products блюд',
    );
  }

  static void logMenuSave(int categories, int products, {Object? error}) {
    if (error != null) {
      dev.log('$_tag Ошибка при сохранении меню: $error');
    } else {
      dev.log('$_tag Меню сохранено: $categories категорий, $products блюд');
    }
  }

  static void logSyncConflict(String feature, String description) {
    dev.log('$_tag КОНФЛИКТ синхро в $feature: $description');
  }

  static void logNetworkError(String feature, Object error) {
    dev.log('$_tag Ошибка сети в $feature: $error');
  }

  static void logOfflineMode(String feature) {
    dev.log('$_tag Режим оффлайн активирован для $feature');
  }
}
