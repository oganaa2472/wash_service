import 'package:equatable/equatable.dart';
import '../../../domain/entities/car.dart';

abstract class CarState extends Equatable {
  const CarState();

  @override
  List<Object?> get props => [];
}

class CarInitial extends CarState {}

class CarLoading extends CarState {}

class CarLoaded extends CarState {
  final List<Car> cars;

  const CarLoaded(this.cars);

  @override
  List<Object?> get props => [cars];
}

class CarError extends CarState {
  final String message;

  const CarError(this.message);

  @override
  List<Object?> get props => [message];
} 