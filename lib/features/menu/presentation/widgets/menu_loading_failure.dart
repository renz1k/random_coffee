import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:random_coffee/uikit/theme/app_colors.dart';

class MenuLoadingFailure extends StatelessWidget {
  const MenuLoadingFailure({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Не удалось загрузить меню',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () =>
                context.read<MenuBloc>().add(MenuEventRetryRequested()),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}
