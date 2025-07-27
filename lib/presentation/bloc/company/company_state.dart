import 'package:equatable/equatable.dart';

class CompanyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CompanyInitial extends CompanyState {}
class CompanyLoading extends CompanyState {}
class CompanyLoaded extends CompanyState {
  final List companies;
  CompanyLoaded(this.companies);

  @override
  List<Object?> get props => [companies];
}
class CompanyError extends CompanyState {
  final String message;
  CompanyError(this.message);

  @override
  List<Object?> get props => [message];
} 