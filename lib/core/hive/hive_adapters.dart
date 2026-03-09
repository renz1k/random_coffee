import 'package:hive_ce/hive_ce.dart';
import 'package:random_coffee/features/cart/data/models/cart_item_model.dart';
import 'package:random_coffee/features/cart/data/models/cart_model.dart';
import 'package:random_coffee/features/menu/data/models/category_model.dart';
import 'package:random_coffee/features/menu/data/models/product_model.dart';

@GenerateAdapters([
  AdapterSpec<CartModel>(),
  AdapterSpec<CartItemModel>(),
  AdapterSpec<ProductModel>(),
  AdapterSpec<CategoryModel>(),
])
part 'hive_adapters.g.dart';

