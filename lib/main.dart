import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/graphql/graphql_client.dart';
import 'core/di/locator_service.dart';
import 'presentation/pages/splash_screen.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/pages/home/home_page.dart';
import 'dart:io';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  await LocatorService.init();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = GraphQLConfig.initializeClient();
    
    return GraphQLProvider(
      client: client,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => locator<AuthBloc>(),
          ),
        ],
        child: MaterialApp(
          title: 'MGL Smart Wash',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
