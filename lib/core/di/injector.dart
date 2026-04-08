import 'package:get_it/get_it.dart';
import 'package:random_coffee/core/network/coffee_api_service.dart';
import 'package:random_coffee/core/network/dio_client.dart';
import 'package:random_coffee/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:random_coffee/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:random_coffee/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:random_coffee/features/cart/domain/repositories/cart_repository.dart';
import 'package:random_coffee/features/cart/domain/usecases/add_product_to_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/clear_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/get_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/get_cart_local.dart';
import 'package:random_coffee/features/cart/domain/usecases/remove_cart_product.dart';
import 'package:random_coffee/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:random_coffee/features/menu/data/datasources/menu_local_datasource.dart';
import 'package:random_coffee/features/menu/data/datasources/menu_remote_datasource.dart';
import 'package:random_coffee/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:random_coffee/features/menu/domain/repositories/menu_repository.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_categories.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_categories_local.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_products.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_products_local.dart';
import 'package:random_coffee/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:random_coffee/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:random_coffee/features/orders/domain/repositories/orders_repository.dart';
import 'package:random_coffee/features/orders/domain/usecases/create_order.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Dio
  getIt.registerLazySingleton(() => DioClient());

  // Api
  getIt.registerLazySingleton(() => CoffeeApiService(getIt<DioClient>().dio));

  // Local DataSources
  getIt.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<MenuLocalDataSource>(
    () => MenuLocalDataSourceImpl(),
  );

  // Remote DataSources
  getIt.registerLazySingleton<MenuRemoteDataSource>(
    () => MenuRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(getIt()),
  );

  // Repository
  getIt.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(
      getIt<MenuRemoteDataSource>(),
      getIt<MenuLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      getIt<CartRemoteDataSource>(),
      getIt<CartLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(getIt()),
  );

  // UseCases
  getIt.registerLazySingleton(() => GetCategories(getIt()));
  getIt.registerLazySingleton(() => GetProducts(getIt()));
  getIt.registerLazySingleton(() => GetCategoriesLocal(getIt()));
  getIt.registerLazySingleton(() => GetProductsLocal(getIt()));

  getIt.registerLazySingleton(() => GetCart(getIt()));
  getIt.registerLazySingleton(() => GetCartLocal(getIt()));
  getIt.registerLazySingleton(() => AddProductToCart(getIt()));
  getIt.registerLazySingleton(() => UpdateCartQuantity(getIt()));
  getIt.registerLazySingleton(() => RemoveCartProduct(getIt()));
  getIt.registerLazySingleton(() => ClearCart(getIt()));

  getIt.registerLazySingleton(() => CreateOrder(getIt<OrdersRepository>()));
}

