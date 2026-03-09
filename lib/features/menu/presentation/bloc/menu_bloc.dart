import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:random_coffee/core/utils/sync_logger.dart';
import 'package:random_coffee/features/menu/domain/entities/category.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_categories.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_categories_local.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_products.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_products_local.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({
    required GetCategories getCategories,
    required GetProducts getProducts,
    required GetCategoriesLocal getCategoriesLocal,
    required GetProductsLocal getProductsLocal,
  }) : _getCategories = getCategories,
       _getProducts = getProducts,
       _getCategoriesLocal = getCategoriesLocal,
       _getProductsLocal = getProductsLocal,
       super(MenuInitial()) {
    on<MenuEventLoadRequested>(_onLoadRequested);
    on<MenuEventRetryRequested>(_onRetryRequested);
  }

  final GetCategories _getCategories;
  final GetProducts _getProducts;
  final GetCategoriesLocal _getCategoriesLocal;
  final GetProductsLocal _getProductsLocal;

  Future<void> _onLoadRequested(
    MenuEventLoadRequested event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());

    // Сначала пытаемся загрузить локальные данные
    final localCategoriesResult = await _getCategoriesLocal();
    final localProductsResult = await _getProductsLocal();

    // Если есть локальные данные - показываем их сразу
    if (localCategoriesResult.isRight() && localProductsResult.isRight()) {
      final localCategories = localCategoriesResult.getOrElse(() => []);
      final localProducts = localProductsResult.getOrElse(() => []);

      if (localCategories.isNotEmpty && localProducts.isNotEmpty) {
        SyncLogger.logMenuLoad(
          true,
          localCategories.length,
          localProducts.length,
        );
        emit(
          MenuLoaded(categories: localCategories, allProducts: localProducts),
        );
      }
    }

    // Потом загружаем с сервера и обновляем
    final categoriesResult = await _getCategories();
    final productsResult = await _getProducts();

    if (categoriesResult.isLeft() || productsResult.isLeft()) {
      // Если нет локальных данных и сервер не доступен
      final categories = localCategoriesResult.getOrElse(() => []);
      final products = localProductsResult.getOrElse(() => []);

      if (categories.isEmpty || products.isEmpty) {
        emit(const MenuFailure('Не удалось загрузить меню'));
        return;
      }
    }

    final categories = categoriesResult.getOrElse(() => []);
    final products = productsResult.getOrElse(() => []);

    SyncLogger.logMenuSync(
      SyncState.success,
      SyncSource.server,
      'Меню обновлено с сервера',
      itemCount: categories.length + products.length,
    );

    emit(MenuLoaded(categories: categories, allProducts: products));
  }

  Future<void> _onRetryRequested(
    MenuEventRetryRequested event,
    Emitter<MenuState> emit,
  ) async {
    add(MenuEventLoadRequested());
  }
}

