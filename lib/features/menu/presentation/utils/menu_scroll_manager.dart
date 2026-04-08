import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MenuScrollManager {
  MenuScrollManager();

  // Вертикальный список
  late final ItemScrollController itemScrollController = ItemScrollController();
  late final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  // Горизонтальный список категорий
  late final ScrollController categoriesScrollController = ScrollController();

  // Ключи кнопок категорий
  final Map<int, GlobalKey> categoryButtonKeys = {};

  bool _isProgrammaticScroll = false;

  /// Инициализация слушателя вертикального скролла
  void initialize(VoidCallback onVerticalScroll) {
    itemPositionsListener.itemPositions.addListener(onVerticalScroll);
  }

  void dispose() {
    itemPositionsListener.itemPositions.removeListener(() {});
    categoriesScrollController.dispose();
  }

  /// Получить ID видимой категории при вертикальном скролле
  int? getVisibleCategoryId() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return null;

    final visible = positions.where((p) => p.itemLeadingEdge >= 0).toList();
    if (visible.isEmpty) return null;

    final firstVisible = visible.reduce(
      (a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b,
    );

    return firstVisible.index + 1;
  }

  /// Нажатие на категорию - скролл к ней
  Future<void> onCategoryTap(int categoryId, int index) async {
    _isProgrammaticScroll = true;

    await itemScrollController.scrollTo(
      index: index,
      duration: AppConstants.menuScrollDuration,
      curve: Curves.easeInOut,
    );

    _isProgrammaticScroll = false;

    scrollCategoryToVisible(categoryId);
  }

  /// Скролл горизонтального списка категорий
  void scrollCategoryToVisible(int categoryId) {
    final key = categoryButtonKeys[categoryId];
    if (key == null) return;

    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: AppConstants.categoryScrollDuration,
      alignment: 0.05,
      curve: Curves.easeInOut,
    );
  }

  /// Проверка был ли это программный скролл
  bool get isProgrammaticScroll => _isProgrammaticScroll;
}
