import 'package:equatable/equatable.dart';

class Washer extends Equatable {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Washer({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        isActive,
        createdAt,
        updatedAt,
      ];
} 