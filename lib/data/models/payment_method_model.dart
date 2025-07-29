import '../../domain/entities/payment_method.dart' as domain;

class PaymentMethodModel {
  final String id;
  final String name;

  PaymentMethodModel({
    required this.id,
    required this.name,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  domain.PaymentMethod toEntity() {
    return domain.PaymentMethod(
      id: id,
      name: name,
    );
  }
} 