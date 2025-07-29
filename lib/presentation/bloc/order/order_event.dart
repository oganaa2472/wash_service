import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class FetchWashCarOrders extends OrderEvent {
  final String companyId;
  
  const FetchWashCarOrders(this.companyId);

  @override
  List<Object?> get props => [companyId];
} 