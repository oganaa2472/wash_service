import 'package:equatable/equatable.dart';

class WashService extends Equatable {
  final String id;
  final String organizationId;
  final String name;
  final String description;
  final String price;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? deleteDate;
  final DateTime updatedAt;
  final ServiceCategory category;

  WashService({
    required this.id,
    required this.organizationId,
    required this.name,
    required this.description,
    required this.price,
    required this.order,
    required this.isActive,
    required this.createdAt,
    this.deleteDate,
    required this.updatedAt,
    required this.category,
  });

  @override
  List<Object?> get props => [
        id,
        organizationId,
        name,
        description,
        price,
        order,
        isActive,
        createdAt,
        deleteDate,
        updatedAt,
        category,
      ];
}

class ServiceCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final int order;
  final String carInfo;
  final DateTime createdAt;
  final DateTime? deleteDate;
  final DateTime updatedAt;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.order,
    required this.carInfo,
    required this.createdAt,
    this.deleteDate,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        order,
        carInfo,
        createdAt,
        deleteDate,
        updatedAt,
      ];
} 