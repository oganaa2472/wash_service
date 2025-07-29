import 'package:equatable/equatable.dart';
import '../../../domain/entities/wash_employee.dart';

abstract class WashEmployeeState extends Equatable {
  const WashEmployeeState();

  @override
  List<Object?> get props => [];
}

class WashEmployeeInitial extends WashEmployeeState {}

class WashEmployeeLoading extends WashEmployeeState {}

class WashEmployeeLoaded extends WashEmployeeState {
  final List<WashEmployee> employees;

  const WashEmployeeLoaded(this.employees);

  @override
  List<Object?> get props => [employees];
}

class WashEmployeeError extends WashEmployeeState {
  final String message;

  const WashEmployeeError(this.message);

  @override
  List<Object?> get props => [message];
} 