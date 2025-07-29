import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/graphql/payment_method_queries.dart';
import '../models/payment_method_model.dart';

class PaymentMethodRemoteDataSource {
  final GraphQLClient client;

  PaymentMethodRemoteDataSource(this.client);

  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      final result = await client.query(
        QueryOptions(
          document: gql(PaymentMethodQueries.getPaymentMethods),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data;
      if (data == null || data['washPaymentMethod'] == null) {
        return [];
      }

      final List<dynamic> paymentMethodsJson = data['washPaymentMethod'] as List<dynamic>;
      return paymentMethodsJson
          .map((json) => PaymentMethodModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch payment methods: $e');
    }
  }
} 