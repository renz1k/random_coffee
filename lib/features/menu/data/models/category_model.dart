import 'package:json_annotation/json_annotation.dart';
import 'package:random_coffee/features/menu/domain/entities/category.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  final int id;
  final String name;
  final String slug;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  Category toEntity() => Category(id: id, name: name, slug: slug);
}

