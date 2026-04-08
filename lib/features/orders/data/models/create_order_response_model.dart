import 'package:json_annotation/json_annotation.dart';
import 'package:random_coffee/features/orders/data/models/order_model.dart';

part 'create_order_response_model.g.dart';

@JsonSerializable()
class CreateOrderResponseModel {
  const CreateOrderResponseModel({
    required this.success,
    required this.order,
    required this.message,
  });

  final bool success;
  final OrderModel? order;
  final String message;

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderResponseModelToJson(this);
}

