import 'package:equatable/equatable.dart';

abstract class CarEvent extends Equatable {
  const CarEvent();

  @override
  List<Object?> get props => [];
}

class FetchCarList extends CarEvent {
  const FetchCarList();

  @override
  List<Object?> get props => [];
} 