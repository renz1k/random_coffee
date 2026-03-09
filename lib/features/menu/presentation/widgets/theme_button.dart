import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/core/constants/app_constants.dart';
import 'package:random_coffee/uikit/icons/app_icon.dart';
import 'package:random_coffee/uikit/icons/app_icons.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';
import 'package:random_coffee/uikit/theme/cubit/theme_cubit.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: AppConstants.themeButtonSize,
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final themeCubit = context.read<ThemeCubit>();
          final isLight = themeMode == ThemeMode.light;

          return GestureDetector(
            onTap: () {
              themeCubit.toggleTheme();
            },
            child: Container(
              width: AppConstants.themeButtonSize,
              height: AppConstants.themeButtonSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isLight ? AppColors.primaryLight : AppColors.primaryDark,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
              child: AppIcon(
                isLight ? AppIcons.sun : AppIcons.moon,
                color: AppColors.surfaceLight,
                size: AppConstants.iconSizeSmall,
              ),
            ),
          );
        },
      ),
    );
  }
}
