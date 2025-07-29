import 'package:flutter_bloc/flutter_bloc.dart';
import 'wash_service_event.dart';
import 'wash_service_state.dart';
import '../../../domain/usecases/get_wash_services.dart';

class WashServiceBloc extends Bloc<WashServiceEvent, WashServiceState> {
  final GetWashServices getWashServices;

  WashServiceBloc(this.getWashServices) : super(WashServiceInitial()) {
    on<FetchWashServices>(_onFetchWashServices);
  }

  Future<void> _onFetchWashServices(
    FetchWashServices event,
    Emitter<WashServiceState> emit,
  ) async {
    emit(WashServiceLoading());
    try {
      final services = await getWashServices(event.companyId);
      emit(WashServiceLoaded(services));
    } catch (e) {
      emit(WashServiceError(e.toString()));
    }
  }
} 