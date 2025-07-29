import '../entities/payment_method.dart';
import '../repositories/payment_method_repository.dart';

class GetPaymentMethods {
  final PaymentMethodRepository repository;

  GetPaymentMethods(this.repository);

  Future<List<PaymentMethod>> call() async {
    try {
      return await repository.getPaymentMethods();
    } catch (e) {
      throw Exception('Failed to get payment methods: $e');
    }
  }
} 