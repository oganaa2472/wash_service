import '../../domain/entities/washer.dart';

class WasherModel {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WasherModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory WasherModel.fromJson(Map<String, dynamic> json) {
    return WasherModel(
      id: json['id'].toString() ?? '',
      name: json['name'].toString() ?? '',
      phone: json['phone'].toString(),
      email: json['email'].toString(),
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Washer toEntity() {
    return Washer(
      id: id,
      name: name,
      phone: phone,
      email: email,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
} 