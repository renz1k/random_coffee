import 'package:json_annotation/json_annotation.dart';
import 'package:random_coffee/features/menu/domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
  });

  final int id;
  final String name;
  final String description;
  final int price;

  @JsonKey(name: 'image_url')
  final String imageUrl;

  @JsonKey(name: 'category_id')
  final int categoryId;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
  
  Product toEntity() => Product(
    id: id, name: name, description: description, 
    price: price, imageUrl: imageUrl, categoryId: categoryId,
  );
}
