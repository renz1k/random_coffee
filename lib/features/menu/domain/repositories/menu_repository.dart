import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/features/menu/domain/entities/category.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';

abstract class MenuRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Product>>> getProducts();

  // Local
  Future<Either<Failure, List<Category>>> getCategoriesLocal();
  Future<Either<Failure, List<Product>>> getProductsLocal();
}

