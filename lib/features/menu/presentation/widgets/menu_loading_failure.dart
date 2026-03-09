import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class MenuLoadingFailure extends StatelessWidget {
  const MenuLoadingFailure({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            size: AppConstants.iconSizeHuge,
            color: isLight ? AppColors.disabledLight : AppColors.disabledDark,
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          Text(
            'Не удалось загрузить меню',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: isLight
                  ? AppColors.textLightPrimary
                  : AppColors.textDarkSecondary,
            ),
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isLight
                  ? AppColors.primaryLight
                  : AppColors.primaryDark,
              foregroundColor: isLight
                  ? AppColors.surfaceLight
                  : AppColors.surfaceDark,
            ),
            onPressed: () =>
                context.read<MenuBloc>().add(MenuEventRetryRequested()),
            child: Text(
              'Повторить',
              style: theme.textTheme.titleLarge?.copyWith(
                color: isLight
                    ? AppColors.textLightPrimary
                    : AppColors.textDarkSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
