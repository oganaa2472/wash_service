import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/graphql/employee_mutations.dart';

class EmployeeMutationDataSource {
  final GraphQLClient client;

  EmployeeMutationDataSource(this.client);

  Future<String> assignEmployeeToOrder({
    required String orderId,
    required String workId,
    required String assignedAt,
    required String calculatedSalary,
  }) async {
    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(EmployeeMutations.assignEmployeeToOrder(
            orderId: orderId,
            workId: workId,
            assignedAt: assignedAt,
            calculatedSalary:calculatedSalary    
          )),
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data;
      if (data == null || data['washOrderEmployee'] == null) {
        throw Exception('Failed to assign employee: No data returned');
      }

      final orderEmployeeData = data['washOrderEmployee']['orderEmployee'];
      if (orderEmployeeData == null || orderEmployeeData['id'] == null) {
        throw Exception('Failed to assign employee: No assignment ID returned');
      }

      return orderEmployeeData['id'].toString();
    } catch (e) {
      throw Exception('Failed to assign employee to order: $e');
    }
  }
} 