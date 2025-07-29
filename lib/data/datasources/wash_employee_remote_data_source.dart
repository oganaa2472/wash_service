import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/graphql/employee_queries.dart';
import '../models/wash_employee_model.dart';

class WashEmployeeRemoteDataSource {
  final GraphQLClient client;

  WashEmployeeRemoteDataSource(this.client);

  Future<List<WashEmployeeModel>> getWashEmployees(String companyId) async {
    try {
      final result = await client.query(
        QueryOptions(
          document: gql(EmployeeQueries.getWashEmployees(companyId)),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data;
      if (data == null || data['washEmployee'] == null) {
        return [];
      }

      final List<dynamic> employeesJson = data['washEmployee'] as List<dynamic>;
      return employeesJson
          .map((json) => WashEmployeeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch wash employees: $e');
    }
  }
} 