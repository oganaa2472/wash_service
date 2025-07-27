import '../entities/order.dart';
import '../entities/service_category.dart';
import '../entities/car.dart';
import '../entities/worker.dart';

abstract class OrderRepository {
  Future<List<Order>> fetchOrders(int companyId);
  Future<Order> createOrder(Order order);
  Future<List<ServiceCategory>> fetchServiceCategories();
  Future<List<Car>> fetchCars(int userId);
  Future<List<Worker>> fetchWorkers(int companyId);
} 