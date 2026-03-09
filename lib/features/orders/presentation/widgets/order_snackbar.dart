import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

abstract class OrderSnackBar {
  static void showError(BuildContext context, [String? message]) {
    _showSnackBarOverlay(context, message ?? 'Возникла ошибка при заказе');
  }

  static void showSuccess(BuildContext context) {
    _showSnackBarOverlay(context, 'Заказ создан');
  }

  static void _showSnackBarOverlay(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final snackBarEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: AppConstants.snackBarHeight,
            color: AppColors.handleLight,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingLarge,
              vertical: AppConstants.spacingSmall,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.surfaceLight,
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(snackBarEntry);

    // Удаляем через 2 секунды
    Future.delayed(AppConstants.snackBarDuration, () {
      snackBarEntry.remove();
    });
  }
}
