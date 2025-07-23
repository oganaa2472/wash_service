import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class GraphQLConfig {
  static Future<GraphQLClient> getClient() async {
    await initHiveForFlutter();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    final HttpLink httpLink = HttpLink(AppConstants.graphqlEndpoint);

    final AuthLink authLink = AuthLink(
      getToken: () => token != null ? 'Bearer $token' : null,
    );

    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: link,
    );
  }

  static ValueNotifier<GraphQLClient> initializeClient() {
    final HttpLink httpLink = HttpLink(AppConstants.graphqlEndpoint);

    return ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(store: HiveStore()),
        link: httpLink,
      ),
    );
  }
} 