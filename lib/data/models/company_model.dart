import '../../domain/entities/company.dart';

class CompanyModel {
  final String id;
  final String name;
  final String? logo;
  final String? point;
  final String? address;
  final CompanyCategoryModel? category;

  CompanyModel({
    required this.id,
    required this.name,
    this.logo,
    this.point,
    this.address,
    this.category,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'],
      point: json['point'],
      address: json['address'],
      category: json['category'] != null
          ? CompanyCategoryModel.fromJson(json['category'])
          : null,
    );
  }

  Company toEntity() {
    return Company(
      id: id,
      name: name,
      logo: logo,
      point: point,
      address: address,
      category: category?.toEntity(),
    );
  }
}

class CompanyCategoryModel {
  final String id;
  final String name;
  CompanyCategoryModel({required this.id, required this.name});

  factory CompanyCategoryModel.fromJson(Map<String, dynamic> json) {
    return CompanyCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  CompanyCategory toEntity() {
    return CompanyCategory(id: id, name: name);
  }
} 