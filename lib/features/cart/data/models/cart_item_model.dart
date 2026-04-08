import 'package:json_annotation/json_annotation.dart';
import 'package:random_coffee/features/cart/domain/entities/cart_item.dart';
import 'package:random_coffee/features/menu/data/models/product_model.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel {
  const CartItemModel({
    required this.product,
    required this.quantity,

    @JsonKey(name: 'total_price') required this.totalPrice,
  });

  final ProductModel product;
  final int quantity;
  final int totalPrice;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItem toEntity() => CartItem(
    product: product.toEntity(),
    quantity: quantity,
    totalPrice: totalPrice,
  );
}

