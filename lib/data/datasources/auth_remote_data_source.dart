import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/user_model.dart';
import '../../core/errors/failures.dart';
import '../../core/constants/app_constants.dart';
import '../../core/graphql/auth_queries.dart';
import '../../core/storage/shared_prefs_service.dart';

abstract class AuthRemoteDataSource {
  Future<void> requestOtp({required String contact, required bool isPhone});
  Future<UserModel> verifyOtp({
    required String contact,
    required String otp,
    required bool isPhone,
  });
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
  Future<void> requestOtp({
    required String contact,
    required bool isPhone,
  }) async {
    try {
      debugPrint('Attempting to send OTP to: $contact (isPhone: $isPhone)');
      
      late final QueryResult result;
      if (!isPhone) {
        debugPrint('Sending email OTP with mutation: ${AuthQueries.requestOtpEmail}');
        debugPrint('Variables: {"email": "$contact"}');
        
        result = await client.mutate(
          MutationOptions(
            document: gql(AuthQueries.requestOtpEmail),
            variables: {
              'email': contact,
            },
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        );
      } else {
        debugPrint('Sending phone OTP with mutation: ${AuthQueries.requestOtpPhone}');
        debugPrint('Variables: {"phone": "$contact"}');
        
        result = await client.mutate(
          MutationOptions(
            document: gql(AuthQueries.requestOtpPhone),
            variables: {
              'phone': contact,
            },
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        );
      }

      debugPrint('Raw GraphQL Response: ${result.data}');
      
      if (result.hasException) {
        debugPrint('GraphQL Errors: ${result.exception?.graphqlErrors}');
        debugPrint('Network Error: ${result.exception?.linkException}');
        
        final errorMessage = result.exception?.graphqlErrors.firstOrNull?.message ??
            result.exception?.linkException.toString() ??
            'Failed to send OTP';
            
        throw ServerFailure(message: errorMessage);
      }

      if (result.data == null) {
        debugPrint('No data received from server');
        throw ServerFailure(message: 'No response from server');
      }

      // Verify the response structure
      if (isPhone) {
        final phoneResponse = result.data!['phoneCode'];
        if (phoneResponse == null || phoneResponse['phone'] == null) {
          debugPrint('Invalid phone response structure: $phoneResponse');
          throw ServerFailure(message: 'Invalid server response for phone OTP');
        }
      } else {
        final emailResponse = result.data!['mailCode'];
        if (emailResponse == null || emailResponse['mail'] == null) {
          debugPrint('Invalid email response structure: $emailResponse');
          throw ServerFailure(message: 'Invalid server response for email OTP');
        }
      }

      debugPrint('OTP sent successfully');
    } catch (e, stackTrace) {
      debugPrint('Error sending OTP: $e');
      debugPrint('Stack trace: $stackTrace');
      if (e is ServerFailure) {
        rethrow;
      }
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<UserModel> verifyOtp({
    required String contact,
    required String otp,
    required bool isPhone,
  }) async {
    try {
      debugPrint('Verifying OTP for contact: $contact');
      
      final result = await client.mutate(
        MutationOptions(
          document: gql(AuthQueries.verifyOtp),
          variables: {
            'contact': contact,
            'code': otp,
            'isPhone': isPhone,
          },
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      debugPrint('Verify OTP Response: ${result.data}');

      if (result.hasException) {
        debugPrint('GraphQL Errors: ${result.exception?.graphqlErrors}');
        debugPrint('Network Error: ${result.exception?.linkException}');
        throw ServerFailure(
          message: result.exception?.graphqlErrors.firstOrNull?.message ?? 'Invalid OTP',
        );
      }

      if (result.data == null || result.data!['verifyCode'] == null) {
        throw ServerFailure(message: 'Invalid response from server');
      }

      final token = result.data!['verifyCode']['token'] as String;
      await prefsService.setAuthToken(token);

      final user = UserModel.fromJson(result.data!['verifyCode']['user']);
      await prefsService.setUserData(user.toJson().toString());

      return user;
    } catch (e, stackTrace) {
      debugPrint('Error verifying OTP: $e');
      debugPrint('Stack trace: $stackTrace');
      if (e is ServerFailure) {
        rethrow;
      }
      throw ServerFailure(message: e.toString());
    }
  }

  @override
  Future<bool> logout() async {
    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(AuthQueries.logout),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw ServerFailure(
          message: result.exception?.graphqlErrors.firstOrNull?.message ?? 'Logout failed',
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
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw ServerFailure(
          message: result.exception?.graphqlErrors.firstOrNull?.message ?? 'Failed to get current user',
        );
      }

      final user = UserModel.fromJson(result.data!['me']);
      await prefsService.setUserData(user.toJson().toString());
      
      return user;
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
} 