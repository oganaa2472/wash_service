import 'package:equatable/equatable.dart';

abstract class WashEmployeeEvent extends Equatable {
  const WashEmployeeEvent();

  @override
  List<Object?> get props => [];
}

class FetchWashEmployees extends WashEmployeeEvent {
  final String companyId;

  const FetchWashEmployees(this.companyId);

  @override
  List<Object?> get props => [companyId];
} 