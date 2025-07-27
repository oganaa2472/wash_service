import 'package:equatable/equatable.dart';

abstract class CompanyEvent extends Equatable {
  const CompanyEvent();

  @override
  List<Object?> get props => [];
}

class FetchCompaniesByCategory extends CompanyEvent {
  final int categoryId;
  const FetchCompaniesByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
} 