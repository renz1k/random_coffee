import 'package:json_annotation/json_annotation.dart';

part 'update_cart_item_request_model.g.dart';

@JsonSerializable()
class UpdateCartItemRequestModel {
  const UpdateCartItemRequestModel({required this.quantity});

  final int quantity;

  factory UpdateCartItemRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateCartItemRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateCartItemRequestModelToJson(this);
}

