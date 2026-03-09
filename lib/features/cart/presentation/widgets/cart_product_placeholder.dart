import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class CartProductPlaceholder extends StatelessWidget {
  const CartProductPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      width: AppConstants.cartProductImageSize,
      height: AppConstants.cartProductImageSize,
      decoration: BoxDecoration(
        color: isLight ? theme.colorScheme.surface : AppColors.textLightPrimary,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Image.asset(
        'lib/assets/images/coffee_placeholder.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
