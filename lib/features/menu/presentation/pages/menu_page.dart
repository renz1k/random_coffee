import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:random_coffee/features/menu/presentation/widgets/cart_button.dart';
import 'package:random_coffee/features/menu/presentation/widgets/category_sections_list.dart';
import 'package:random_coffee/features/menu/presentation/widgets/category_tabs.dart';
import 'package:random_coffee/features/menu/presentation/widgets/menu_loading_failure.dart';
import 'package:random_coffee/features/menu/presentation/widgets/theme_button.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int? _selectedCategoryId;

  // Вертикальный список
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  // Горизонтальный список категорий
  final ScrollController _categoriesScrollController = ScrollController();

  // Ключи кнопок категорий
  final Map<int, GlobalKey> _categoryButtonKeys = {};

  bool _isProgrammaticScroll = false;

  @override
  void initState() {
    super.initState();
    _itemPositionsListener.itemPositions.addListener(_onVerticalScroll);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onVerticalScroll);
    _categoriesScrollController.dispose();
    super.dispose();
  }

  // Обработка вертикального скролла
  void _onVerticalScroll() {
    if (_isProgrammaticScroll) return;

    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final visible = positions.where((p) => p.itemLeadingEdge >= 0).toList();
    if (visible.isEmpty) return;

    final firstVisible = visible.reduce(
      (a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b,
    );

    final newCategoryId = firstVisible.index + 1;

    if (newCategoryId != _selectedCategoryId) {
      setState(() => _selectedCategoryId = newCategoryId);
      _scrollCategoryToVisible();
    }
  }

  // Нажатие на категорию
  void _onCategoryTap(int categoryId, int index) async {
    if (_selectedCategoryId == categoryId) return;

    setState(() => _selectedCategoryId = categoryId);

    _isProgrammaticScroll = true;

    await _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    _isProgrammaticScroll = false;

    _scrollCategoryToVisible();
  }

  // Скролл горизонтального списка
  void _scrollCategoryToVisible() {
    final key = _categoryButtonKeys[_selectedCategoryId];
    if (key == null) return;

    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
      alignment: 0.05,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: Stack(
        children: [ThemeButton(), const CartButton()],
      ),

      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (state is MenuLoaded) {
            _selectedCategoryId ??= state.categories.first.id;

            // ключи
            for (final category in state.categories) {
              _categoryButtonKeys.putIfAbsent(category.id, () => GlobalKey());
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<MenuBloc>().add(MenuEventLoadRequested());
              },
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // Горизонтальный список категорий
                  CategoryTabs(
                    categories: state.categories,
                    selectedCategoryId: _selectedCategoryId,
                    scrollController: _categoriesScrollController,
                    categoryButtonKeys: _categoryButtonKeys,
                    onCategoryTap: _onCategoryTap,
                  ),

                  const SizedBox(height: 24),

                  // Вертикальный список категорий
                  CategorySectionsList(
                    itemScrollController: _itemScrollController,
                    itemPositionsListener: _itemPositionsListener,
                    allProducts: state.allProducts,
                    categories: state.categories,
                  ),
                ],
              ),
            );
          }
          if (state is MenuFailure) {
            return MenuLoadingFailure();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
