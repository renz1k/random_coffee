// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderResponseModel _$CreateOrderResponseModelFromJson(
  Map<String, dynamic> json,
) => CreateOrderResponseModel(
  success: json['success'] as bool,
  order: json['order'] == null
      ? null
      : OrderModel.fromJson(json['order'] as Map<String, dynamic>),
  message: json['message'] as String,
);

Map<String, dynamic> _$CreateOrderResponseModelToJson(
  CreateOrderResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'order': instance.order,
  'message': instance.message,
};

