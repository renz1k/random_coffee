import 'package:json_annotation/json_annotation.dart';

part 'add_to_cart_request_model.g.dart';

@JsonSerializable()
class AddToCartRequestModel {
  const AddToCartRequestModel({
    @JsonKey(name: 'product_id') required this.productId,
    required this.quantity,
  });

  final int productId;
  final int quantity;

  factory AddToCartRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddToCartRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddToCartRequestModelToJson(this);
}

