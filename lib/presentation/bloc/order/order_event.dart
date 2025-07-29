import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class FetchWashCarOrders extends OrderEvent {
  const FetchWashCarOrders();

  @override
  List<Object?> get props => [];
} 