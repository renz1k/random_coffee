import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/features/menu/domain/entities/category.dart';
import 'package:random_coffee/features/menu/domain/repositories/menu_repository.dart';

class GetCategoriesLocal {
  const GetCategoriesLocal(this.repository);

  final MenuRepository repository;

  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getCategoriesLocal();
  }
}

