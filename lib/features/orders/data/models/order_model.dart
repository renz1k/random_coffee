import 'package:json_annotation/json_annotation.dart';
import 'package:random_coffee/features/cart/data/models/cart_item_model.dart';
import 'package:random_coffee/features/orders/domain/entities/order.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  const OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
  });

  final int id;
  final List<CartItemModel> items;
  final int total;
  final String status;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  Order toEntity() => Order(
    id: id,
    items: items.map((item) => item.toEntity()).toList(),
    total: total,
    status: status,
  );
}
