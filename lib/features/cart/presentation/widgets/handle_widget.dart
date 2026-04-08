import 'package:flutter/material.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class HandleWidget extends StatelessWidget {
  const HandleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Container(
      width: AppConstants.iconSizeLarge,
      height: AppConstants.sizeTiny,
      decoration: BoxDecoration(
        color: isLight ? AppColors.handleLight : AppColors.handleDark,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
    );
  }
}
