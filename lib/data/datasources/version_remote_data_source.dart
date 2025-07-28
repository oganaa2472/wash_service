import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/graphql/graphql_client.dart';
import '../../core/graphql/version_queries.dart';
import '../../domain/entities/apk_version.dart';
import '../models/apk_version_model.dart';

class VersionRemoteDataSource {
  Future<ApkVersion?> getApkVersion(int categoryId) async {
    try {
      final client = await GraphQLConfig.getClient();
      
      final result = await client.query(
        QueryOptions(
          document: gql(VersionQueries.getApkVersion),
          variables: {
            'categoryId': categoryId,
          },
        ),
      );

      if (result.hasException) {
        throw Exception('Failed to fetch APK version: ${result.exception.toString()}');
      }

      if (result.data == null || result.data!['apkVersion'] == null) {
        return null;
      }

      final model = ApkVersionModel.fromJson(result.data!['apkVersion']);
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to fetch APK version: $e');
    }
  }
} 