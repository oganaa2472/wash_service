import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'timeout_link.dart';

class GraphQLConfig {
  static const Duration defaultTimeout = Duration(seconds: 30);

  static Future<GraphQLClient> getClient({Duration timeout = defaultTimeout}) async {
    await initHiveForFlutter();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    final HttpLink httpLink = HttpLink(
      AppConstants.graphqlEndpoint,
      defaultHeaders: {
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'Content-Type': 'application/json',
        'User-Agent': 'MGL-Smart-Wash-App/1.0',
      },
    );
   print(token);
    final AuthLink authLink = AuthLink(
      getToken: () {
        final authToken = token != null ? 'JWT $token' : '';
        // print('GraphQL Auth Token (getClient): $authToken');
        return authToken;
      },
    );

    final ErrorLink errorLink = ErrorLink(
      onGraphQLError: (request, forward, response) {
        debugPrint('GraphQL Error Response: $response');
        debugPrint('Request Operation: ${request.operation.operationName}');
        debugPrint('Request Document: ${request.operation.document}');
        for (final error in response.errors ?? []) {
          debugPrint('Error: ${error.message}');
          debugPrint('Location: ${error.locations}');
          debugPrint('Path: ${error.path}');
          debugPrint('Extensions: ${error.extensions}');
        }
        return forward(request);
      },
      onException: (request, forward, exception) {
        debugPrint('Network Exception: $exception');
        debugPrint('Request Operation: ${request.operation.operationName}');
        debugPrint('Request Document: ${request.operation.document}');
        if (exception is HttpLinkServerException) {
          debugPrint('Server Response: ${exception.response}');
          debugPrint('Response Body: ${exception.response.body}');
          debugPrint('Status Code: ${exception.response.statusCode}');
          debugPrint('Response Headers: ${exception.response.headers}');
        } 
       
        return forward(request);
      },
    );

    final TimeoutLink timeoutLink = TimeoutLink(
      timeout: timeout,
    );

    final Link link = Link.from([
      errorLink,
      timeoutLink,
      authLink,
      httpLink,
    ]);

    return GraphQLClient(
      cache: GraphQLCache(
        store: HiveStore(),
      ),
      link: link,
      defaultPolicies: DefaultPolicies(
        query: Policies(
          fetch: FetchPolicy.networkOnly,
        ),
        mutate: Policies(
          fetch: FetchPolicy.networkOnly,
        ),
        subscribe: Policies(
          fetch: FetchPolicy.networkOnly,
        ),
      ),
    );
  }

  static ValueNotifier<GraphQLClient> initializeClient({Duration timeout = defaultTimeout}) {
    final HttpLink httpLink = HttpLink(
      AppConstants.graphqlEndpoint,
      defaultHeaders: {
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'Content-Type': 'application/json',
        'User-Agent': 'MGL-Smart-Wash-App/1.0',
      },
    );

    final AuthLink authLink = AuthLink(
      getToken: () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('auth_token');
        final authToken = token != null ? 'JWT $token' : '';
        print('GraphQL Auth Token (initializeClient): $authToken');
        print('Raw token from SharedPreferences: $token');
        return authToken;
      },
    );

    final ErrorLink errorLink = ErrorLink(
      onGraphQLError: (request, forward, response) {
        debugPrint('GraphQL Error Response: $response');
        for (final error in response.errors ?? []) {
          debugPrint('Error: ${error.message}');
          debugPrint('Location: ${error.locations}');
          debugPrint('Path: ${error.path}');
          debugPrint('Extensions: ${error.extensions}');
        }
        return forward(request);
      },
      onException: (request, forward, exception) {
        debugPrint('Network Exception: $exception');
        if (exception is HttpLinkServerException) {
          debugPrint('Server Response: ${exception.response}');
          debugPrint('Response Body: ${exception.response.body}');
          debugPrint('Status Code: ${exception.response.statusCode}');
        }
        return forward(request);
      },
    );

    final TimeoutLink timeoutLink = TimeoutLink(
      timeout: timeout,
    );

    final Link link = Link.from([
      errorLink,
      timeoutLink,
      authLink,
      httpLink,
    ]);

    return ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(
          store: HiveStore(),
        ),
        link: link,
        defaultPolicies: DefaultPolicies(
          query: Policies(
            fetch: FetchPolicy.networkOnly,
          ),
          mutate: Policies(
            fetch: FetchPolicy.networkOnly,
          ),
          subscribe: Policies(
            fetch: FetchPolicy.networkOnly,
          ),
        ),
      ),
    );
  }
} 