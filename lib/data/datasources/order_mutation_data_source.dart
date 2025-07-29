import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/graphql/order_mutations.dart';

class OrderMutationDataSource {
  final GraphQLClient client;

  OrderMutationDataSource(this.client);

  Future<String> addOrder({
    required String carId,
    required String carPlateNumber,
    required String organizationId,
    required String selectedServiceId,
    required String status,
    required String totalPrice,
    required String completedAt,
  }) async {
    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(OrderMutations.addOrder(
            carId: carId,
            carPlateNumber: carPlateNumber,
            organizationId: organizationId,
            selectedServiceId: selectedServiceId,
            status: "PENDING",
            totalPrice: totalPrice,
            completedAt: completedAt,
          )),
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data;
      if (data == null || data['washCarOrder'] == null) {
        throw Exception('Failed to create order: No data returned');
      }

      final orderData = data['washCarOrder']['carWashOrder'];
      if (orderData == null || orderData['id'] == null) {
        throw Exception('Failed to create order: No order ID returned');
      }

      return orderData['id'].toString();
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }
} 