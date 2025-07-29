import '../../domain/entities/car.dart' as domain;

class CarModel {
  final String id;
  final String phone;
  final String licensePlate;
  final CarMakeModel make;
  final CarModelModel model;
  final String color;

  CarModel({
    required this.id,
    required this.phone,
    required this.licensePlate,
    required this.make,
    required this.model,
    required this.color,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] ?? '',
      phone: json['phone'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      make: CarMakeModel.fromJson(json['make'] ?? {}),
      model: CarModelModel.fromJson(json['model'] ?? {}),
      color: json['color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'licensePlate': licensePlate,
      'make': make.toJson(),
      'model': model.toJson(),
      'color': color,
    };
  }

  domain.Car toEntity() {
    return domain.Car(
      id: id,
      phone: phone,
      licensePlate: licensePlate,
      make: make.toEntity(),
      model: model.toEntity(),
      color: color,
    );
  }
}

class CarMakeModel {
  final String name;

  CarMakeModel({required this.name});

  factory CarMakeModel.fromJson(Map<String, dynamic> json) {
    return CarMakeModel(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  domain.CarMake toEntity() {
    return domain.CarMake(name: name);
  }
}

class CarModelModel {
  final String name;

  CarModelModel({required this.name});

  factory CarModelModel.fromJson(Map<String, dynamic> json) {
    return CarModelModel(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  domain.CarModel toEntity() {
    return domain.CarModel(name: name);
  }
} 