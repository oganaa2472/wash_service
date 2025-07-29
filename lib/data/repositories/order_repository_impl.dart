import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Order>> getWashCarOrders(String companyId) async {
    try {
      final orderModels = await remoteDataSource.getWashCarOrders(companyId);
      return orderModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get wash car orders: $e');
    }
  }
} 