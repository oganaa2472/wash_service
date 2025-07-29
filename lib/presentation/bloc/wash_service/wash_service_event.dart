import 'package:equatable/equatable.dart';

abstract class WashServiceEvent extends Equatable {
  const WashServiceEvent();

  @override
  List<Object?> get props => [];
}

class FetchWashServices extends WashServiceEvent {
  final String companyId;
  
  const FetchWashServices(this.companyId);

  @override
  List<Object?> get props => [companyId];
} 