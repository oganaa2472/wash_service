import 'package:graphql_flutter/graphql_flutter.dart';
import '../../core/graphql/car_queries.dart';
import '../models/car_model.dart';

class CarRemoteDataSource {
  final GraphQLClient client;

  CarRemoteDataSource(this.client);

  Future<List<CarModel>> getCarList() async {
    try {
      final result = await client.query(
        QueryOptions(
          document: gql(CarQueries.getCarList),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data;
      if (data == null || data['car'] == null) {
        return [];
      }

      final List<dynamic> carsJson = data['car'];
      return carsJson.map((json) => CarModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch car list: $e');
    }
  }
} 