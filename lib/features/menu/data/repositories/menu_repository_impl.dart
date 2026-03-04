import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/exceptions.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/features/menu/data/datasources/menu_remote_datasource.dart';
import 'package:random_coffee/features/menu/domain/entities/category.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';
import 'package:random_coffee/features/menu/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  const MenuRepositoryImpl(this.remoteDataSource);

  final MenuRemoteDataSource remoteDataSource;

  static const int _maxAttempts = 2;

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    int attempt = 0;

    while (attempt < _maxAttempts) {
      try {
        final categories = await remoteDataSource.getCategories();
        return Right(categories);
      } on ServerException catch (e) {
        attempt++;

        if (attempt >= _maxAttempts) {
          return Left(ServerFailure(e.message));
        }

        await Future.delayed(Duration(seconds: attempt));
      }
    }

    return const Left(ServerFailure('Unknown error'));
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    int attempt = 0;

    while (attempt < _maxAttempts) {
      try {
        final products = await remoteDataSource.getProducts();
        return Right(products);
      } on ServerException catch (e) {
        attempt++;

        if (attempt >= _maxAttempts) {
          return Left(ServerFailure(e.message));
        }

        await Future.delayed(Duration(seconds: attempt));
      }
    }

    return const Left(ServerFailure('Unknown error'));
  }
}
