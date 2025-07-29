import '../../domain/entities/order.dart';

class OrderModel {
  final String id;
  final String organizationId;
  final String carId;
  final String carPlateNumber;
  final ServiceModel selectedService;
  final String totalPrice;
  final String status;
  final String paymentStatus;
  final DateTime? completedAt;
  final DateTime orderDate;

  OrderModel({
    required this.id,
    required this.organizationId,
    required this.carId,
    required this.carPlateNumber,
    required this.selectedService,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    this.completedAt,
    required this.orderDate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'].toString() ?? '',
      organizationId: json['organizationId'].toString() ?? '',
      carId: json['carId'].toString() ?? '',
      carPlateNumber: json['carPlateNumber'].toString()  ?? '',
      selectedService: ServiceModel.fromJson(json['selectedService'] ?? {}),
      totalPrice: (json['totalPrice'] ?? '0').toString() ,
      status: json['status'].toString() ?? '',
      paymentStatus: json['paymentStatus'].toString() ?? '',
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      orderDate: DateTime.parse(json['orderDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organizationId': organizationId,
      'carId': carId,
      'carPlateNumber': carPlateNumber,
      'selectedService': selectedService.toJson(),
      'totalPrice': totalPrice,
      'status': status,
      'paymentStatus': paymentStatus,
      'completedAt': completedAt?.toIso8601String(),
      'orderDate': orderDate.toIso8601String(),
    };
  }

  Order toEntity() {
    return Order(
      id: id,
      organizationId: organizationId,
      carId: carId,
      carPlateNumber: carPlateNumber,
      selectedService: selectedService.toEntity(),
      totalPrice: totalPrice,
      status: status,
      paymentStatus: paymentStatus,
      completedAt: completedAt,
      orderDate: orderDate,
    );
  }
}

class ServiceModel {
  final String name;

  ServiceModel({required this.name});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  Service toEntity() {
    return Service(name: name);
  }
} 