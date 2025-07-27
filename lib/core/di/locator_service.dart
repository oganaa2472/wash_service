import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/shared_prefs_service.dart';
import '../graphql/graphql_client.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';

final GetIt locator = GetIt.instance;

class LocatorService {
  static Future<void> init() async {
    // External Services
    final sharedPreferences = await SharedPreferences.getInstance();
    locator.registerLazySingleton(() => sharedPreferences);

    // Core Services
    locator.registerLazySingleton(() => SharedPrefsService(locator()));
    locator.registerLazySingleton(() => GraphQLConfig());
    
    final client = await GraphQLConfig.getClient();
    locator.registerLazySingleton(() => client);

    // Data Sources
    locator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        client: locator(),
        prefsService: locator(),
      ),
    );

    // Repositories
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: locator()),
    );

    // BLoCs
    locator.registerFactory(() => AuthBloc(authRepository: locator()));
  }

  static void reset() {
    locator.reset();
  }

  static void resetLazySingleton<T extends Object>() {
    if (locator.isRegistered<T>()) {
      locator.resetLazySingleton<T>();
    }
  }

  static bool isRegistered<T extends Object>() {
    return locator.isRegistered<T>();
  }
} 