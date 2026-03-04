import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_coffee/features/cart/domain/usecases/clear_cart.dart';
import 'package:random_coffee/features/orders/domain/usecases/create_order.dart';
import 'package:random_coffee/features/orders/presentation/cubit/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this._createOrder, this._clearCart) : super(const OrderInitial());

  final CreateOrder _createOrder;
  final ClearCart _clearCart;

  Future<void> submitOrder() async {
    emit(const OrderLoading());

    final orderResult = await _createOrder();

    await orderResult.fold(
      (failure) async {
        emit(OrderError(failure.message));
      },
      (order) async {
        final clearResult = await _clearCart();
        clearResult.fold(
          (failure) => emit(OrderError(failure.message)),
          (_) => emit(OrderSuccess(order)),
        );
      },
    );
  }

  void reset() => emit(const OrderInitial());
}
