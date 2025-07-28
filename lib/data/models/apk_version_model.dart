import '../../domain/entities/apk_version.dart';
import '../../domain/entities/category.dart';

class ApkVersionModel {
  final String id;
  final String version;
  final DateTime updatedAt;
  final CategoryModel category;

  const ApkVersionModel({
    required this.id,
    required this.version,
    required this.updatedAt,
    required this.category,
  });

  factory ApkVersionModel.fromJson(Map<String, dynamic> json) {
    return ApkVersionModel(
      id: json['id'] as String,
      version: json['version'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'updatedAt': updatedAt.toIso8601String(),
      'category': category.toJson(),
    };
  }

  // Convert to domain entity
  ApkVersion toEntity() {
    return ApkVersion(
      id: id,
      version: version,
      updatedAt: updatedAt,
      category: category.toEntity(),
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final int order;
  final String icon;
  final String description;
  final DateTime createdAt;
  final DateTime? deleteDate;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.order,
    required this.icon,
    required this.description,
    required this.createdAt,
    this.deleteDate,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      order: json['order'] as int,
      icon: json['icon'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      deleteDate: json['deleteDate'] != null 
          ? DateTime.parse(json['deleteDate'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order': order,
      'icon': icon,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'deleteDate': deleteDate?.toIso8601String(),
    };
  }

  // Convert to domain entity
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      order: order,
      icon: icon,
      description: description,
      createdAt: createdAt,
      deleteDate: deleteDate,
    );
  }
} 