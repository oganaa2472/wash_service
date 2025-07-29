import 'package:flutter_bloc/flutter_bloc.dart';
import 'wash_employee_event.dart';
import 'wash_employee_state.dart';
import '../../../domain/usecases/get_wash_employees.dart';

class WashEmployeeBloc extends Bloc<WashEmployeeEvent, WashEmployeeState> {
  final GetWashEmployees getWashEmployees;

  WashEmployeeBloc(this.getWashEmployees) : super(WashEmployeeInitial()) {
    on<FetchWashEmployees>(_onFetchWashEmployees);
  }

  Future<void> _onFetchWashEmployees(
    FetchWashEmployees event,
    Emitter<WashEmployeeState> emit,
  ) async {
    emit(WashEmployeeLoading());
    try {
      final employees = await getWashEmployees(event.companyId);
      emit(WashEmployeeLoaded(employees));
    } catch (e) {
      emit(WashEmployeeError(e.toString()));
    }
  }
} 