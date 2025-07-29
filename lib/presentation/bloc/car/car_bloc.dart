import 'package:flutter_bloc/flutter_bloc.dart';
import 'car_event.dart';
import 'car_state.dart';
import '../../../domain/usecases/get_car_list.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final GetCarList getCarList;

  CarBloc(this.getCarList) : super(CarInitial()) {
    on<FetchCarList>(_onFetchCarList);
  }

  Future<void> _onFetchCarList(
    FetchCarList event,
    Emitter<CarState> emit,
  ) async {
    emit(CarLoading());
    try {
      final cars = await getCarList();
      emit(CarLoaded(cars));
    } catch (e) {
      emit(CarError(e.toString()));
    }
  }
} 