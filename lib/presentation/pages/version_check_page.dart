import 'package:flutter/material.dart';
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
  bool _updateAvailable = false;

  @override
  void initState() {
    super.initState();
    _initializeVersionService();
  }

  void _initializeVersionService() {
    final remoteDataSource = VersionRemoteDataSource();
    final repository = VersionRepositoryImpl(remoteDataSource);
    final useCase = GetApkVersion(repository);
    _versionService = VersionService(useCase);
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
        content: const Text('You are using the latest version of the app.'),
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
              'Current Version: $_currentVersion',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
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
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Update Available!',
                      style: TextStyle(
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
} 