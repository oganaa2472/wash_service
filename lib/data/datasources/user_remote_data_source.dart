import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/graphql/graphql_client.dart';
import '../../core/graphql/service_queries.dart';
import '../../domain/entities/user.dart';

abstract class UserRemoteDataSource {
  Future<List<User>> getUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final GraphQLClient client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<List<User>> getUsers() async {
    try {
      print('UserRemoteDataSource: Starting GraphQL query');
      print('UserRemoteDataSource: Query: ${ServiceQueries.getUsers}');
      
      final result = await client.query(
        QueryOptions(
          document: gql(ServiceQueries.getUsers),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      print('UserRemoteDataSource: Query completed');
      print('UserRemoteDataSource: Has exception: ${result.hasException}');
      
      if (result.hasException) {
        print('UserRemoteDataSource: Exception: ${result.exception.toString()}');
        throw Exception('Failed to fetch users: ${result.exception.toString()}');
      }

      print('UserRemoteDataSource: Raw data: ${result.data}');
      final List<dynamic> washEmployeeData = result.data?['washEmployee'] ?? [];
      print('UserRemoteDataSource: WashEmployee data length: ${washEmployeeData.length}');
      
      final users = washEmployeeData.map((washEmployeeItem) {
        print('UserRemoteDataSource: Processing washEmployee data: $washEmployeeItem');
        final employeeData = washEmployeeItem['employee'];
        print('UserRemoteDataSource: Employee data: $employeeData');
        
        if (employeeData == null) {
          print('UserRemoteDataSource: No employee data found, skipping');
          return null;
        }
        
        return User(
          id: employeeData['id']?.toString(),
          username: employeeData['username']?.toString(),
          lastName: employeeData['lastName']?.toString(),
          email: employeeData['email']?.toString(),
          phone: employeeData['phone']?.toString(),
        );
      }).where((user) => user != null).cast<User>().toList();
      
      print('UserRemoteDataSource: Returning ${users.length} users');
      return users;
    } catch (e) {
      print('UserRemoteDataSource: Error: $e');
      throw Exception('Failed to fetch users: $e');
    }
  }
}
