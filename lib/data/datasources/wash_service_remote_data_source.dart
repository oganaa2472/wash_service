import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/graphql/service_queries.dart';
import '../models/wash_service_model.dart';

class WashServiceRemoteDataSource {
  final GraphQLClient client;

  WashServiceRemoteDataSource(this.client);

  Future<List<WashServiceModel>> getWashServices(String companyId) async {
    try {
      final result = await client.query(
        QueryOptions(
          document: gql(ServiceQueries.getWashServices(companyId)),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data;
      if (data == null || data['washService'] == null) {
        return [];
      }

      final List<dynamic> servicesJson = data['washService'];
      return servicesJson.map((json) => WashServiceModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch wash services: $e');
    }
  }
} 