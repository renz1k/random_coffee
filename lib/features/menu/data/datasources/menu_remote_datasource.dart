import 'package:random_coffee/core/error/exceptions.dart';
import 'package:random_coffee/core/network/coffee_api_service.dart';
import 'package:random_coffee/features/menu/domain/entities/category.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';

abstract class MenuRemoteDataSource {
  Future<List<Category>> getCategories();
  Future<List<Product>> getProducts();
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  const MenuRemoteDataSourceImpl(this.apiService);

  final CoffeeApiService apiService;

  @override
  Future<List<Category>> getCategories() async {
    try {
      final models = await apiService.getCategories();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw ServerException('Failed to load categories: $e');
    }
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await apiService.getProducts();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw ServerException('Failed to load products: $e');
    }
  }
}
