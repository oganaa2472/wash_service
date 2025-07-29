import '../entities/car.dart';

abstract class CarRepository {
  Future<List<Car>> getCarList();
} 