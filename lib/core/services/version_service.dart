import '../../domain/entities/apk_version.dart';
import '../../domain/usecases/get_apk_version.dart';

class VersionService {
  final GetApkVersion getApkVersion;

  VersionService(this.getApkVersion);

  /// Get current app version (placeholder - you'll need to implement this with package_info_plus)
  Future<String> getCurrentVersion() async {
    // TODO: Implement with package_info_plus
    // final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // return packageInfo.version;
    return '1.0.0'; // Placeholder
  }

  /// Check if update is available
  Future<bool> isUpdateAvailable(int categoryId) async {
    try {
      final currentVersion = await getCurrentVersion();
      final serverVersion = await getApkVersion(categoryId);
      
      if (serverVersion == null) {
        return false;
      }

      return _compareVersions(currentVersion, serverVersion.version) < 0;
    } catch (e) {
      print('Error checking for updates: $e');
      return false;
    }
  }

  /// Get latest version info
  Future<ApkVersion?> getLatestVersion(int categoryId) async {
    try {
      return await getApkVersion(categoryId);
    } catch (e) {
      print('Error getting latest version: $e');
      return null;
    }
  }

  /// Launch app store for update (placeholder - you'll need to implement this with url_launcher)
  Future<void> launchAppStore() async {
    // TODO: Implement with url_launcher
    // const url = 'https://play.google.com/store/apps/details?id=your.app.package';
    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    // } else {
    //   throw Exception('Could not launch app store');
    // }
    print('Launch app store - implement with url_launcher');
  }

  /// Compare two version strings
  int _compareVersions(String version1, String version2) {
    final v1Parts = version1.split('.').map(int.parse).toList();
    final v2Parts = version2.split('.').map(int.parse).toList();
    
    // Pad with zeros if needed
    while (v1Parts.length < v2Parts.length) {
      v1Parts.add(0);
    }
    while (v2Parts.length < v1Parts.length) {
      v2Parts.add(0);
    }
    
    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] < v2Parts[i]) return -1;
      if (v1Parts[i] > v2Parts[i]) return 1;
    }
    
    return 0;
  }
} 