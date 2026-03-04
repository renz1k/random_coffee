import 'package:flutter/material.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 48,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.wb_sunny_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
