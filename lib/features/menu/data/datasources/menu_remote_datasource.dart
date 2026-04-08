import 'package:random_coffee/core/error/exceptions.dart';
import 'package:random_coffee/core/network/coffee_api_service.dart';
import 'package:random_coffee/core/utils/sync_logger.dart';
import 'package:random_coffee/features/menu/data/models/category_model.dart';
import 'package:random_coffee/features/menu/data/models/product_model.dart';
import 'package:random_coffee/features/menu/domain/entities/category.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';

abstract class MenuRemoteDataSource {
  Future<List<Category>> getCategories();
  Future<List<Product>> getProducts();
  Future<List<CategoryModel>> getCategoriesModels();
  Future<List<ProductModel>> getProductsModels();
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  const MenuRemoteDataSourceImpl(this.apiService);

  final CoffeeApiService apiService;

  @override
  Future<List<Category>> getCategories() async {
    try {
      SyncLogger.logMenuSync(
        SyncState.loading,
        SyncSource.server,
        'Загрузка категорий',
      );
      final models = await apiService.getCategories();
      SyncLogger.logMenuSync(
        SyncState.success,
        SyncSource.server,
        'Категории загружены',
        itemCount: models.length,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      SyncLogger.logNetworkError('Меню', 'Ошибка загрузки категорий: $e');
      throw ServerException('Ошибка загрузки категорий: $e');
    }
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      SyncLogger.logMenuSync(
        SyncState.loading,
        SyncSource.server,
        'Загрузка товаров',
      );
      final models = await apiService.getProducts();
      SyncLogger.logMenuSync(
        SyncState.success,
        SyncSource.server,
        'Товары загружены',
        itemCount: models.length,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      SyncLogger.logNetworkError('Меню', 'Ошибка загрузки товаров: $e');
      throw ServerException('Ошибка загрузки товаров: $e');
    }
  }

  @override
  Future<List<CategoryModel>> getCategoriesModels() async {
    try {
      SyncLogger.logMenuSync(
        SyncState.loading,
        SyncSource.server,
        'Загрузка моделей категорий',
      );
      final models = await apiService.getCategories();
      SyncLogger.logMenuSync(
        SyncState.success,
        SyncSource.server,
        'Модели категорий загружены',
        itemCount: models.length,
      );
      return models;
    } catch (e) {
      SyncLogger.logNetworkError(
        'Меню',
        'Ошибка загрузки моделей категорий: $e',
      );
      throw ServerException('Ошибка загрузки категорий: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProductsModels() async {
    try {
      SyncLogger.logMenuSync(
        SyncState.loading,
        SyncSource.server,
        'Загрузка моделей товаров',
      );
      final models = await apiService.getProducts();
      SyncLogger.logMenuSync(
        SyncState.success,
        SyncSource.server,
        'Модели товаров загружены',
        itemCount: models.length,
      );
      return models;
    } catch (e) {
      SyncLogger.logNetworkError('Меню', 'Ошибка загрузки моделей товаров: $e');
      throw ServerException('Ошибка загрузки товаров: $e');
    }
  }
}
