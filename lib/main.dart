import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:random_coffee/core/di/injector.dart';
import 'package:random_coffee/core/hive/hive_registrar.g.dart';
import 'package:random_coffee/features/cart/domain/usecases/add_product_to_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/clear_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/get_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/get_cart_local.dart';
import 'package:random_coffee/features/cart/domain/usecases/remove_cart_product.dart';
import 'package:random_coffee/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_categories.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_categories_local.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_products.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_products_local.dart';
import 'package:random_coffee/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:random_coffee/features/menu/presentation/pages/menu_page.dart';
import 'package:random_coffee/features/orders/domain/usecases/create_order.dart';
import 'package:random_coffee/features/orders/presentation/cubit/order_cubit.dart';
import 'package:random_coffee/uikit/theme/app_theme.dart';
import 'package:random_coffee/uikit/theme/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Hive.initFlutter();
  Hive.registerAdapters();

  await init();

  runApp(const RandomCoffeeApp());
}

class RandomCoffeeApp extends StatelessWidget {
  const RandomCoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit()..loadSavedTheme(),
        ),
        BlocProvider<MenuBloc>(
          create: (context) => MenuBloc(
            getCategories: getIt<GetCategories>(),
            getProducts: getIt<GetProducts>(),
            getCategoriesLocal: getIt<GetCategoriesLocal>(),
            getProductsLocal: getIt<GetProductsLocal>(),
          )..add(MenuEventLoadRequested()),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(
            getIt<GetCart>(),
            getIt<AddProductToCart>(),
            getIt<UpdateCartQuantity>(),
            getIt<RemoveCartProduct>(),
            getIt<ClearCart>(),
            getIt<GetCartLocal>(),
          )..initializeCart(),
        ),
        BlocProvider<OrderCubit>(
          create: (context) => OrderCubit(getIt<CreateOrder>()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Random Coffee',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const MenuPage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
