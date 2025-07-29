import '../entities/car.dart';
import '../repositories/car_repository.dart';

class GetCarList {
  final CarRepository repository;

  GetCarList(this.repository);

  Future<List<Car>> call() async {
    try {
      return await repository.getCarList();
    } catch (e) {
      throw Exception('Failed to get car list: $e');
    }
  }
} 