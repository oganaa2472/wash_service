import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetWashCarOrders {
  final OrderRepository repository;

  GetWashCarOrders(this.repository);

  Future<List<Order>> call(String companyId) async {
    try {
      return await repository.getWashCarOrders(companyId);
    } catch (e) {
      throw Exception('Failed to get wash car orders: $e');
    }
  }
} 