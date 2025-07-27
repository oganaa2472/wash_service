import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/company_model.dart';
import '../../core/graphql/auth_queries.dart';
import '../../core/graphql/graphql_client.dart';

class CompanyRemoteDataSource {
  Future<List<CompanyModel>> fetchCompaniesByCategory(int categoryId) async {
   
    final client = await GraphQLConfig.getClient();
    final result = await client.query(
      QueryOptions(
        document: gql(AuthQueries.getCompaniesByCategory),
        variables: {'searchBy': ['category_id=$categoryId']},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    final List data = result.data?['company'] ?? [];
    return data.map((e) => CompanyModel.fromJson(e)).toList();
  }

  Future<bool> createCompany({required String name, required String address, String? logo}) async {
    final client = await GraphQLConfig.getClient();
    final result = await client.mutate(
      MutationOptions(
        document: gql(AuthQueries.createCompany),
        variables: {
          'name': name,
          'address': address,
          'logo': logo,
        },
      ),
    );
    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    return result.data?['createCompany'] != null;
  }
} 