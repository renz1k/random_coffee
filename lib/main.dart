import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/core/di/injector.dart';
import 'package:random_coffee/features/cart/domain/usecases/add_product_to_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/clear_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/get_cart.dart';
import 'package:random_coffee/features/cart/domain/usecases/remove_cart_product.dart';
import 'package:random_coffee/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:random_coffee/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_categories.dart';
import 'package:random_coffee/features/menu/domain/usecases/get_products.dart';
import 'package:random_coffee/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:random_coffee/features/menu/presentation/pages/menu_page.dart';
import 'package:random_coffee/features/orders/domain/usecases/create_order.dart';
import 'package:random_coffee/features/orders/presentation/cubit/order_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init(); // инициализация зависимостей

  runApp(const RandomCoffeeApp());
}

class RandomCoffeeApp extends StatelessWidget {
  const RandomCoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(
            getIt<GetCart>(),
            getIt<AddProductToCart>(),
            getIt<UpdateCartQuantity>(),
            getIt<RemoveCartProduct>(),
            getIt<ClearCart>(),
          )..loadCart(),
        ),
        BlocProvider<OrderCubit>(
          create: (context) =>
              OrderCubit(getIt<CreateOrder>(), getIt<ClearCart>()),
        ),
        BlocProvider<MenuBloc>(
          create: (context) => MenuBloc(
            getCategories: getIt<GetCategories>(),
            getProducts: getIt<GetProducts>(),
          )..add(MenuEventLoadRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Random Coffee',
        theme: ThemeData(useMaterial3: true),
        home: const MenuPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
