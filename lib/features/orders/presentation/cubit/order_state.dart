import 'package:equatable/equatable.dart';
import 'package:random_coffee/features/orders/domain/entities/order.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderSuccess extends OrderState {
  const OrderSuccess(this.order);

  final Order order;

  @override
  List<Object?> get props => [order];
}

class OrderError extends OrderState {
  const OrderError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

