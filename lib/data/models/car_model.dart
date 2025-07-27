import '../../domain/entities/car.dart';

class CarModel extends Car {
  CarModel({required int id, required int userId, required String model, required String plateNumber})
      : super(id: id, userId: userId, model: model, plateNumber: plateNumber);

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      userId: json['userId'],
      model: json['model'],
      plateNumber: json['plateNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'model': model,
        'plateNumber': plateNumber,
      };
} 