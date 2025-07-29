import 'package:equatable/equatable.dart';
import '../../../domain/entities/wash_service.dart';

abstract class WashServiceState extends Equatable {
  const WashServiceState();

  @override
  List<Object?> get props => [];
}

class WashServiceInitial extends WashServiceState {}

class WashServiceLoading extends WashServiceState {}

class WashServiceLoaded extends WashServiceState {
  final List<WashService> services;

  const WashServiceLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class WashServiceError extends WashServiceState {
  final String message;

  const WashServiceError(this.message);

  @override
  List<Object?> get props => [message];
} 