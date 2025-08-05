import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/graphql/order_queries.dart';
import '../models/order_model.dart';

class OrderRemoteDataSource {
  final GraphQLClient client;

  OrderRemoteDataSource(this.client);

  Future<List<OrderModel>> getWashCarOrders(String companyId) async {
    try {
   print('----companyId , $companyId');
      final result = await client.query(
        QueryOptions(
          document: gql(OrderQueries.getWashCarOrders(companyId)),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data;
   
      if (data == null || data['washCarOrder'] == null) {
        return [];
      }

      final List<dynamic> ordersJson = data['washCarOrder'];
      return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
} 