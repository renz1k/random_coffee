import 'package:equatable/equatable.dart';

import 'cart_item.dart';

class Cart extends Equatable {
  const Cart({this.items = const [], this.total = 0});

  final List<CartItem> items;
  final int total;

  Cart copyWith({List<CartItem>? items, int? total}) {
    return Cart(items: items ?? this.items, total: total ?? 0);
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  @override
  List<Object?> get props => [items, total];
}
