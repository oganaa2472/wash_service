import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/graphql/graphql_client.dart';
import '../../core/graphql/time_queries.dart';

class TimeRemoteDataSource {
  Future<Map<String, dynamic>> getServerTime() async {
    try {
      final client = await GraphQLConfig.getClient(
        timeout: const Duration(seconds: 10),
      );

      final result = await client.query(
        QueryOptions(
          document: gql(TimeQueries.getServerTime),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      return result.data?['serverTime'] ?? {};
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getTimeSlots(String date) async {
    try {
      final client = await GraphQLConfig.getClient(
        timeout: const Duration(seconds: 15),
      );

      final result = await client.query(
        QueryOptions(
          document: gql(TimeQueries.getTimeSlots),
          variables: {'date': date},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      final slots = result.data?['timeSlots'] as List<dynamic>?;
      return slots?.map((slot) => slot as Map<String, dynamic>).toList() ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> bookTimeSlot({
    required String slotId,
    required String serviceId,
  }) async {
    try {
      final client = await GraphQLConfig.getClient(
        timeout: const Duration(seconds: 20),
      );

      final result = await client.mutate(
        MutationOptions(
          document: gql(TimeQueries.bookTimeSlot),
          variables: {
            'slotId': slotId,
            'serviceId': serviceId,
          },
        ),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      return result.data?['bookTimeSlot'] ?? {};
    } catch (e) {
      rethrow;
    }
  }
} 