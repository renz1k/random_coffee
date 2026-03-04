import 'package:equatable/equatable.dart';
import 'package:random_coffee/features/cart/domain/entities/cart_item.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
  });

  final int id;
  final List<CartItem> items;
  final int total;
  final String status;

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isPreparing => status == 'preparing';
  bool get isReady => status == 'ready';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  @override
  List<Object?> get props => [id, items, total, status];
}
