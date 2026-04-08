import 'package:dio/dio.dart';
import 'package:random_coffee/core/constants/api_endpoints.dart';
import 'package:random_coffee/features/cart/data/models/add_to_cart_request_model.dart';
import 'package:random_coffee/features/cart/data/models/cart_model.dart';
import 'package:random_coffee/features/cart/data/models/update_cart_item_request_model.dart';
import 'package:random_coffee/features/menu/data/models/category_model.dart';
import 'package:random_coffee/features/menu/data/models/product_model.dart';
import 'package:random_coffee/features/orders/data/models/create_order_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'coffee_api_service.g.dart';

@RestApi()
abstract class CoffeeApiService {
  factory CoffeeApiService(Dio dio, {String? baseUrl}) = _CoffeeApiService;

  // МЕНЮ
  @GET(ApiEndpoints.categories)
  Future<List<CategoryModel>> getCategories();

  @GET('${ApiEndpoints.categories}/{category_id}')
  Future<CategoryModel> getCategory(@Path('category_id') int categoryId);

  @GET(ApiEndpoints.products)
  Future<List<ProductModel>> getProducts();

  @GET('${ApiEndpoints.products}/{product_id}')
  Future<ProductModel> getProduct(@Path('product_id') int productId);

  // КОРЗИНА
  @GET(ApiEndpoints.cart)
  Future<CartModel> getCart();

  @DELETE(ApiEndpoints.cart)
  Future<CartModel> clearCart();

  @POST(ApiEndpoints.cartItems)
  Future<CartModel> addToCart(@Body() AddToCartRequestModel request);

  @PUT('${ApiEndpoints.cartItems}/{product_id}')
  Future<CartModel> updateCartItem(
    @Path('product_id') int productId,
    @Body() UpdateCartItemRequestModel request,
  );

  @DELETE('${ApiEndpoints.cartItems}/{product_id}')
  Future<CartModel> removeFromCart(@Path('product_id') int productId);

  // Р—РђРљРђР—Р«
  @POST(ApiEndpoints.orders)
  Future<CreateOrderResponseModel> createOrder();
}

