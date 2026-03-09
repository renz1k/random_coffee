import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';

class ProductLocalImagePlaceholder extends StatelessWidget {
  final double height;
  final Color? backgroundColor;

  const ProductLocalImagePlaceholder({
    super.key,
    this.height = AppConstants.productCardImageHeight,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Image.asset(
        'lib/assets/images/coffee_placeholder.png',
        fit: BoxFit.contain,
      ),
    );
  }
}

