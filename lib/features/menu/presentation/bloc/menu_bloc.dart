import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:random_coffee/features/menu/domain/entities/category.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_categories.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_products.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({
    required GetCategories getCategories,
    required GetProducts getProducts,
  }) : _getCategories = getCategories,
       _getProducts = getProducts,
       super(MenuInitial()) {
    on<MenuEventLoadRequested>(_onLoadRequested);
    on<MenuEventRetryRequested>(_onRetryRequested);
  }

  final GetCategories _getCategories;
  final GetProducts _getProducts;

  Future<void> _onLoadRequested(
    MenuEventLoadRequested event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());

    final categoriesResult = await _getCategories();
    final productsResult = await _getProducts();

    if (categoriesResult.isLeft() || productsResult.isLeft()) {
      emit(const MenuFailure('Не удалось загрузить меню'));
      return;
    }

    emit(
      MenuLoaded(
        categories: categoriesResult.getOrElse(() => []),
        allProducts: productsResult.getOrElse(() => []),
      ),
    );
  }

  Future<void> _onRetryRequested(
    MenuEventRetryRequested event,
    Emitter<MenuState> emit,
  ) async {
    add(MenuEventLoadRequested());
  }
}
