class Order {
  final String id;
  final String organizationId;
  final String carId;
  final String carPlateNumber;
  final Service selectedService;
  final String totalPrice;
  final String status;
  final String paymentStatus;
  final DateTime? completedAt;
  final DateTime orderDate;

  Order({
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
}

class Service {
  final String name;

  Service({required this.name});
} 