import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:random_coffee/features/menu/presentation/utils/menu_scroll_manager.dart';
import 'package:random_coffee/features/menu/presentation/widgets/cart_button.dart';
import 'package:random_coffee/features/menu/presentation/widgets/category_sections_list.dart';
import 'package:random_coffee/features/menu/presentation/widgets/category_tabs.dart';
import 'package:random_coffee/features/menu/presentation/widgets/menu_loading_failure.dart';
import 'package:random_coffee/features/menu/presentation/widgets/theme_button.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final MenuScrollManager _scrollManager = MenuScrollManager();
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _scrollManager.initialize(_onVerticalScroll);
  }

  @override
  void dispose() {
    _scrollManager.dispose();
    super.dispose();
  }

  void _onVerticalScroll() {
    if (_scrollManager.isProgrammaticScroll) return;

    final newCategoryId = _scrollManager.getVisibleCategoryId();
    if (newCategoryId != null && newCategoryId != _selectedCategoryId) {
      setState(() => _selectedCategoryId = newCategoryId);
      _scrollManager.scrollCategoryToVisible(newCategoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final menuBloc = context.read<MenuBloc>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: Stack(
        children: [const ThemeButton(), const CartButton()],
      ),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: isLight ? AppColors.primaryLight : AppColors.primaryDark,
              ),
            );
          }

          if (state is MenuLoaded) {
            _selectedCategoryId ??= state.categories.first.id;

            for (final category in state.categories) {
              _scrollManager.categoryButtonKeys.putIfAbsent(
                category.id,
                () => GlobalKey(),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                menuBloc.add(MenuEventLoadRequested());
              },
              child: Column(
                children: [
                  const SizedBox(height: AppConstants.iconSizeHuge),

                  CategoryTabs(
                    categories: state.categories,
                    selectedCategoryId: _selectedCategoryId,
                    scrollController: _scrollManager.categoriesScrollController,
                    categoryButtonKeys: _scrollManager.categoryButtonKeys,
                    onCategoryTap: (categoryId, index) =>
                        onCategoryTap(categoryId, index),
                  ),

                  const SizedBox(height: AppConstants.paddingExtraLarge),

                  CategorySectionsList(
                    itemScrollController: _scrollManager.itemScrollController,
                    itemPositionsListener: _scrollManager.itemPositionsListener,
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

  void onCategoryTap(int categoryId, int index) {
    setState(() => _selectedCategoryId = categoryId);
    _scrollManager.onCategoryTap(categoryId, index);
  }
}
