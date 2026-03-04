part of 'menu_bloc.dart';

sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

final class MenuInitial extends MenuState {}

final class MenuLoading extends MenuState {}

final class MenuLoaded extends MenuState {
  const MenuLoaded({required this.categories, required this.allProducts});

  final List<Category> categories;
  final List<Product> allProducts;

  @override
  List<Object?> get props => [categories, allProducts];

  MenuLoaded copyWith({
    List<Category>? categories,
    List<Product>? allProducts,
    int? selectedCategoryId,
  }) {
    return MenuLoaded(
      categories: categories ?? this.categories,
      allProducts: allProducts ?? this.allProducts,
    );
  }
}

final class MenuFailure extends MenuState {
  const MenuFailure(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
}
