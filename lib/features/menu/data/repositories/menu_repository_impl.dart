import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/exceptions.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/core/utils/sync_logger.dart';
import 'package:random_coffee/features/menu/data/datasources/menu_local_datasource.dart';
import 'package:random_coffee/features/menu/data/datasources/menu_remote_datasource.dart';
import 'package:random_coffee/features/menu/domain/entities/category.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';
import 'package:random_coffee/features/menu/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  MenuRepositoryImpl(this.remoteDataSource, this.localDataSource);

  final MenuRemoteDataSource remoteDataSource;
  final MenuLocalDataSource localDataSource;

  static const int _maxAttempts = 2;

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    int attempt = 0;

    while (attempt < _maxAttempts) {
      try {
        // Загружаем сырые модели с API
        final categoryModels = await remoteDataSource.getCategoriesModels();

        // Сохраняем модели в локальное хранилище
        await localDataSource.saveCategories(categoryModels);

        final categories = categoryModels
            .map((model) => model.toEntity())
            .toList();
        SyncLogger.logMenuSync(
          SyncState.success,
          SyncSource.server,
          'Категории загружены и сохранены',
          itemCount: categories.length,
        );
        return Right(categories);
      } on ServerException catch (e) {
        attempt++;

        if (attempt >= _maxAttempts) {
          SyncLogger.logMenuSync(
            SyncState.loading,
            SyncSource.local,
            'Не удалось загрузить категории с сервера, загружаю из кеша',
          );
          final cached = await localDataSource.loadCategories();
          if (cached.isNotEmpty) {
            final entities = cached.map((model) => model.toEntity()).toList();
            SyncLogger.logMenuSync(
              SyncState.success,
              SyncSource.local,
              'Загружено из кеша',
              itemCount: entities.length,
            );
            return Right(entities);
          }
          SyncLogger.logMenuSync(
            SyncState.failure,
            SyncSource.local,
            'Нет сохраненных категорий',
            error: e,
          );
          return Left(ServerFailure(e.message));
        }

        await Future.delayed(Duration(seconds: attempt));
      }
    }

    return const Left(ServerFailure('Неизвестная ошибка'));
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    int attempt = 0;

    while (attempt < _maxAttempts) {
      try {
        // Загружаем сырые модели с API
        final productModels = await remoteDataSource.getProductsModels();

        // Сохраняем модели в локальное хранилище
        await localDataSource.saveProducts(productModels);

        final products = productModels
            .map((model) => model.toEntity())
            .toList();
        SyncLogger.logMenuSync(
          SyncState.success,
          SyncSource.server,
          'Товары загружены и сохранены',
          itemCount: products.length,
        );
        return Right(products);
      } on ServerException catch (e) {
        attempt++;

        if (attempt >= _maxAttempts) {
          SyncLogger.logMenuSync(
            SyncState.loading,
            SyncSource.local,
            'Не удалось загрузить товары с сервера, загружаю из кеша',
          );
          final cached = await localDataSource.loadProducts();
          if (cached.isNotEmpty) {
            final entities = cached.map((model) => model.toEntity()).toList();
            SyncLogger.logMenuSync(
              SyncState.success,
              SyncSource.local,
              'Загружено из кеша',
              itemCount: entities.length,
            );
            return Right(entities);
          }
          SyncLogger.logMenuSync(
            SyncState.failure,
            SyncSource.local,
            'Нет сохраненных товаров',
            error: e,
          );
          return Left(ServerFailure(e.message));
        }

        await Future.delayed(Duration(seconds: attempt));
      }
    }

    return const Left(ServerFailure('Неизвестная ошибка'));
  }

  @override
  Future<Either<Failure, List<Category>>> getCategoriesLocal() async {
    try {
      final categories = await localDataSource.loadCategories();
      if (categories.isNotEmpty) {
        final entities = categories.map((model) => model.toEntity()).toList();
        SyncLogger.logMenuLoad(true, entities.length, 0);
        return Right(entities);
      }
      log('[ОШИБКА] Нет категорий в локальном кеше');
      return const Right([]);
    } catch (e) {
      log('[ОШИБКА] Ошибка загрузки категорий из локального кеша: $e');
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsLocal() async {
    try {
      final products = await localDataSource.loadProducts();
      if (products.isNotEmpty) {
        final entities = products.map((model) => model.toEntity()).toList();
        SyncLogger.logMenuLoad(true, 0, entities.length);
        return Right(entities);
      }
      log('[ОШИБКА] Нет товаров в локальном кеше');
      return const Right([]);
    } catch (e) {
      log('[ОШИБКА] Ошибка загрузки товаров из локального кеша: $e');
      return const Right([]);
    }
  }
}
