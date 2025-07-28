import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../core/services/version_service.dart';
import '../../domain/usecases/get_apk_version.dart';
import '../../data/repositories/version_repository_impl.dart';
import '../../data/datasources/version_remote_data_source.dart';
import '../widgets/version_update_dialog.dart';

class VersionCheckPage extends StatefulWidget {
  const VersionCheckPage({super.key});

  @override
  State<VersionCheckPage> createState() => _VersionCheckPageState();
}

class _VersionCheckPageState extends State<VersionCheckPage> {
  late VersionService _versionService;
  bool _isChecking = false;
  String _currentVersion = '1.0.0';
  String _buildNumber = '1';
  String _packageName = '';
  String _appName = '';
  String _platform = '';
  bool _updateAvailable = false;

  @override
  void initState() {
    super.initState();
    _initializeVersionService();
    _loadAppInfo();
  }

  void _initializeVersionService() {
    final remoteDataSource = VersionRemoteDataSource();
    final repository = VersionRepositoryImpl(remoteDataSource);
    final useCase = GetApkVersion(repository);
    _versionService = VersionService(useCase);
  }

  Future<void> _loadAppInfo() async {
    try {
      final appInfo = await _versionService.getAppInfo();
      setState(() {
        _currentVersion = appInfo['version'] ?? '1.0.0';
        _buildNumber = appInfo['buildNumber'] ?? '1';
        _packageName = appInfo['packageName'] ?? '';
        _appName = appInfo['appName'] ?? '';
        _platform = appInfo['platform'] ?? '';
      });
    } catch (e) {
      print('Error loading app info: $e');
    }
  }

  Future<void> _checkForUpdates() async {
    setState(() {
      _isChecking = true;
    });

    try {
      // Get current version
      _currentVersion = await _versionService.getCurrentVersion();
      
      // Check for updates (using category ID 1 as per your query)
      _updateAvailable = await _versionService.isUpdateAvailable(1);
      
      if (_updateAvailable) {
        _showUpdateDialog();
      } else {
        _showNoUpdateDialog();
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isChecking = false;
      });
    }
  }

  void _showUpdateDialog() async {
    final latestVersion = await _versionService.getLatestVersion(1);
    if (latestVersion != null && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => VersionUpdateDialog(
          latestVersion: latestVersion,
          currentVersion: _currentVersion,
          onUpdate: () {
            Navigator.of(context).pop();
            _versionService.launchAppStore();
          },
          onSkip: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  void _showNoUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Updates'),
        content: Text('You are using the latest version of the app on $_platform.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Failed to check for updates: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getPlatformDisplayName() {
    switch (_platform) {
      case 'ios':
        return 'iOS';
      case 'android':
        return 'Android';
      case 'web':
        return 'Web';
      default:
        return 'Unknown';
    }
  }

  IconData _getPlatformIcon() {
    switch (_platform) {
      case 'ios':
        return Icons.phone_iphone;
      case 'android':
        return Icons.phone_android;
      case 'web':
        return Icons.web;
      default:
        return Icons.devices;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Version Check'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.system_update,
              size: 80,
              color: Colors.blue.withOpacity(0.6),
            ),
            const SizedBox(height: 24),
            Text(
              _appName.isNotEmpty ? _appName : 'MGL Smart Service',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard('Current Version', _currentVersion),
            const SizedBox(height: 8),
            _buildInfoCard('Build Number', _buildNumber),
            const SizedBox(height: 8),
            _buildInfoCard('Package Name', _packageName),
            const SizedBox(height: 8),
            _buildPlatformCard(),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isChecking ? null : _checkForUpdates,
              icon: _isChecking
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: Text(_isChecking ? 'Checking...' : 'Check for Updates'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_updateAvailable)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Update Available on ${_versionService.getAppStoreName()}!',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _platform == 'ios' 
            ? Colors.blue.withOpacity(0.1)
            : _platform == 'android'
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _platform == 'ios' 
              ? Colors.blue.withOpacity(0.3)
              : _platform == 'android'
                  ? Colors.green.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _getPlatformIcon(),
                size: 20,
                color: _platform == 'ios' 
                    ? Colors.blue
                    : _platform == 'android'
                        ? Colors.green
                        : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                'Platform',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            _getPlatformDisplayName(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _platform == 'ios' 
                  ? Colors.blue
                  : _platform == 'android'
                      ? Colors.green
                      : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
} 