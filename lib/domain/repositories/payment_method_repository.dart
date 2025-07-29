import '../entities/payment_method.dart';

abstract class PaymentMethodRepository {
  Future<List<PaymentMethod>> getPaymentMethods();
} 