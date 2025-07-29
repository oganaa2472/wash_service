import '../../domain/entities/car.dart';
import '../../domain/repositories/car_repository.dart';
import '../datasources/car_remote_data_source.dart';

class CarRepositoryImpl implements CarRepository {
  final CarRemoteDataSource remoteDataSource;

  CarRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Car>> getCarList() async {
    try {
      final carModels = await remoteDataSource.getCarList();
      return carModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get car list: $e');
    }
  }
} 