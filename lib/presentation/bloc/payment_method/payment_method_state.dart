import 'package:equatable/equatable.dart';
import '../../../domain/entities/payment_method.dart';

abstract class PaymentMethodState extends Equatable {
  const PaymentMethodState();

  @override
  List<Object?> get props => [];
}

class PaymentMethodInitial extends PaymentMethodState {}

class PaymentMethodLoading extends PaymentMethodState {}

class PaymentMethodLoaded extends PaymentMethodState {
  final List<PaymentMethod> paymentMethods;
  const PaymentMethodLoaded(this.paymentMethods);
  @override
  List<Object?> get props => [paymentMethods];
}

class PaymentMethodError extends PaymentMethodState {
  final String message;
  const PaymentMethodError(this.message);
  @override
  List<Object?> get props => [message];
} 