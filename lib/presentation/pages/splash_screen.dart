import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../core/constants/app_constants.dart';
import 'auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/storage/shared_prefs_service.dart';
import '../../core/services/version_service.dart';
import '../../domain/usecases/get_apk_version.dart';
import '../../domain/entities/apk_version.dart';
import '../../data/repositories/version_repository_impl.dart';
import '../../data/datasources/version_remote_data_source.dart';
import '../widgets/version_update_dialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late VersionService _versionService;

  @override
  void initState() {
    super.initState();
    _initializeVersionService();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: AppConstants.splashAnimationDuration),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    Timer(
      Duration(seconds: AppConstants.splashScreenDuration),
      () {
        _checkVersionAndNavigate();
      },
    );
  }

  void _initializeVersionService() {
    final remoteDataSource = VersionRemoteDataSource();
    final repository = VersionRepositoryImpl(remoteDataSource);
    final useCase = GetApkVersion(repository);
    _versionService = VersionService(useCase);
  }

  Future<void> _checkVersionAndNavigate() async {
    try {
      // Check for updates in the background
      bool updateAvailable = await _versionService.isUpdateAvailable(1);
      
      if (updateAvailable && mounted) {
        final latestVersion = await _versionService.getLatestVersion(1);
        if (latestVersion != null) {
          _showUpdateDialog(latestVersion);
          return; // Don't navigate yet, wait for user action
        }
      }
      
      // No update available or error, proceed with normal navigation
      _navigateToNextScreen();
    } catch (e) {
      print('Version check failed: $e');
      // Proceed with navigation even if version check fails
      _navigateToNextScreen();
    }
  }

  void _showUpdateDialog(ApkVersion latestVersion) async {
    final currentVersion = await _versionService.getCurrentVersion();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VersionUpdateDialog(
        latestVersion: latestVersion,
        currentVersion: currentVersion,
        onUpdate: () {
          Navigator.of(context).pop();
          _versionService.launchAppStore();
          // Still navigate to the app after launching store
          _navigateToNextScreen();
        },
        onSkip: () {
          Navigator.of(context).pop();
          _navigateToNextScreen();
        },
      ),
    );
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final sharedPrefsService = SharedPrefsService(prefs);

    bool loggedIn = sharedPrefsService.isLoggedIn();
    if (loggedIn) {
      context.go('/assistant');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo animation
              ScaleTransition(
                scale: _animation,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.local_car_wash,
                      size: 80,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // App name with fade animation
              FadeTransition(
                opacity: _animation,
                child: Text(
                  AppConstants.appName,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Tagline with fade animation
              FadeTransition(
                opacity: _animation,
                child: Text(
                  AppConstants.appTagline,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 