import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/features/orders/domain/usecases/create_order.dart';
import 'package:random_coffee/features/orders/presentation/cubit/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this._createOrder) : super(const OrderInitial());

  final CreateOrder _createOrder;

  Future<void> submitOrder() async {
    emit(const OrderLoading());

    final orderResult = await _createOrder();

    orderResult.fold(
      (failure) {
        emit(OrderError(failure.message));
      },
      (order) {
        emit(OrderSuccess(order));
      },
    );
  }

  void reset() => emit(const OrderInitial());
}

