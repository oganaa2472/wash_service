import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../domain/entities/apk_version.dart';

class VersionUpdateDialog extends StatelessWidget {
  final ApkVersion latestVersion;
  final String currentVersion;
  final VoidCallback onUpdate;
  final VoidCallback? onSkip;

  const VersionUpdateDialog({
    super.key,
    required this.latestVersion,
    required this.currentVersion,
    required this.onUpdate,
    this.onSkip,
  });

  /// Get current platform
  String get platform {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'unknown';
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
      return 'A new version of the app is available.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.system_update,
            color: Colors.blue,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            'Update Available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getUpdateMessage(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          _buildVersionInfo('Current Version', currentVersion),
          const SizedBox(height: 8),
          _buildVersionInfo('Latest Version', latestVersion.version),
          const SizedBox(height: 8),
          _buildVersionInfo('Updated', _formatDate(latestVersion.updatedAt)),
          const SizedBox(height: 8),
          _buildVersionInfo('Platform', _getPlatformDisplayName()),
          const SizedBox(height: 16),
          if (latestVersion.category.description.isNotEmpty) ...[
            Text(
              'What\'s New:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              latestVersion.category.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (onSkip != null)
          TextButton(
            onPressed: onSkip,
            child: const Text(
              'Skip',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ElevatedButton(
          onPressed: onUpdate,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Update on ${getAppStoreName()}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildVersionInfo(String label, String version) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            version,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getPlatformDisplayName() {
    switch (platform) {
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
} 