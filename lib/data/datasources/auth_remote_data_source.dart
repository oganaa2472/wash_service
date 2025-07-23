import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/user_model.dart';
import '../../core/errors/failures.dart';
import '../../core/constants/app_constants.dart';
import '../../core/graphql/auth_queries.dart';
import '../../core/storage/shared_prefs_service.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password, String phoneNumber);
  Future<bool> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final GraphQLClient client;
  final SharedPrefsService prefsService;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.prefsService,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(AuthQueries.login),
          variables: {
            'email': email,
            'password': password,
          },
        ),
      );

      if (result.hasException) {
        throw ServerFailure(
          message: result.exception?.graphqlErrors.first.message ?? 'Login failed',
        );
      }

      final token = result.data?['login']['token'] as String;
      await prefsService.setAuthToken(token);

      final user = UserModel.fromJson(result.data?['login']['user']);
      await prefsService.setUserData(user.toJson().toString());

      return user;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password, String phoneNumber) async {
    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(AuthQueries.register),
          variables: {
            'name': name,
            'email': email,
            'password': password,
            'phoneNumber': phoneNumber,
          },
        ),
      );

      if (result.hasException) {
        throw ServerFailure(
          message: result.exception?.graphqlErrors.first.message ?? 'Registration failed',
        );
      }

      final token = result.data?['register']['token'] as String;
      await prefsService.setAuthToken(token);

      final user = UserModel.fromJson(result.data?['register']['user']);
      await prefsService.setUserData(user.toJson().toString());

      return user;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<bool> logout() async {
    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(AuthQueries.logout),
        ),
      );

      if (result.hasException) {
        throw ServerFailure(
          message: result.exception?.graphqlErrors.first.message ?? 'Logout failed',
        );
      }

      await prefsService.removeAuthToken();
      await prefsService.removeUserData();
      
      return result.data?['logout']['success'] ?? false;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final result = await client.query(
        QueryOptions(
          document: gql(AuthQueries.getCurrentUser),
        ),
      );

      if (result.hasException) {
        throw ServerFailure(
          message: result.exception?.graphqlErrors.first.message ?? 'Failed to get current user',
        );
      }

      final user = UserModel.fromJson(result.data?['me']);
      await prefsService.setUserData(user.toJson().toString());
      
      return user;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
} 