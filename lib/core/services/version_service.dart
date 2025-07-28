import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../domain/entities/apk_version.dart';
import '../../domain/usecases/get_apk_version.dart';

class VersionService {
  final GetApkVersion getApkVersion;

  VersionService(this.getApkVersion);

  /// Get current platform (iOS or Android)
  String get platform {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'unknown';
  }

  /// Get current app version using package_info_plus
  Future<String> getCurrentVersion() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      print('Error getting app version: $e');
      return '1.0.0'; // Fallback version
    }
  }

  /// Get comprehensive app information
  Future<Map<String, String>> getAppInfo() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return {
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
        'packageName': packageInfo.packageName,
        'appName': packageInfo.appName,
        'platform': platform,
      };
    } catch (e) {
      print('Error getting app info: $e');
      return {
        'version': '1.0.0',
        'buildNumber': '1',
        'packageName': 'com.example.mgl_smart_service',
        'appName': 'MGL Smart Service',
        'platform': platform,
      };
    }
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

  /// Launch app store for update based on platform
  Future<void> launchAppStore() async {
    try {
      // Get the app package name
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;
      
      String url;
      
      // Create platform-specific app store URL
      if (Platform.isIOS) {
        // iOS App Store URL
        url = 'https://apps.apple.com/app/id$packageName';
      } else if (Platform.isAndroid) {
        // Android Play Store URL
        url = 'https://play.google.com/store/apps/details?id=$packageName';
      } else {
        throw Exception('Unsupported platform for app store launch');
      }
      
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch app store');
      }
    } catch (e) {
      print('Error launching app store: $e');
      throw Exception('Failed to open app store: $e');
    }
  }

  /// Get platform-specific app store name
  String getAppStoreName() {
    if (Platform.isIOS) {
      return 'App Store';
    } else if (Platform.isAndroid) {
      return 'Google Play Store';
    } else {
      return 'App Store';
    }
  }

  /// Get platform-specific update message
  String getUpdateMessage() {
    if (Platform.isIOS) {
      return 'A new version is available on the App Store.';
    } else if (Platform.isAndroid) {
      return 'A new version is available on Google Play Store.';
    } else {
      return 'A new version is available.';
    }
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