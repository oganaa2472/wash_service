import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/pages/splash_screen.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/otp_verification_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/home/assistant_page.dart';
import '../../presentation/pages/home/add_company_page.dart';
import '../../presentation/pages/home/edit_company_page.dart';
import '../../presentation/pages/home/wash_service_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../../presentation/pages/version_check_page.dart';
import '../../presentation/pages/user/user_list_page.dart';
import '../../domain/entities/company.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String otpVerification = '/otp-verification';
  static const String assistant = '/assistant';
  static const String home = '/home';
  static const String addCompany = '/add-company';
  static const String editCompany = '/edit-company';
  static const String washService = '/wash-service';
  static const String userList = '/user-list';
  static const String settings = '/settings';
  static const String versionCheck = '/version-check';

  static GoRouter get router => GoRouter(
    initialLocation: home,
    routes: [
      // Splash Screen
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Authentication Routes
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      
      GoRoute(
        path: otpVerification,
        name: 'otp-verification',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>?;
          return OtpVerificationPage(
            contact: params?['contact'] ?? '',
            isPhone: params?['isPhone'] ?? false,
          );
        },
      ),
      
      // Main App Routes
      GoRoute(
        path: assistant,
        name: 'assistant',
        builder: (context, state) => const AssistantPage(),
      ),
      
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) {
          final userType = state.extra as Map<String, dynamic>?;
          return HomePage(
            userType: userType?['userType'] ?? UserType.customer,
          );
        },
      ),
      
      GoRoute(
        path: addCompany,
        name: 'add-company',
        builder: (context, state) => const AddCompanyPage(),
      ),
      
      GoRoute(
        path: editCompany,
        name: 'edit-company',
        builder: (context, state) {
          final company = state.extra as Map<String, dynamic>?;
          return EditCompanyPage(
            company: company?['company'] ?? Company(
              id: '',
              name: '',
              address: '',
              logo: '',
              point: '',
              category: null,
            ),
          );
        },
      ),
      
      GoRoute(
        path: washService,
        name: 'wash-service',
        builder: (context, state) {
           final company = state.extra as Map<String, dynamic>?;
          return WashServicePage(
            company: company?['company'] ?? Company(
              id: '',
              name: '',
              address: '',
              logo: '',
              point: '',
              category: null,
            ),
          );
        },
      ),
      
      // User List Route
      GoRoute(
        path: userList,
        name: 'user-list',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>?;
          return UserListPage(
            company: params?['company'],
          );
        },
      ),
      
      // Settings Route
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      
      // Version Check Route
      GoRoute(
        path: versionCheck,
        name: 'version-check',
        builder: (context, state) => const VersionCheckPage(),
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
} 