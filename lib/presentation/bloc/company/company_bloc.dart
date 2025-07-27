import 'package:flutter_bloc/flutter_bloc.dart';
import 'company_event.dart' as company_event;
import 'company_state.dart';
import '../../../domain/usecases/fetch_companies_by_category.dart' as domain_usecase;

class CompanyBloc extends Bloc<company_event.CompanyEvent, CompanyState> {
  final domain_usecase.FetchCompaniesByCategory fetchCompaniesByCategory;
  CompanyBloc(this.fetchCompaniesByCategory) : super(CompanyInitial()) {
    on<company_event.FetchCompaniesByCategory>(_onFetchCompaniesByCategory);
  }

  Future<void> _onFetchCompaniesByCategory(
    company_event.FetchCompaniesByCategory event,
    Emitter<CompanyState> emit,
  ) async {
    emit(CompanyLoading());
    try {
      final companies = await fetchCompaniesByCategory(event.categoryId);
      emit(CompanyLoaded(companies));
    } catch (e) {
      emit(CompanyError(e.toString()));
    }
  }
} 