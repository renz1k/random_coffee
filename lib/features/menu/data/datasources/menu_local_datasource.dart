import 'dart:convert';

import 'package:hive_ce/hive_ce.dart';
import 'package:random_coffee/core/utils/sync_logger.dart';
import 'package:random_coffee/features/menu/data/models/category_model.dart';
import 'package:random_coffee/features/menu/data/models/product_model.dart';

abstract class MenuLocalDataSource {
  Future<List<CategoryModel>> loadCategories();
  Future<void> saveCategories(List<CategoryModel> categories);

  Future<List<ProductModel>> loadProducts();
  Future<void> saveProducts(List<ProductModel> products);
}

class MenuLocalDataSourceImpl implements MenuLocalDataSource {
  static const String _categoriesBoxName = 'menu_cache';
  static const String _categoriesKey = 'categories_json';
  static const String _productsKey = 'products_json';

  @override
  Future<List<CategoryModel>> loadCategories() async {
    try {
      final box = await Hive.openBox(_categoriesBoxName);
      final jsonString = box.get(_categoriesKey) as String?;

      if (jsonString != null && jsonString.isNotEmpty) {
        final jsonList = jsonDecode(jsonString) as List<dynamic>;
        final categories = jsonList
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
        SyncLogger.logMenuLoad(true, categories.length, 0);
        return categories;
      }

      SyncLogger.logMenuLoad(true, 0, 0);
      return [];
    } catch (e) {
      SyncLogger.logNetworkError('Меню', 'Ошибка загрузки категорий: $e');
      return [];
    }
  }

  @override
  Future<void> saveCategories(List<CategoryModel> categories) async {
    try {
      final box = await Hive.openBox(_categoriesBoxName);
      final jsonString = jsonEncode(categories.map((c) => c.toJson()).toList());
      await box.put(_categoriesKey, jsonString);
      SyncLogger.logMenuSave(categories.length, 0);
    } catch (e) {
      SyncLogger.logMenuSave(categories.length, 0, error: e);
    }
  }

  @override
  Future<List<ProductModel>> loadProducts() async {
    try {
      final box = await Hive.openBox(_categoriesBoxName);
      final jsonString = box.get(_productsKey) as String?;

      if (jsonString != null && jsonString.isNotEmpty) {
        final jsonList = jsonDecode(jsonString) as List<dynamic>;
        final products = jsonList
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
        SyncLogger.logMenuLoad(true, 0, products.length);
        return products;
      }

      SyncLogger.logMenuLoad(true, 0, 0);
      return [];
    } catch (e) {
      SyncLogger.logNetworkError('Меню', 'Ошибка загрузки товаров: $e');
      return [];
    }
  }

  @override
  Future<void> saveProducts(List<ProductModel> products) async {
    try {
      final box = await Hive.openBox(_categoriesBoxName);
      final jsonString = jsonEncode(products.map((p) => p.toJson()).toList());
      await box.put(_productsKey, jsonString);
      SyncLogger.logMenuSave(0, products.length);
    } catch (e) {
      SyncLogger.logMenuSave(0, products.length, error: e);
    }
  }
}
