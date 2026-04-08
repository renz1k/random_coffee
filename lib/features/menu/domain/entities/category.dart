import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({required this.id, required this.name, required this.slug});

  final int id;
  final String name;
  final String slug;

  @override
  List<Object?> get props => [id, name, slug];
}

