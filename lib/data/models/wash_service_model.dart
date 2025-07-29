import '../../domain/entities/wash_service.dart';

class WashServiceModel {
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
  final ServiceCategoryModel category;

  WashServiceModel({
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

  factory WashServiceModel.fromJson(Map<String, dynamic> json) {
    return WashServiceModel(
      id: json['id'].toString() ?? '',
      organizationId: json['organizationId'].toString() ?? '',
      name: json['name'].toString() ?? '',
      description: json['description'].toString() ?? '',
      price: (json['price'] ?? '0').toString(),
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      deleteDate: json['deleteDate'] != null ? DateTime.parse(json['deleteDate']) : null,
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      category: ServiceCategoryModel.fromJson(json['category'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizationId': organizationId,
      'name': name,
      'description': description,
      'price': price,
      'order': order,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'deleteDate': deleteDate?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'category': category.toJson(),
    };
  }

  WashService toEntity() {
    return WashService(
      id: id,
      organizationId: organizationId,
      name: name,
      description: description,
      price: price,
      order: order,
      isActive: isActive,
      createdAt: createdAt,
      deleteDate: deleteDate,
      updatedAt: updatedAt,
      category: category.toEntity(),
    );
  }
}

class ServiceCategoryModel {
  final String id;
  final String name;
  final String description;
  final int order;
  final String carInfo;
  final DateTime createdAt;
  final DateTime? deleteDate;
  final DateTime updatedAt;

  ServiceCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.order,
    required this.carInfo,
    required this.createdAt,
    this.deleteDate,
    required this.updatedAt,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['id'].toString() ?? '',
      name: json['name'].toString() ?? '',
      description: json['description'].toString() ?? '',
      order: json['order'] ?? 0,
      carInfo: json['carInfo'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      deleteDate: json['deleteDate'] != null ? DateTime.parse(json['deleteDate']) : null,
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'order': order,
      'carInfo': carInfo,
      'createdAt': createdAt.toIso8601String(),
      'deleteDate': deleteDate?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ServiceCategory toEntity() {
    return ServiceCategory(
      id: id,
      name: name,
      description: description,
      order: order,
      carInfo: carInfo,
      createdAt: createdAt,
      deleteDate: deleteDate,
      updatedAt: updatedAt,
    );
  }
} 