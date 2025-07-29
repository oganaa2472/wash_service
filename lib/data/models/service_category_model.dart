import '../../domain/entities/service_category.dart';

class ServiceCategoryModel extends ServiceCategory {
  ServiceCategoryModel({required String id, required String name}) : super(id: id, name: name);

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['id'].toString(),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
} 