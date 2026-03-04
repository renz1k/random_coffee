import 'package:flutter/material.dart';

abstract class OrderSnackBar {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  static void showSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Заказ успешно оформлен'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
