import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ApiEndpoints {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static const String categories = '/categories';
  static const String products = '/products';
  static const String cart = '/cart';
  static const String cartItems = '/cart/items';
  static const String orders = '/orders';
}

