import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/graphql/payment_order_mutations.dart';

class PaymentOrderMutationDataSource {
  final GraphQLClient client;
  
  PaymentOrderMutationDataSource(this.client);
  
  Future<String> processOrderPayment({
    required String orderId,
    required String amount,
    required String paymentMethodId,
    required bool isConfirmed,
    required String paymentDate,
  }) async {
    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(PaymentOrderMutations.washOrderPayment(
            orderId: orderId,
            amount: amount,
            paymentMethodId: paymentMethodId,
            isConfirmed: isConfirmed,
            paymentDate: paymentDate,
          )),
        ),
      );
      
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }
      
      final data = result.data;
      if (data == null || data['washOrderPayment'] == null) {
        throw Exception('Payment failed: No response data');
      }
      
      final orderPayment = data['washOrderPayment']['orderPayment'];
      if (orderPayment == null || orderPayment['id'] == null) {
        throw Exception('Payment failed: No payment ID returned');
      }
      
      return orderPayment['id'].toString();
    } catch (e) {
      throw Exception('Failed to process order payment: $e');
    }
  }
} 