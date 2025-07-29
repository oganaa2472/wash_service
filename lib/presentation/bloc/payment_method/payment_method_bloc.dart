import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_method_event.dart';
import 'payment_method_state.dart';
import '../../../domain/usecases/get_payment_methods.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final GetPaymentMethods getPaymentMethods;

  PaymentMethodBloc(this.getPaymentMethods) : super(PaymentMethodInitial()) {
    on<FetchPaymentMethods>(_onFetchPaymentMethods);
  }

  Future<void> _onFetchPaymentMethods(
    FetchPaymentMethods event,
    Emitter<PaymentMethodState> emit,
  ) async {
    emit(PaymentMethodLoading());
    try {
      final paymentMethods = await getPaymentMethods();
      emit(PaymentMethodLoaded(paymentMethods));
    } catch (e) {
      emit(PaymentMethodError(e.toString()));
    }
  }
} 