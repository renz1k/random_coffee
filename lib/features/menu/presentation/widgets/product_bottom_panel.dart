import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/uikit/icons/app_icon.dart';
import 'package:random_coffee/uikit/icons/app_icons.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class ProductBottomPanel extends StatelessWidget {
  const ProductBottomPanel({
    super.key,
    required this.quantity,
    required this.price,
    this.onPressedPlus,
    this.decrement,
    this.increment,
  });

  final int quantity;
  final int price;
  final VoidCallback? onPressedPlus;
  final VoidCallback? decrement;
  final VoidCallback? increment;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.paddingLarge,
          0,
          AppConstants.paddingLarge,
          AppConstants.paddingExtraSmall,
        ),
        child: quantity == 0
            ? InitialPanel(price: price, onPressedPlus: onPressedPlus)
            : QuantityButtons(
                decrement: decrement,
                quantity: quantity,
                increment: increment,
              ),
      ),
    );
  }
}

class QuantityButtons extends StatelessWidget {
  const QuantityButtons({
    super.key,
    required this.decrement,
    required this.quantity,
    required this.increment,
  });

  final VoidCallback? decrement;
  final int quantity;
  final VoidCallback? increment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Row(
      children: [
        Container(
          height: AppConstants.buttonHeight,
          width: AppConstants.buttonHeight,
          decoration: BoxDecoration(
            color: isLight
                ? AppColors.controlLight
                : AppColors.controlQuantityDark,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: decrement,
            icon: AppIcon(
              AppIcons.minus,
              color: isLight ? AppColors.backgroundDark : Colors.white,
              size: AppConstants.iconSizeMinus,
            ),
          ),
        ),

        Expanded(
          child: Text(
            quantity.toString(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: isLight
                  ? AppColors.textLightPrimary
                  : AppColors.textDarkSecondary,
            ),
          ),
        ),

        Container(
          height: AppConstants.buttonHeight,
          width: AppConstants.buttonHeight,
          decoration: BoxDecoration(
            color: isLight
                ? AppColors.controlLight
                : AppColors.controlQuantityDark,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: increment,
            icon: AppIcon(
              AppIcons.plus,
              color: isLight ? AppColors.backgroundDark : Colors.white,
              size: AppConstants.iconSizeTiny,
            ),
          ),
        ),
      ],
    );
  }
}

class InitialPanel extends StatelessWidget {
  const InitialPanel({
    super.key,
    required this.price,
    required this.onPressedPlus,
  });

  final int price;

  final VoidCallback? onPressedPlus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            child: Text(
              '$price ₽',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isLight
                    ? AppColors.textLightPrimary
                    : AppColors.textDarkSecondary,
              ),
            ),
          ),
        ),

        Container(
          height: AppConstants.buttonHeight,
          width: AppConstants.buttonHeight,
          decoration: BoxDecoration(
            color: isLight ? AppColors.primaryLight : AppColors.primaryDark,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: onPressedPlus,
            icon: const AppIcon(
              AppIcons.plus,
              color: Colors.white,
              size: AppConstants.iconSizeTiny,
            ),
          ),
        ),
      ],
    );
  }
}
