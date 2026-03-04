import 'package:json_annotation/json_annotation.dart';
import 'package:random_coffee/features/cart/data/models/cart_item_model.dart';
import 'package:random_coffee/features/cart/domain/entities/cart.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  const CartModel({required this.items, required this.total});

  @JsonKey(name: 'items')
  final List<CartItemModel> items;
  final int total;

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);

  Cart toEntity() =>
      Cart(items: items.map((item) => item.toEntity()).toList(), total: total);
}
