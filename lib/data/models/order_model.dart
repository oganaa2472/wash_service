import '../../domain/entities/order.dart';

class OrderModel extends Order {
  OrderModel({
    required int id,
    required int companyId,
    required int serviceCategoryId,
    required int carId,
    required List<int> workerIds,
    required DateTime createdAt,
    required String status,
  }) : super(
          id: id,
          companyId: companyId,
          serviceCategoryId: serviceCategoryId,
          carId: carId,
          workerIds: workerIds,
          createdAt: createdAt,
          status: status,
        );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      companyId: json['companyId'],
      serviceCategoryId: json['serviceCategoryId'],
      carId: json['carId'],
      workerIds: List<int>.from(json['workerIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'companyId': companyId,
        'serviceCategoryId': serviceCategoryId,
        'carId': carId,
        'workerIds': workerIds,
        'createdAt': createdAt.toIso8601String(),
        'status': status,
      };
} 