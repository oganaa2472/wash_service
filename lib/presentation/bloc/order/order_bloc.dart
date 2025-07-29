import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';
import '../../../domain/usecases/get_wash_car_orders.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetWashCarOrders getWashCarOrders;

  OrderBloc(this.getWashCarOrders) : super(OrderInitial()) {
    on<FetchWashCarOrders>(_onFetchWashCarOrders);
  }

  Future<void> _onFetchWashCarOrders(
    FetchWashCarOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final orders = await getWashCarOrders(event.companyId);
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
} 