import 'package:equatable/equatable.dart';

class Car extends Equatable {
  final String id;
  final String phone;
  final String licensePlate;
  final CarMake make;
  final CarModel model;
  final String color;

  Car({
    required this.id,
    required this.phone,
    required this.licensePlate,
    required this.make,
    required this.model,
    required this.color,
  });

  @override
  List<Object?> get props => [
        id,
        phone,
        licensePlate,
        make,
        model,
        color,
      ];
}

class CarMake extends Equatable {
  final String name;

  CarMake({required this.name});

  @override
  List<Object?> get props => [name];
}

class CarModel extends Equatable {
  final String name;

  CarModel({required this.name});

  @override
  List<Object?> get props => [name];
} 