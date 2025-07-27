class Order {
  final int id;
  final int companyId;
  final int serviceCategoryId;
  final int carId;
  final List<int> workerIds;
  final DateTime createdAt;
  final String status;

  Order({
    required this.id,
    required this.companyId,
    required this.serviceCategoryId,
    required this.carId,
    required this.workerIds,
    required this.createdAt,
    required this.status,
  });
} 