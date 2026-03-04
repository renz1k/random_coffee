import 'package:dartz/dartz.dart';
import 'package:random_coffee/core/error/failures.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';
import 'package:random_coffee/features/menu/domain/repositories/menu_repository.dart';

class GetProducts {
  const GetProducts(this.repository);
  
  final MenuRepository repository;

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts(); 
  }
}
