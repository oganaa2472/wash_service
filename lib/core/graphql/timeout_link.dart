import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';

class TimeoutLink extends Link {
  final Duration timeout;

  TimeoutLink({
    this.timeout = const Duration(seconds: 30),
  });

  @override
  Stream<Response> request(Request request, [forward]) async* {
    try {
      await for (final response in forward!(request).timeout(timeout)) {
        yield response;
      }
    } on TimeoutException {
      throw OperationException(
        graphqlErrors: [
          GraphQLError(
            message: 'Request timed out after ${timeout.inSeconds} seconds',
            extensions: {'code': 'TIMEOUT'},
          ),
        ],
      );
    }
  }
} 