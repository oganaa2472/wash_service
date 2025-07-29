import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/payment_method_repository.dart';
import '../datasources/payment_method_remote_data_source.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodRemoteDataSource remoteDataSource;

  PaymentMethodRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final paymentMethodModels = await remoteDataSource.getPaymentMethods();
      return paymentMethodModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get payment methods: $e');
    }
  }
} 