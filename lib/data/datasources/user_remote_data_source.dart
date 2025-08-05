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
      print(result.data);
      print('UserRemoteDataSource: Query completed');
      print('UserRemoteDataSource: Has exception: ${result.hasException}');
      
      if (result.hasException) {
        print('UserRemoteDataSource: Exception: ${result.exception.toString()}');
        throw Exception('Failed to fetch users: ${result.exception.toString()}');
      }

      print('UserRemoteDataSource: Raw data: ${result.data}');
      final List<dynamic> usersData = result.data?['users'] ?? [];
      print('UserRemoteDataSource: Users data length: ${usersData.length}');
      
      final users = usersData.map((userData) {
        print('UserRemoteDataSource: Processing user data: $userData');
        return User(
          id: userData['id']?.toString(),
          username: userData['username']?.toString(),
          lastName: userData['lastName']?.toString(),
          email: userData['email']?.toString(),
          phone: userData['phone']?.toString(),
        );
      }).toList();
      
      print('UserRemoteDataSource: Returning ${users.length} users');
      return users;
    } catch (e) {
      print('UserRemoteDataSource: Error: $e');
      throw Exception('Failed to fetch users: $e');
    }
  }
}
