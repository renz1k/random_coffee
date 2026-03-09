import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/uikit/icons/app_icon.dart';
import 'package:random_coffee/uikit/icons/app_icons.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key, required this.onClearPressed});

  final VoidCallback onClearPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ваш заказ',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: isLight
                  ? AppColors.textLightPrimary
                  : AppColors.textDarkSecondary,
            ),
          ),

          IconButton(
            iconSize: AppConstants.iconSizeLarge,
            icon: const AppIcon(
              AppIcons.trash,
              size: AppConstants.iconSizeMedium,
              color: AppColors.handleLight,
            ),
            onPressed: onClearPressed,
          ),
        ],
      ),
    );
  }
}
